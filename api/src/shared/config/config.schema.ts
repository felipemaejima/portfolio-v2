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

  THROTTLE_LOGIN_PER_MIN: z.coerce.number().int().positive().default(5),
  THROTTLE_CONTACT_PER_MIN: z.coerce.number().int().positive().default(3),
});

export type AppConfig = z.infer<typeof configSchema>;
