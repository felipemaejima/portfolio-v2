import type { INestApplication } from '@nestjs/common';
import request from 'supertest';
import type { App } from 'supertest/types';
import { PrismaService } from '../src/shared/prisma/prisma.service.js';
import { createTestApp } from './setup/create-test-app.js';
import { adminToken } from './setup/login.js';

describe('cv (e2e)', () => {
  let app: INestApplication<App>;
  let prisma: PrismaService;
  let token: string;
  const api = () => request(app.getHttpServer());

  beforeAll(async () => {
    app = await createTestApp();
    prisma = app.get(PrismaService);
    await prisma.profile.deleteMany();
    await prisma.experience.deleteMany();
    token = await adminToken(app);
  });

  afterAll(async () => {
    await prisma.profile.deleteMany();
    await prisma.experience.deleteMany();
    await app.close();
  });

  it('GET /cv é público, devolve PDF com nome derivado do Profile e sem cache', async () => {
    await api()
      .put('/api/v1/profile')
      .set('Authorization', `Bearer ${token}`)
      .send({
        name: 'Nome Sobrenome',
        headline: 'Dev',
        summary: 's',
        description: 'd',
        location: { city: 'SP', state: 'SP', country: 'BR' },
        availability: ['CLT'],
        workModes: ['REMOTE'],
        languages: [],
      })
      .expect(200);
    await api()
      .post('/api/v1/experiences')
      .set('Authorization', `Bearer ${token}`)
      .send({
        role: 'Dev',
        companyName: 'X',
        activities: ['a'],
        startDate: '2023-01',
        endDate: null,
      })
      .expect(201);

    const res = await api().get('/api/v1/cv').buffer().parse(binaryParser).expect(200);
    expect(res.headers['content-type']).toBe('application/pdf');
    expect(res.headers['content-disposition']).toBe('attachment; filename="cv-nome-sobrenome.pdf"');
    expect(res.headers['cache-control']).toBe('no-store');
    expect((res.body as Buffer).subarray(0, 5).toString()).toBe('%PDF-');
  });
});

function binaryParser(
  res: NodeJS.ReadableStream,
  cb: (err: Error | null, body: Buffer) => void,
): void {
  const chunks: Buffer[] = [];
  res.on('data', (c: Buffer) => chunks.push(c));
  res.on('end', () => cb(null, Buffer.concat(chunks)));
}
