import type { INestApplication } from '@nestjs/common';
import request from 'supertest';
import type { App } from 'supertest/types';
import { PrismaService } from '../src/shared/prisma/prisma.service.js';
import { createTestApp } from './setup/create-test-app.js';
import { adminToken } from './setup/login.js';

describe('skills (e2e)', () => {
  let app: INestApplication<App>;
  let prisma: PrismaService;
  let token: string;
  const api = () => request(app.getHttpServer());
  const auth = (r: request.Test) => r.set('Authorization', `Bearer ${token}`);
  let langs: string;
  let dbs: string;
  let ts: string;

  beforeAll(async () => {
    app = await createTestApp();
    prisma = app.get(PrismaService);
    await prisma.skillCategory.deleteMany();
    token = await adminToken(app);
  });

  afterAll(async () => {
    await prisma.skillCategory.deleteMany();
    await app.close();
  });

  it('cria categorias e skills; listagem pública aninhada e ordenada', async () => {
    langs = (
      await auth(api().post('/api/v1/skill-categories')).send({ name: 'Linguagens' }).expect(201)
    ).body.id;
    dbs = (await auth(api().post('/api/v1/skill-categories')).send({ name: 'Bancos' }).expect(201))
      .body.id;
    ts = (
      await auth(api().post(`/api/v1/skill-categories/${langs}/skills`))
        .send({ name: 'TypeScript' })
        .expect(201)
    ).body.id;
    await auth(api().post(`/api/v1/skill-categories/${langs}/skills`))
      .send({ name: 'Dart' })
      .expect(201);
    await auth(api().post(`/api/v1/skill-categories/${dbs}/skills`))
      .send({ name: 'PostgreSQL' })
      .expect(201);

    const res = await api().get('/api/v1/skill-categories').expect(200);
    expect(res.body.map((c: { name: string }) => c.name)).toEqual(['Linguagens', 'Bancos']);
    expect(
      res.body[0].skills.map((s: { name: string; position: number }) => [s.name, s.position]),
    ).toEqual([
      ['TypeScript', 0],
      ['Dart', 1],
    ]);
  });

  it('valida entradas e ids', async () => {
    const res = await auth(api().post('/api/v1/skill-categories')).send({ name: '' }).expect(422);
    expect(res.body.details.name).toBeDefined();
    await auth(api().post('/api/v1/skill-categories/nao-uuid/skills'))
      .send({ name: 'x' })
      .expect(404);
    await auth(api().put('/api/v1/skills/3f4e1b9a-1c2d-4e5f-8a9b-0c1d2e3f4a5b'))
      .send({ name: 'x', categoryId: langs })
      .expect(404);
    await auth(api().put(`/api/v1/skills/${ts}`))
      .send({ name: 'x', categoryId: 'nao-uuid' })
      .expect(422);
  });

  it('escrita exige Admin', async () => {
    await api().post('/api/v1/skill-categories').send({ name: 'x' }).expect(401);
    await api().put(`/api/v1/skills/${ts}`).send({ name: 'x', categoryId: langs }).expect(401);
    await api()
      .patch('/api/v1/skill-categories/reorder')
      .send({ ids: [langs, dbs] })
      .expect(401);
  });

  it('reorder de categorias e de skills', async () => {
    await auth(api().patch('/api/v1/skill-categories/reorder'))
      .send({ ids: [dbs, langs] })
      .expect(204);
    let res = await api().get('/api/v1/skill-categories').expect(200);
    expect(res.body.map((c: { name: string }) => c.name)).toEqual(['Bancos', 'Linguagens']);

    const skillIds = res.body[1].skills.map((s: { id: string }) => s.id);
    await auth(api().patch(`/api/v1/skill-categories/${langs}/skills/reorder`))
      .send({ ids: [skillIds[0]] })
      .expect(422);
    await auth(api().patch(`/api/v1/skill-categories/${langs}/skills/reorder`))
      .send({ ids: [...skillIds].reverse() })
      .expect(204);
    res = await api().get('/api/v1/skill-categories').expect(200);
    expect(res.body[1].skills.map((s: { name: string }) => s.name)).toEqual(['Dart', 'TypeScript']);
  });

  it('PUT /skills/{id} move de categoria para o fim da nova', async () => {
    const res = await auth(api().put(`/api/v1/skills/${ts}`))
      .send({ name: 'TypeScript', categoryId: dbs })
      .expect(200);
    expect(res.body).toMatchObject({ categoryId: dbs, position: 1 });
    const list = await api().get('/api/v1/skill-categories').expect(200);
    expect(list.body[0].skills.map((s: { name: string }) => s.name)).toEqual([
      'PostgreSQL',
      'TypeScript',
    ]);
  });

  it('DELETE de skill e de categoria (cascata)', async () => {
    await auth(api().delete(`/api/v1/skills/${ts}`)).expect(204);
    await auth(api().delete(`/api/v1/skills/${ts}`)).expect(404);
    await auth(api().delete(`/api/v1/skill-categories/${langs}`)).expect(204);
    const res = await api().get('/api/v1/skill-categories').expect(200);
    expect(res.body).toHaveLength(1);
    expect(await prisma.skill.count()).toBe(1);
  });
});
