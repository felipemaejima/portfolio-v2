import type { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import cookieParser from 'cookie-parser';
import type { AppConfig } from './shared/config/config.schema.js';

// Com barra inicial: o Nest usa o prefixo cru ao montar o handler de 404 no Express.
export const API_PREFIX = '/api/v1';

/**
 * Configuração comum a main.ts, ao emissor de OpenAPI e aos testes e2e:
 * prefixo, cookies e CORS. Pipes/filtros/guards globais são providers
 * (SharedHttpModule, JwtAuthModule) e já vêm com o AppModule.
 */
export function configureApp(app: INestApplication): INestApplication {
  const config = app.get(ConfigService<AppConfig, true>);

  app.setGlobalPrefix(API_PREFIX);
  app.use(cookieParser());

  const origins = config.get('CORS_ORIGINS', { infer: true });
  if (origins.length > 0) {
    app.enableCors({ origin: origins, credentials: true });
  }

  return app;
}
