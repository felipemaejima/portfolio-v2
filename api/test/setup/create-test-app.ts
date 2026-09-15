import type { INestApplication, ModuleMetadata } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import type { App } from 'supertest/types';
import { AppModule } from '../../src/app.module.js';
import { configureApp } from '../../src/app.setup.js';

/**
 * App completa (guards, pipes, filtro, prefixo) como em produção.
 * `extra` permite registrar controllers só de teste.
 */
export async function createTestApp(extra: ModuleMetadata = {}): Promise<INestApplication<App>> {
  const moduleRef = await Test.createTestingModule({
    imports: [AppModule, ...(extra.imports ?? [])],
    controllers: extra.controllers ?? [],
    providers: extra.providers ?? [],
  }).compile();

  const app = configureApp(moduleRef.createNestApplication<INestApplication<App>>());
  await app.init();
  return app;
}
