import { Body, Controller, Get, type INestApplication, Post } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import request from 'supertest';
import type { App } from 'supertest/types';
import { CurrentAdmin } from '../src/shared/auth/current-admin.decorator.js';
import type { AuthenticatedAdmin } from '../src/shared/auth/authenticated-admin.js';
import { ErrorCode } from '../src/shared/http/dto/error-response.dto.js';
import { ReorderDto } from '../src/shared/http/dto/reorder.dto.js';
import { createTestApp } from './setup/create-test-app.js';

/** Controller só de teste: exercita guard global, @CurrentAdmin e o pipe. */
@Controller('__probe')
class ProbeController {
  @Get('me')
  me(@CurrentAdmin() admin: AuthenticatedAdmin): AuthenticatedAdmin {
    return admin;
  }

  @Post('reorder')
  reorder(@Body() body: ReorderDto): { count: number } {
    return { count: body.ids.length };
  }
}

describe('fundação (e2e)', () => {
  let app: INestApplication<App>;
  let token: string;

  beforeAll(async () => {
    app = await createTestApp({ controllers: [ProbeController] });
    token = app.get(JwtService).sign({ sub: 'admin-id', email: 'admin@example.com' });
  });

  afterAll(async () => {
    await app.close();
  });

  it('GET /api/v1/health é público e consulta o banco', async () => {
    await request(app.getHttpServer()).get('/api/v1/health').expect(200).expect({ status: 'ok' });
  });

  it('rota inexistente devolve ErrorResponse 404', async () => {
    const res = await request(app.getHttpServer()).get('/api/v1/nao-existe').expect(404);
    expect(res.body).toEqual({
      statusCode: 404,
      code: ErrorCode.NOT_FOUND,
      message: 'Recurso não encontrado.',
    });
  });

  it('rota sem @Public() exige token → 401 UNAUTHENTICATED', async () => {
    const res = await request(app.getHttpServer()).get('/api/v1/__probe/me').expect(401);
    expect(res.body).toEqual({
      statusCode: 401,
      code: ErrorCode.UNAUTHENTICATED,
      message: 'Não autenticado.',
    });
  });

  it('token inválido → 401', async () => {
    await request(app.getHttpServer())
      .get('/api/v1/__probe/me')
      .set('Authorization', 'Bearer nope')
      .expect(401);
  });

  it('token válido popula @CurrentAdmin()', async () => {
    const res = await request(app.getHttpServer())
      .get('/api/v1/__probe/me')
      .set('Authorization', `Bearer ${token}`)
      .expect(200);
    expect(res.body).toEqual({ id: 'admin-id', email: 'admin@example.com' });
  });

  it('body inválido → 422 com details por campo', async () => {
    const res = await request(app.getHttpServer())
      .post('/api/v1/__probe/reorder')
      .set('Authorization', `Bearer ${token}`)
      .send({ ids: [], extra: true })
      .expect(422);
    expect(res.body).toMatchObject({
      statusCode: 422,
      code: ErrorCode.VALIDATION_FAILED,
      message: 'Dados inválidos.',
    });
    expect(res.body.details.ids).toContain('não pode ser vazia');
    expect(res.body.details.extra).toBeDefined();
  });

  it('body válido passa pelo pipe transformado', async () => {
    await request(app.getHttpServer())
      .post('/api/v1/__probe/reorder')
      .set('Authorization', `Bearer ${token}`)
      .send({ ids: ['3f4e1b9a-1c2d-4e5f-8a9b-0c1d2e3f4a5b'] })
      .expect(201)
      .expect({ count: 1 });
  });
});
