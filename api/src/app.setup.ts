import type { INestApplication } from '@nestjs/common';
import type { NestExpressApplication } from '@nestjs/platform-express';
import { ConfigService } from '@nestjs/config';
import cookieParser from 'cookie-parser';
import helmet from 'helmet';
import type { AppConfig } from './shared/config/config.schema.js';

// Com barra inicial: o Nest usa o prefixo cru ao montar o handler de 404 no Express.
export const API_PREFIX = '/api/v1';

/**
 * Configuração comum a main.ts, ao emissor de OpenAPI e aos testes e2e:
 * prefixo, cookies e CORS. Pipes/filtros/guards globais são providers
 * (SharedHttpModule, JwtAuthModule) e já vêm com o AppModule.
 */
export function configureApp<T extends INestApplication>(app: T): T {
  const config = app.get(ConfigService<AppConfig, true>);

  app.setGlobalPrefix(API_PREFIX);
  // Headers de segurança. CSP desligado: a API só responde JSON/PDF e a
  // Swagger UI (dev) usa scripts inline; HSTS vem do Caddy (INFRA.md).
  app.use(helmet({ contentSecurityPolicy: false, hsts: false }));
  // helmet 8 não remove mais o X-Powered-By.
  (app as unknown as NestExpressApplication).disable('x-powered-by');
  app.use(cookieParser());
  // Atrás do Caddy (rede do compose) o IP do cliente vem de X-Forwarded-For.
  (app as unknown as NestExpressApplication).set('trust proxy', 'loopback, linklocal, uniquelocal');

  const origins = config.get('CORS_ORIGINS', { infer: true });
  if (origins.length > 0) {
    app.enableCors({ origin: origins, credentials: true });
  }

  return app;
}
