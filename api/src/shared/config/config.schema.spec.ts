import { configSchemaWithProductionRules } from './config.schema.js';

const base = {
  DATABASE_URL: 'postgresql://u:p@db:5432/x',
  JWT_ACCESS_SECRET: 'a'.repeat(40),
  PUBLIC_UPLOADS_BASE_URL: 'https://portfolio.example/uploads',
  ADMIN_EMAIL: 'admin@example.com',
  ADMIN_PASSWORD: 'senha-forte-de-verdade',
  COOKIE_SECURE: 'true',
};

function issues(env: Record<string, string>): string[] {
  const result = configSchemaWithProductionRules.safeParse(env);
  return result.success ? [] : result.error.issues.map((i) => String(i.path[0]));
}

describe('regras de produção do .env', () => {
  it('em development os placeholders passam', () => {
    expect(
      issues({
        ...base,
        NODE_ENV: 'development',
        JWT_ACCESS_SECRET: 'troque-por-32-bytes-aleatorios-em-base64',
        ADMIN_PASSWORD: 'troque-esta-senha',
        COOKIE_SECURE: 'false',
        PUBLIC_UPLOADS_BASE_URL: 'http://localhost/uploads',
      }),
    ).toEqual([]);
  });

  it('em production um .env de exemplo derruba o boot, campo a campo', () => {
    expect(
      issues({
        ...base,
        NODE_ENV: 'production',
        JWT_ACCESS_SECRET: 'troque-por-32-bytes-aleatorios-em-base64',
        ADMIN_PASSWORD: 'troque-esta-senha',
        COOKIE_SECURE: 'false',
        PUBLIC_UPLOADS_BASE_URL: 'http://localhost/uploads',
      }).sort(),
    ).toEqual(['ADMIN_PASSWORD', 'COOKIE_SECURE', 'JWT_ACCESS_SECRET', 'PUBLIC_UPLOADS_BASE_URL']);
  });

  it('em production um .env correto passa', () => {
    expect(issues({ ...base, NODE_ENV: 'production' })).toEqual([]);
  });
});
