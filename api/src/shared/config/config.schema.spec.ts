import { configSchemaWithProductionRules } from './config.schema.js';

const base = {
  DATABASE_URL: 'postgresql://u:p@db:5432/x',
  JWT_ACCESS_SECRET: 'a'.repeat(40),
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
        DATABASE_URL: 'postgresql://portfolio:portfolio@db:5432/portfolio',
        JWT_ACCESS_SECRET: 'troque-por-32-bytes-aleatorios-em-base64',
        ADMIN_PASSWORD: 'troque-esta-senha',
        COOKIE_SECURE: 'false',
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
        DATABASE_URL: 'postgresql://portfolio:portfolio@db:5432/portfolio',
      }).sort(),
    ).toEqual(['ADMIN_PASSWORD', 'COOKIE_SECURE', 'DATABASE_URL', 'JWT_ACCESS_SECRET']);
  });

  it('em production um .env correto passa', () => {
    expect(issues({ ...base, NODE_ENV: 'production' })).toEqual([]);
  });
});
