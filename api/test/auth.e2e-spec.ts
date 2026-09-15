import type { INestApplication } from '@nestjs/common';
import argon2 from 'argon2';
import request from 'supertest';
import type { App } from 'supertest/types';
import { ErrorCode } from '../src/shared/http/dto/error-response.dto.js';
import { PrismaService } from '../src/shared/prisma/prisma.service.js';
import { createTestApp } from './setup/create-test-app.js';

const EMAIL = 'admin@example.com';
const PASSWORD = 'senha-correta';
const COOKIE = 'refresh_token';

function cookieFrom(res: request.Response): string | undefined {
  const header = res.headers['set-cookie'] as string[] | string | undefined;
  const list = Array.isArray(header) ? header : header ? [header] : [];
  return list.find((c) => c.startsWith(`${COOKIE}=`));
}

function cookieValue(setCookie: string): string {
  return setCookie.split(';')[0]!.slice(COOKIE.length + 1);
}

describe('auth (e2e)', () => {
  let app: INestApplication<App>;
  let prisma: PrismaService;
  let adminId: string;

  const login = (clientPlatform: 'WEB' | 'MOBILE', ip = '10.0.0.1', password = PASSWORD) =>
    request(app.getHttpServer())
      .post('/api/v1/auth/login')
      .set('X-Forwarded-For', ip)
      .send({ email: EMAIL, password, clientPlatform });

  beforeAll(async () => {
    app = await createTestApp();
    prisma = app.get(PrismaService);
    await prisma.refreshToken.deleteMany();
    await prisma.admin.deleteMany();
    const admin = await prisma.admin.create({
      data: { email: EMAIL, passwordHash: await argon2.hash(PASSWORD, { type: argon2.argon2id }) },
    });
    adminId = admin.id;
  });

  afterAll(async () => {
    await prisma.refreshToken.deleteMany();
    await prisma.admin.deleteMany();
    await app.close();
  });

  describe('login', () => {
    it('WEB: refresh só no cookie httpOnly, restrito a /api/v1/auth', async () => {
      const res = await login('WEB').expect(200);
      expect(res.body).toEqual({ accessToken: expect.any(String), expiresIn: 900 });
      const cookie = cookieFrom(res)!;
      expect(cookie).toMatch(/HttpOnly/);
      expect(cookie).toMatch(/SameSite=Strict/);
      expect(cookie).toMatch(/Path=\/api\/v1\/auth/);
      expect(cookie).toMatch(/Expires=/);
    });

    it('MOBILE: refresh no body, sem cookie', async () => {
      const res = await login('MOBILE').expect(200);
      expect(res.body).toEqual({
        accessToken: expect.any(String),
        expiresIn: 900,
        refreshToken: expect.any(String),
      });
      expect(cookieFrom(res)).toBeUndefined();
    });

    it('senha errada → 401 UNAUTHENTICATED', async () => {
      const res = await login('WEB', '10.0.0.2', 'errada').expect(401);
      expect(res.body).toMatchObject({ code: ErrorCode.UNAUTHENTICATED });
      expect(cookieFrom(res)).toBeUndefined();
    });

    it('payload inválido → 422 com details', async () => {
      const res = await request(app.getHttpServer())
        .post('/api/v1/auth/login')
        .send({ email: 'x', password: '', clientPlatform: 'TV' })
        .expect(422);
      expect(Object.keys(res.body.details).sort()).toEqual(['clientPlatform', 'email', 'password']);
    });

    it('6ª tentativa no mesmo minuto e IP → 429 RATE_LIMITED', async () => {
      const ip = '203.0.113.9';
      for (let i = 0; i < 5; i++) await login('WEB', ip, 'errada').expect(401);
      const res = await login('WEB', ip).expect(429);
      expect(res.body).toMatchObject({ statusCode: 429, code: ErrorCode.RATE_LIMITED });
    });
  });

  describe('refresh', () => {
    it('WEB: lê o cookie, rotaciona e devolve cookie novo', async () => {
      const first = cookieFrom(await login('WEB', '10.0.1.1').expect(200))!;
      const res = await request(app.getHttpServer())
        .post('/api/v1/auth/refresh')
        .set('Cookie', first.split(';')[0]!)
        .expect(200);
      expect(res.body).toEqual({ accessToken: expect.any(String), expiresIn: 900 });
      const second = cookieFrom(res)!;
      expect(cookieValue(second)).not.toBe(cookieValue(first));
    });

    it('MOBILE: lê o body e devolve refresh novo no body', async () => {
      const first = (await login('MOBILE', '10.0.1.2').expect(200)).body.refreshToken as string;
      const res = await request(app.getHttpServer())
        .post('/api/v1/auth/refresh')
        .send({ refreshToken: first })
        .expect(200);
      expect(res.body.refreshToken).toEqual(expect.any(String));
      expect(res.body.refreshToken).not.toBe(first);
      expect(cookieFrom(res)).toBeUndefined();
    });

    it('reuso do refresh antigo → 401 e a família inteira morre', async () => {
      const first = (await login('MOBILE', '10.0.1.3').expect(200)).body.refreshToken as string;
      const second = (
        await request(app.getHttpServer())
          .post('/api/v1/auth/refresh')
          .send({ refreshToken: first })
          .expect(200)
      ).body.refreshToken as string;

      await request(app.getHttpServer())
        .post('/api/v1/auth/refresh')
        .send({ refreshToken: first })
        .expect(401);
      await request(app.getHttpServer())
        .post('/api/v1/auth/refresh')
        .send({ refreshToken: second })
        .expect(401);
    });

    it('sem refresh algum → 401', async () => {
      const res = await request(app.getHttpServer())
        .post('/api/v1/auth/refresh')
        .send({})
        .expect(401);
      expect(res.body).toMatchObject({ code: ErrorCode.UNAUTHENTICATED });
    });

    it('cookie vindo de outro site (Sec-Fetch-Site: cross-site) → 401 sem rotacionar', async () => {
      const cookie = cookieFrom(await login('WEB', '10.0.1.4').expect(200))!;
      await request(app.getHttpServer())
        .post('/api/v1/auth/refresh')
        .set('Cookie', cookie.split(';')[0]!)
        .set('Sec-Fetch-Site', 'cross-site')
        .expect(401);
      // o refresh continua válido: o guard barrou antes da rotação
      await request(app.getHttpServer())
        .post('/api/v1/auth/refresh')
        .set('Cookie', cookie.split(';')[0]!)
        .set('Sec-Fetch-Site', 'same-origin')
        .expect(200);
    });
  });

  describe('logout', () => {
    it('exige access token', async () => {
      await request(app.getHttpServer()).post('/api/v1/auth/logout').expect(401);
    });

    it('WEB: revoga a família e expira o cookie', async () => {
      const loginRes = await login('WEB', '10.0.2.1').expect(200);
      const cookie = cookieFrom(loginRes)!;
      const res = await request(app.getHttpServer())
        .post('/api/v1/auth/logout')
        .set('Authorization', `Bearer ${loginRes.body.accessToken}`)
        .set('Cookie', cookie.split(';')[0]!)
        .expect(204);
      expect(cookieFrom(res)).toMatch(/Expires=Thu, 01 Jan 1970/);
      await request(app.getHttpServer())
        .post('/api/v1/auth/refresh')
        .set('Cookie', cookie.split(';')[0]!)
        .expect(401);
    });

    it('MOBILE: revoga o refresh do body', async () => {
      const loginRes = await login('MOBILE', '10.0.2.2').expect(200);
      await request(app.getHttpServer())
        .post('/api/v1/auth/logout')
        .set('Authorization', `Bearer ${loginRes.body.accessToken}`)
        .send({ refreshToken: loginRes.body.refreshToken })
        .expect(204);
      await request(app.getHttpServer())
        .post('/api/v1/auth/refresh')
        .send({ refreshToken: loginRes.body.refreshToken })
        .expect(401);
    });
  });

  describe('me', () => {
    it('devolve id e e-mail do Admin, nunca o hash', async () => {
      const loginRes = await login('MOBILE', '10.0.3.1').expect(200);
      const res = await request(app.getHttpServer())
        .get('/api/v1/auth/me')
        .set('Authorization', `Bearer ${loginRes.body.accessToken}`)
        .expect(200);
      expect(res.body).toEqual({ id: adminId, email: EMAIL });
    });

    it('sem token → 401', async () => {
      await request(app.getHttpServer()).get('/api/v1/auth/me').expect(401);
    });
  });
});
