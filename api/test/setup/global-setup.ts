import { execSync } from 'node:child_process';
import { existsSync } from 'node:fs';
import path from 'node:path';

/** Aplica as migrations no banco de teste antes da suíte e2e. */
export default function globalSetup(): void {
  const url = process.env['DATABASE_URL_TEST'] ?? process.env['DATABASE_URL'];
  if (!url) throw new Error('DATABASE_URL_TEST (ou DATABASE_URL) é obrigatória para os testes e2e');

  const migrations = path.resolve(import.meta.dirname, '../../prisma/migrations');
  if (!existsSync(migrations)) return; // sem migrations ainda (fase 0)

  execSync('pnpm prisma migrate deploy', {
    stdio: 'inherit',
    env: { ...process.env, DATABASE_URL: url },
  });
}
