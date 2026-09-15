import type { INestApplication } from '@nestjs/common';
import { DocumentBuilder, type OpenAPIObject, SwaggerModule } from '@nestjs/swagger';
import { ErrorResponseDto } from '../shared/http/dto/error-response.dto.js';

/**
 * Fonte do cliente Dart (ADR 0004). operationId = nome do método do
 * controller, logo nomes de método são globais e únicos.
 */
export function buildOpenApiDocument(app: INestApplication): OpenAPIObject {
  const config = new DocumentBuilder()
    .setTitle('Portfolio API')
    .setDescription('Contrato da API do portfólio. Ver .specs/GLOBAL.md.')
    .setVersion('1')
    .addBearerAuth()
    .build();

  return SwaggerModule.createDocument(app, config, {
    operationIdFactory: (_controllerKey, methodKey) => methodKey,
    // sempre presente no contrato, mesmo antes de qualquer rota referenciá-lo
    extraModels: [ErrorResponseDto],
  });
}
