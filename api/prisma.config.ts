// Variáveis de ambiente vêm do compose (.env na raiz do repo) — sem dotenv aqui.
import { defineConfig } from 'prisma/config';

export default defineConfig({
  schema: 'prisma/schema.prisma',
  migrations: {
    path: 'prisma/migrations',
    seed: 'tsx src/seed.ts',
  },
  datasource: {
    url: process.env['DATABASE_URL'],
  },
});
