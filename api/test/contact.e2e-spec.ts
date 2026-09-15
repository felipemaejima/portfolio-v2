import type { INestApplication } from '@nestjs/common';
import request from 'supertest';
import type { App } from 'supertest/types';
import { ErrorCode } from '../src/shared/http/dto/error-response.dto.js';
import { PrismaService } from '../src/shared/prisma/prisma.service.js';
import { createTestApp } from './setup/create-test-app.js';
import { adminToken } from './setup/login.js';

describe('contact (e2e)', () => {
  let app: INestApplication<App>;
  let prisma: PrismaService;
  let token: string;
  const api = () => request(app.getHttpServer());
  const auth = (r: request.Test) => r.set('Authorization', `Bearer ${token}`);

  beforeAll(async () => {
    app = await createTestApp();
    prisma = app.get(PrismaService);
    await Promise.all([prisma.contactLink.deleteMany(), prisma.contactMessage.deleteMany()]);
    token = await adminToken(app);
  });

  afterAll(async () => {
    await Promise.all([prisma.contactLink.deleteMany(), prisma.contactMessage.deleteMany()]);
    await app.close();
  });

  describe('contact-links', () => {
    it('CRUD + reorder; leitura pública; url validada por esquema', async () => {
      const gh = (
        await auth(api().post('/api/v1/contact-links'))
          .send({ label: 'GitHub', value: 'github.com/x', url: 'https://github.com/x' })
          .expect(201)
      ).body;
      const mail = (
        await auth(api().post('/api/v1/contact-links'))
          .send({ label: 'E-mail', value: 'x@x.com', url: 'mailto:x@x.com' })
          .expect(201)
      ).body;
      await auth(api().post('/api/v1/contact-links'))
        .send({ label: 'Tel', value: '(11) 9', url: 'tel:+5511999990000' })
        .expect(201);
      const bad = await auth(api().post('/api/v1/contact-links'))
        .send({ label: 'X', value: 'x', url: 'javascript:alert(1)' })
        .expect(422);
      expect(bad.body.details.url).toBeDefined();

      await auth(api().patch('/api/v1/contact-links/reorder'))
        .send({ ids: [mail.id, gh.id] })
        .expect(422);
      const ids = (await api().get('/api/v1/contact-links').expect(200)).body.map(
        (l: { id: string }) => l.id,
      );
      await auth(api().patch('/api/v1/contact-links/reorder'))
        .send({ ids: [...ids].reverse() })
        .expect(204);
      const res = await api().get('/api/v1/contact-links').expect(200);
      expect(res.body.map((l: { label: string }) => l.label)).toEqual(['Tel', 'E-mail', 'GitHub']);

      await api()
        .put(`/api/v1/contact-links/${gh.id}`)
        .send({ label: 'x', value: 'x', url: 'https://x' })
        .expect(401);
      await auth(api().delete(`/api/v1/contact-links/${gh.id}`)).expect(204);
      await auth(api().delete(`/api/v1/contact-links/${gh.id}`)).expect(404);
    });
  });

  describe('contact-messages', () => {
    const send = (
      ip: string,
      body = { name: 'Maria', email: 'maria@example.com', message: 'Olá!' },
    ) => api().post('/api/v1/contact-messages').set('X-Forwarded-For', ip).send(body);

    it('POST público persiste sem corpo de resposta; validação 422', async () => {
      const res = await send('10.1.0.1').expect(201);
      expect(res.body).toEqual({});
      const bad = await send('10.1.0.1', { name: '', email: 'x', message: '' }).expect(422);
      expect(Object.keys(bad.body.details).sort()).toEqual(['email', 'message', 'name']);
      expect(await prisma.contactMessage.count()).toBe(1);
    });

    it('4ª mensagem no mesmo minuto e IP → 429', async () => {
      for (let i = 0; i < 3; i++) await send('203.0.113.7').expect(201);
      const res = await send('203.0.113.7').expect(429);
      expect(res.body.code).toBe(ErrorCode.RATE_LIMITED);
    });

    it('inbox exige Admin; mais recentes primeiro; read idempotente; delete', async () => {
      await api().get('/api/v1/contact-messages').expect(401);
      const list = (await auth(api().get('/api/v1/contact-messages')).expect(200)).body;
      expect(list).toHaveLength(4);
      expect(list.every((m: { readAt: null }) => m.readAt === null)).toBe(true);
      const dates = list.map((m: { createdAt: string }) => m.createdAt);
      expect([...dates].sort().reverse()).toEqual(dates);

      const id = list[0].id;
      const first = (await auth(api().patch(`/api/v1/contact-messages/${id}/read`)).expect(200))
        .body;
      expect(first.readAt).toEqual(expect.any(String));
      const second = (await auth(api().patch(`/api/v1/contact-messages/${id}/read`)).expect(200))
        .body;
      expect(second.readAt).toBe(first.readAt);

      await auth(api().delete(`/api/v1/contact-messages/${id}`)).expect(204);
      await auth(api().patch(`/api/v1/contact-messages/${id}/read`)).expect(404);
    });
  });
});
