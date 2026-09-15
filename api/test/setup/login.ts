import type { INestApplication } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import argon2 from 'argon2';
import type { App } from 'supertest/types';
import { PrismaService } from '../../src/shared/prisma/prisma.service.js';

/** Garante um Admin no banco e devolve um access token válido para ele. */
export async function adminToken(app: INestApplication<App>): Promise<string> {
  const prisma = app.get(PrismaService);
  const email = 'admin@example.com';
  const admin = await prisma.admin.upsert({
    where: { email },
    update: {},
    create: { email, passwordHash: await argon2.hash('senha-correta', { type: argon2.argon2id }) },
  });
  return app.get(JwtService).sign({ sub: admin.id, email: admin.email });
}
