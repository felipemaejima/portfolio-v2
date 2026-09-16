import { z } from 'zod';

const csv = z
  .string()
  .default('')
  .transform((s) =>
    s
      .split(',')
      .map((x) => x.trim())
      .filter(Boolean),
  );

/** Fonte única das variáveis de ambiente da API. Tabela: INFRA.md §4. */
export const configSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  PORT: z.coerce.number().int().positive().default(3000),

  DATABASE_URL: z.url(),

  JWT_ACCESS_SECRET: z.string().min(32, 'JWT_ACCESS_SECRET precisa de pelo menos 32 caracteres'),
  JWT_ACCESS_TTL: z.string().default('15m'),
  REFRESH_TTL_DAYS: z.coerce.number().int().positive().default(30),
  COOKIE_SECURE: z.stringbool().default(false),
  CORS_ORIGINS: csv,

  UPLOADS_DIR: z.string().default('/data/uploads'),
  PUBLIC_UPLOADS_BASE_URL: z.url(),
  MAX_UPLOAD_BYTES: z.coerce
    .number()
    .int()
    .positive()
    .default(5 * 1024 * 1024),

  ADMIN_EMAIL: z.email(),
  ADMIN_PASSWORD: z.string().min(8),
});

export type AppConfig = z.infer<typeof configSchema>;

/** Valores que o .env.example traz de fábrica: aceitos em dev, proibidos em produção. */
const PLACEHOLDER = /troque/i;

/**
 * Regras que só fazem sentido em produção. Falham o boot em vez de subir
 * uma API com segredo de exemplo, senha de exemplo ou cookie sem `Secure`.
 */
export const configSchemaWithProductionRules = configSchema.superRefine((env, ctx) => {
  if (env.NODE_ENV !== 'production') return;
  const fail = (path: keyof AppConfig, message: string) =>
    ctx.addIssue({ code: 'custom', path: [path], message });

  if (PLACEHOLDER.test(env.JWT_ACCESS_SECRET))
    fail('JWT_ACCESS_SECRET', 'segredo de exemplo em produção');
  if (PLACEHOLDER.test(env.ADMIN_PASSWORD)) fail('ADMIN_PASSWORD', 'senha de exemplo em produção');
  if (!env.COOKIE_SECURE)
    fail('COOKIE_SECURE', 'deve ser true em produção (cookie de refresh só via HTTPS)');
  if (!env.PUBLIC_UPLOADS_BASE_URL.startsWith('https://')) {
    fail('PUBLIC_UPLOADS_BASE_URL', 'deve ser https:// em produção');
  }
});
