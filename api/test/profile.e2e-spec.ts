import { access, rm } from 'node:fs/promises';
import path from 'node:path';
import type { INestApplication } from '@nestjs/common';
import request from 'supertest';
import type { App } from 'supertest/types';
import { ErrorCode } from '../src/shared/http/dto/error-response.dto.js';
import { PrismaService } from '../src/shared/prisma/prisma.service.js';
import { MAX_UPLOAD_BYTES } from '../src/shared/storage/image-type.js';
import { PNG_1X1 } from './fixtures/images.js';
import { createTestApp } from './setup/create-test-app.js';
import { adminToken } from './setup/login.js';

const UPLOADS_DIR = process.env['UPLOADS_DIR']!;
const BASE_URL = '/uploads';

const VALID_BODY = {
  name: 'Nome Sobrenome',
  headline: 'Desenvolvedor Full-Stack',
  summary: 'Construo aplicações.',
  description: 'Sobre mim.\n\nSegundo parágrafo.',
  location: { city: 'São Paulo', state: 'SP', country: 'Brasil' },
  availability: ['CLT', 'FREELANCE'],
  workModes: ['REMOTE', 'HYBRID'],
  languages: [
    { language: 'Português', level: 'NATIVE' },
    { language: 'Inglês', level: 'ADVANCED' },
  ],
};

function exists(file: string): Promise<boolean> {
  return access(file).then(
    () => true,
    () => false,
  );
}

const keyOf = (url: string) => url.slice(BASE_URL.length + 1);

describe('profile (e2e)', () => {
  let app: INestApplication<App>;
  let prisma: PrismaService;
  let token: string;

  const put = () =>
    request(app.getHttpServer()).put('/api/v1/profile').set('Authorization', `Bearer ${token}`);
  const putImage = () =>
    request(app.getHttpServer())
      .put('/api/v1/profile/image')
      .set('Authorization', `Bearer ${token}`);

  beforeAll(async () => {
    app = await createTestApp();
    prisma = app.get(PrismaService);
    await prisma.profile.deleteMany();
    token = await adminToken(app);
  });

  afterAll(async () => {
    await prisma.profile.deleteMany();
    await rm(path.join(UPLOADS_DIR, 'profile'), { recursive: true, force: true });
    await app.close();
  });

  it('GET /profile é público e devolve o singleton vazio antes de qualquer edição', async () => {
    const res = await request(app.getHttpServer()).get('/api/v1/profile').expect(200);
    expect(res.body).toMatchObject({
      name: '',
      location: { city: '', state: '', country: '' },
      availability: [],
      workModes: [],
      languages: [],
      imageUrl: null,
    });
    expect(res.body).not.toHaveProperty('imageKey');
    expect(res.body).not.toHaveProperty('key');
  });

  it('PUT /profile exige Admin', async () => {
    await request(app.getHttpServer()).put('/api/v1/profile').send(VALID_BODY).expect(401);
  });

  it('PUT /profile substitui tudo e GET reflete', async () => {
    const res = await put().send(VALID_BODY).expect(200);
    expect(res.body).toMatchObject(VALID_BODY);
    expect(res.body.updatedAt).toEqual(expect.any(String));
    const read = await request(app.getHttpServer()).get('/api/v1/profile').expect(200);
    expect(read.body).toEqual(res.body);
  });

  it('PUT /profile valida enums, aninhados e campos extras', async () => {
    const res = await put()
      .send({
        ...VALID_BODY,
        name: '',
        availability: ['CLT', 'CLT', 'FREELA'],
        location: { city: 'x', state: 'y' },
        languages: [{ language: '', level: 'JEDI' }],
        role: 'admin',
      })
      .expect(422);
    expect(res.body.code).toBe(ErrorCode.VALIDATION_FAILED);
    expect(Object.keys(res.body.details).sort()).toEqual([
      'availability',
      'languages.0.language',
      'languages.0.level',
      'location.country',
      'name',
      'role',
    ]);
  });

  describe('imagem', () => {
    it('PUT /profile/image grava no disco e devolve URL pública permanente', async () => {
      const res = await putImage().attach('file', PNG_1X1, 'foto.png').expect(200);
      expect(res.body.imageUrl).toMatch(new RegExp(`^${BASE_URL}/profile/[0-9a-f-]{36}\\.png$`));
      expect(await exists(path.join(UPLOADS_DIR, keyOf(res.body.imageUrl)))).toBe(true);
    });

    it('trocar a foto gera chave nova e apaga a anterior', async () => {
      const first = (await putImage().attach('file', PNG_1X1, 'a.png').expect(200)).body.imageUrl;
      const second = (await putImage().attach('file', PNG_1X1, 'b.png').expect(200)).body.imageUrl;
      expect(second).not.toBe(first);
      expect(await exists(path.join(UPLOADS_DIR, keyOf(first)))).toBe(false);
      expect(await exists(path.join(UPLOADS_DIR, keyOf(second)))).toBe(true);
    });

    it('extensão mente, conteúdo decide: .png com texto → 415', async () => {
      const res = await putImage()
        .attach('file', Buffer.from('não sou imagem'), 'foto.png')
        .expect(415);
      expect(res.body.code).toBe(ErrorCode.UNSUPPORTED_MEDIA_TYPE);
    });

    it('acima de 5 MB → 413', async () => {
      const big = Buffer.concat([PNG_1X1, Buffer.alloc(MAX_UPLOAD_BYTES)]);
      const res = await putImage().attach('file', big, 'grande.png').expect(413);
      expect(res.body.code).toBe(ErrorCode.PAYLOAD_TOO_LARGE);
    });

    it('sem arquivo → 400', async () => {
      const res = await putImage().field('nome', 'x').expect(400);
      expect(res.body.code).toBe(ErrorCode.BAD_REQUEST);
    });

    it('sem token → 401', async () => {
      await request(app.getHttpServer())
        .put('/api/v1/profile/image')
        .attach('file', PNG_1X1, 'a.png')
        .expect(401);
    });

    it('DELETE /profile/image limpa a URL e apaga o arquivo', async () => {
      const url = (await putImage().attach('file', PNG_1X1, 'a.png').expect(200)).body.imageUrl;
      await request(app.getHttpServer())
        .delete('/api/v1/profile/image')
        .set('Authorization', `Bearer ${token}`)
        .expect(204);
      const read = await request(app.getHttpServer()).get('/api/v1/profile').expect(200);
      expect(read.body.imageUrl).toBeNull();
      expect(await exists(path.join(UPLOADS_DIR, keyOf(url)))).toBe(false);
    });
  });
});
