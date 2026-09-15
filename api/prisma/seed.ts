/**
 * Seed idempotente: garante o Admin com ADMIN_EMAIL/ADMIN_PASSWORD do
 * ambiente (upsert por e-mail; a senha é re-hasheada a cada execução).
 * Não há rota de registro — este é o único caminho para criar o Admin.
 */
import { PrismaPg } from '@prisma/adapter-pg';
import argon2 from 'argon2';
import { PrismaClient } from '../src/generated/prisma/client.js';

const email = process.env['ADMIN_EMAIL'];
const password = process.env['ADMIN_PASSWORD'];
const databaseUrl = process.env['DATABASE_URL'];

if (!email || !password || !databaseUrl) {
  throw new Error('ADMIN_EMAIL, ADMIN_PASSWORD e DATABASE_URL são obrigatórios para o seed');
}

const prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString: databaseUrl }) });

try {
  const passwordHash = await argon2.hash(password, { type: argon2.argon2id });
  const admin = await prisma.admin.upsert({
    where: { email },
    update: { passwordHash },
    create: { email, passwordHash },
  });
  console.log(`admin ok: ${admin.email} (${admin.id})`);
} finally {
  await prisma.$disconnect();
}
