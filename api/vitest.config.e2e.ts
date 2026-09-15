import { defineConfig } from 'vitest/config';

// e2e roda contra o Postgres do compose, banco portfolio_test (INFRA.md).
const testDatabaseUrl = process.env['DATABASE_URL_TEST'] ?? process.env['DATABASE_URL'] ?? '';

export default defineConfig({
  resolve: { tsconfigPaths: true },
  test: {
    globals: true,
    root: './',
    include: ['**/*.e2e-spec.ts'],
    globalSetup: ['./test/setup/global-setup.ts'],
    env: { DATABASE_URL: testDatabaseUrl, NODE_ENV: 'test' },
    fileParallelism: false,
    testTimeout: 20_000,
    hookTimeout: 30_000,
  },
});
