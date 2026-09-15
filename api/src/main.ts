import { NestFactory } from '@nestjs/core';
import { ConfigService } from '@nestjs/config';
import { SwaggerModule } from '@nestjs/swagger';
import { AppModule } from './app.module.js';
import { configureApp } from './app.setup.js';
import { buildOpenApiDocument } from './openapi/document.js';
import type { AppConfig } from './shared/config/config.schema.js';

const app = configureApp(await NestFactory.create(AppModule));
const config = app.get(ConfigService<AppConfig, true>);

if (config.get('NODE_ENV', { infer: true }) === 'development') {
  SwaggerModule.setup('api/docs', app, () => buildOpenApiDocument(app));
}

app.enableShutdownHooks();
await app.listen(config.get('PORT', { infer: true }));
