import { access, rm } from 'node:fs/promises';
import path from 'node:path';
import type { INestApplication } from '@nestjs/common';
import request from 'supertest';
import type { App } from 'supertest/types';
import { ErrorCode } from '../src/shared/http/dto/error-response.dto.js';
import { PrismaService } from '../src/shared/prisma/prisma.service.js';
import { PNG_1X1 } from './fixtures/images.js';
import { createTestApp } from './setup/create-test-app.js';
import { adminToken } from './setup/login.js';

const UPLOADS_DIR = process.env['UPLOADS_DIR']!;
const BASE_URL = '/uploads';
const keyOf = (url: string) => url.slice(BASE_URL.length + 1);
const exists = (file: string) =>
  access(file).then(
    () => true,
    () => false,
  );

const INPUT = {
  name: 'Portfolio API',
  shortDescription: 'API do portfólio',
  fullDescription: 'Descrição longa.',
  technologies: ['NestJS', 'Prisma'],
  codeUrl: 'https://github.com/x/portfolio',
  demoUrl: null,
};

describe('projects (e2e)', () => {
  let app: INestApplication<App>;
  let prisma: PrismaService;
  let token: string;
  const api = () => request(app.getHttpServer());
  const auth = (r: request.Test) => r.set('Authorization', `Bearer ${token}`);

  beforeAll(async () => {
    app = await createTestApp();
    prisma = app.get(PrismaService);
    await prisma.project.deleteMany();
    token = await adminToken(app);
  });

  afterAll(async () => {
    await prisma.project.deleteMany();
    await rm(path.join(UPLOADS_DIR, 'projects'), { recursive: true, force: true });
    await app.close();
  });

  describe('CRUD', () => {
    let id: string;

    it('POST cria com slug derivado, position 0 e galeria vazia', async () => {
      const res = await auth(api().post('/api/v1/projects')).send(INPUT).expect(201);
      expect(res.body).toMatchObject({ ...INPUT, slug: 'portfolio-api', position: 0, images: [] });
      id = res.body.id;
    });

    it('POST repete o nome → slug com sufixo; entra no fim', async () => {
      const res = await auth(api().post('/api/v1/projects')).send(INPUT).expect(201);
      expect(res.body.slug).toBe('portfolio-api-2');
      expect(res.body.position).toBe(1);
    });

    it('GET /projects é público, ordenado por position', async () => {
      const res = await api().get('/api/v1/projects').expect(200);
      expect(res.body.map((p: { slug: string }) => p.slug)).toEqual([
        'portfolio-api',
        'portfolio-api-2',
      ]);
    });

    it('GET /projects/{slug} público; inexistente → 404', async () => {
      const res = await api().get('/api/v1/projects/portfolio-api').expect(200);
      expect(res.body.id).toBe(id);
      const missing = await api().get('/api/v1/projects/nao-existe').expect(404);
      expect(missing.body.code).toBe(ErrorCode.NOT_FOUND);
    });

    it('PUT substitui campos sem tocar no slug; validação 422', async () => {
      const res = await auth(api().put(`/api/v1/projects/${id}`))
        .send({ ...INPUT, name: 'Renomeado', codeUrl: null })
        .expect(200);
      expect(res.body).toMatchObject({ name: 'Renomeado', slug: 'portfolio-api', codeUrl: null });

      const bad = await auth(api().put(`/api/v1/projects/${id}`))
        .send({ ...INPUT, name: '', technologies: 'x', codeUrl: 'sem-protocolo', slug: 'hack' })
        .expect(422);
      expect(Object.keys(bad.body.details).sort()).toEqual([
        'codeUrl',
        'name',
        'slug',
        'technologies',
      ]);
    });

    it('id malformado ou inexistente → 404', async () => {
      await auth(api().put('/api/v1/projects/nao-uuid')).send(INPUT).expect(404);
      await auth(api().delete('/api/v1/projects/3f4e1b9a-1c2d-4e5f-8a9b-0c1d2e3f4a5b')).expect(404);
    });

    it('escrita exige Admin', async () => {
      await api().post('/api/v1/projects').send(INPUT).expect(401);
      await api().put(`/api/v1/projects/${id}`).send(INPUT).expect(401);
      await api().delete(`/api/v1/projects/${id}`).expect(401);
      await api()
        .patch('/api/v1/projects/reorder')
        .send({ ids: [id] })
        .expect(401);
    });

    it('PATCH reorder aplica a ordem; conjunto incompleto → 422', async () => {
      const ids = (await api().get('/api/v1/projects')).body.map((p: { id: string }) => p.id);
      await auth(api().patch('/api/v1/projects/reorder'))
        .send({ ids: [ids[0]] })
        .expect(422);
      await auth(api().patch('/api/v1/projects/reorder'))
        .send({ ids: [ids[1], ids[0]] })
        .expect(204);
      const after = (await api().get('/api/v1/projects')).body;
      expect(after.map((p: { id: string }) => p.id)).toEqual([ids[1], ids[0]]);
      expect(after.map((p: { position: number }) => p.position)).toEqual([0, 1]);
    });
  });

  describe('galeria', () => {
    let id: string;
    let urls: string[];

    beforeAll(async () => {
      id = (await auth(api().post('/api/v1/projects')).send({ ...INPUT, name: 'Com Galeria' })).body
        .id;
    });

    it('POST /{id}/images aceita vários arquivos e devolve o projeto com a galeria', async () => {
      const res = await auth(api().post(`/api/v1/projects/${id}/images`))
        .attach('files', PNG_1X1, 'a.png')
        .attach('files', PNG_1X1, 'b.png')
        .expect(201);
      urls = res.body.images.map((i: { url: string }) => i.url);
      expect(res.body.images.map((i: { position: number }) => i.position)).toEqual([0, 1]);
      expect(urls[0]).toMatch(new RegExp(`^${BASE_URL}/projects/${id}/[0-9a-f-]{36}\\.png$`));
      for (const url of urls) expect(await exists(path.join(UPLOADS_DIR, keyOf(url)))).toBe(true);
    });

    it('sem arquivo → 400; texto como png → 415 e nada gravado', async () => {
      await auth(api().post(`/api/v1/projects/${id}/images`))
        .field('x', '1')
        .expect(400);
      await auth(api().post(`/api/v1/projects/${id}/images`))
        .attach('files', PNG_1X1, 'ok.png')
        .attach('files', Buffer.from('nope'), 'fake.png')
        .expect(415);
      const res = await api().get('/api/v1/projects/com-galeria').expect(200);
      expect(res.body.images).toHaveLength(2);
    });

    it('limite cumulativo de 12 → 422 em `files`', async () => {
      let req = auth(api().post(`/api/v1/projects/${id}/images`));
      for (let i = 0; i < 10; i++) req = req.attach('files', PNG_1X1, `${i}.png`);
      await req.expect(201);
      const res = await auth(api().post(`/api/v1/projects/${id}/images`))
        .attach('files', PNG_1X1, 'x.png')
        .expect(422);
      expect(res.body.details.files[0]).toMatch(/12/);
    });

    it('PATCH /{id}/images/reorder aplica e valida o conjunto', async () => {
      const images = (await api().get('/api/v1/projects/com-galeria')).body.images as {
        id: string;
      }[];
      const reversed = [...images].reverse().map((i) => i.id);
      await auth(api().patch(`/api/v1/projects/${id}/images/reorder`))
        .send({ ids: reversed.slice(1) })
        .expect(422);
      await auth(api().patch(`/api/v1/projects/${id}/images/reorder`))
        .send({ ids: reversed })
        .expect(204);
      const after = (await api().get('/api/v1/projects/com-galeria')).body.images as {
        id: string;
      }[];
      expect(after.map((i) => i.id)).toEqual(reversed);
    });

    it('DELETE /{id}/images/{imageId} apaga linha e arquivo; de outro projeto → 404', async () => {
      const project = (await api().get('/api/v1/projects/com-galeria')).body;
      const target = project.images[0];
      const other = (await auth(api().post('/api/v1/projects')).send({ ...INPUT, name: 'Outro' }))
        .body.id;
      await auth(api().delete(`/api/v1/projects/${other}/images/${target.id}`)).expect(404);
      await auth(api().delete(`/api/v1/projects/${id}/images/${target.id}`)).expect(204);
      expect(await exists(path.join(UPLOADS_DIR, keyOf(target.url)))).toBe(false);
      expect((await api().get('/api/v1/projects/com-galeria')).body.images).toHaveLength(11);
    });

    it('DELETE /{id} apaga o projeto e todos os arquivos da galeria', async () => {
      const before = (await api().get('/api/v1/projects/com-galeria')).body.images as {
        url: string;
      }[];
      await auth(api().delete(`/api/v1/projects/${id}`)).expect(204);
      await api().get('/api/v1/projects/com-galeria').expect(404);
      for (const img of before)
        expect(await exists(path.join(UPLOADS_DIR, keyOf(img.url)))).toBe(false);
      expect(await prisma.projectImage.count({ where: { projectId: id } })).toBe(0);
    });
  });
});
