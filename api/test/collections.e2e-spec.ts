import type { INestApplication } from '@nestjs/common';
import request from 'supertest';
import type { App } from 'supertest/types';
import { PrismaService } from '../src/shared/prisma/prisma.service.js';
import { createTestApp } from './setup/create-test-app.js';
import { adminToken } from './setup/login.js';

describe('experiences / educations / offerings (e2e)', () => {
  let app: INestApplication<App>;
  let prisma: PrismaService;
  let token: string;
  const api = () => request(app.getHttpServer());
  const auth = (r: request.Test) => r.set('Authorization', `Bearer ${token}`);

  beforeAll(async () => {
    app = await createTestApp();
    prisma = app.get(PrismaService);
    await Promise.all([
      prisma.experience.deleteMany(),
      prisma.education.deleteMany(),
      prisma.offering.deleteMany(),
    ]);
    token = await adminToken(app);
  });

  afterAll(async () => {
    await Promise.all([
      prisma.experience.deleteMany(),
      prisma.education.deleteMany(),
      prisma.offering.deleteMany(),
    ]);
    await app.close();
  });

  describe('experiences', () => {
    const base = { role: 'Dev', companyName: 'Empresa', activities: ['Fez coisas'] };

    it('lista pública: atual primeiro, depois as mais recentes', async () => {
      await auth(api().post('/api/v1/experiences'))
        .send({ ...base, startDate: '2020-06', endDate: '2021-02' })
        .expect(201);
      await auth(api().post('/api/v1/experiences'))
        .send({ ...base, startDate: '2023-01', endDate: null })
        .expect(201);
      await auth(api().post('/api/v1/experiences'))
        .send({ ...base, startDate: '2021-03', endDate: '2022-12' })
        .expect(201);
      const res = await api().get('/api/v1/experiences').expect(200);
      expect(res.body.map((e: { startDate: string }) => e.startDate)).toEqual([
        '2023-01',
        '2021-03',
        '2020-06',
      ]);
    });

    it('valida formato YYYY-MM e fim antes do início', async () => {
      const bad = await auth(api().post('/api/v1/experiences'))
        .send({ ...base, startDate: '2023-13' })
        .expect(422);
      expect(bad.body.details.startDate).toBeDefined();
      const order = await auth(api().post('/api/v1/experiences'))
        .send({ ...base, startDate: '2023-06', endDate: '2023-01' })
        .expect(422);
      expect(order.body.details.endDate).toEqual(['não pode ser anterior ao início']);
    });

    it('PUT/DELETE exigem Admin; 404 para inexistente', async () => {
      const id = (await api().get('/api/v1/experiences')).body[0].id;
      await api()
        .put(`/api/v1/experiences/${id}`)
        .send({ ...base, startDate: '2023-01' })
        .expect(401);
      const res = await auth(api().put(`/api/v1/experiences/${id}`))
        .send({ ...base, role: 'Lead', startDate: '2023-01' })
        .expect(200);
      expect(res.body).toMatchObject({ role: 'Lead', endDate: null });
      await auth(api().delete(`/api/v1/experiences/${id}`)).expect(204);
      await auth(api().delete(`/api/v1/experiences/${id}`)).expect(404);
    });
  });

  describe('educations', () => {
    const base = { courseName: 'Curso', institution: 'Instituição' };

    it('lista pública: em andamento primeiro, depois as mais recentes', async () => {
      await auth(api().post('/api/v1/educations'))
        .send({ ...base, startYear: 2017, endYear: 2021 })
        .expect(201);
      await auth(api().post('/api/v1/educations'))
        .send({ ...base, startYear: 2023, endYear: 2023 })
        .expect(201);
      await auth(api().post('/api/v1/educations'))
        .send({ ...base, startYear: 2024, endYear: null })
        .expect(201);
      const res = await api().get('/api/v1/educations').expect(200);
      expect(res.body.map((e: { startYear: number }) => e.startYear)).toEqual([2024, 2023, 2017]);
    });

    it('valida anos', async () => {
      const bad = await auth(api().post('/api/v1/educations'))
        .send({ ...base, startYear: 2021, endYear: 2019 })
        .expect(422);
      expect(bad.body.details.endYear).toBeDefined();
      const type = await auth(api().post('/api/v1/educations'))
        .send({ ...base, startYear: '2021' })
        .expect(422);
      expect(type.body.details.startYear).toBeDefined();
    });
  });

  describe('offerings', () => {
    it('CRUD + reorder, público na leitura', async () => {
      const a = (
        await auth(api().post('/api/v1/offerings'))
          .send({ title: 'Web', description: 'Sites.' })
          .expect(201)
      ).body;
      const b = (
        await auth(api().post('/api/v1/offerings'))
          .send({ title: 'APIs', description: 'Integrações.' })
          .expect(201)
      ).body;
      expect([a.position, b.position]).toEqual([0, 1]);
      await api().post('/api/v1/offerings').send({ title: 'x', description: 'y' }).expect(401);

      await auth(api().patch('/api/v1/offerings/reorder'))
        .send({ ids: [b.id] })
        .expect(422);
      await auth(api().patch('/api/v1/offerings/reorder'))
        .send({ ids: [b.id, a.id] })
        .expect(204);
      const res = await api().get('/api/v1/offerings').expect(200);
      expect(res.body.map((o: { title: string }) => o.title)).toEqual(['APIs', 'Web']);

      await auth(api().put(`/api/v1/offerings/${a.id}`))
        .send({ title: 'Web apps', description: 'Sites.' })
        .expect(200);
      await auth(api().delete(`/api/v1/offerings/${a.id}`)).expect(204);
      expect((await api().get('/api/v1/offerings')).body).toHaveLength(1);
    });
  });
});
