import { applyDecorators, HttpStatus } from '@nestjs/common';
import { ApiResponse } from '@nestjs/swagger';
import { ErrorResponseDto } from '../dto/error-response.dto.js';

const DESCRIPTIONS: Partial<Record<number, string>> = {
  [HttpStatus.BAD_REQUEST]: 'Requisição malformada',
  [HttpStatus.UNAUTHORIZED]: 'Não autenticado',
  [HttpStatus.NOT_FOUND]: 'Recurso não encontrado',
  [HttpStatus.PAYLOAD_TOO_LARGE]: 'Arquivo acima do limite',
  [HttpStatus.UNSUPPORTED_MEDIA_TYPE]: 'Tipo de arquivo não aceito',
  [HttpStatus.UNPROCESSABLE_ENTITY]: 'Falha de validação',
  [HttpStatus.TOO_MANY_REQUESTS]: 'Rate limit',
};

/**
 * Declara no OpenAPI os erros possíveis de um handler, todos com o corpo
 * ErrorResponse. 500 entra sempre.
 */
export function ApiErrorResponses(...statuses: HttpStatus[]): MethodDecorator & ClassDecorator {
  const all = [...new Set([...statuses, HttpStatus.INTERNAL_SERVER_ERROR])];
  return applyDecorators(
    ...all.map((status) =>
      ApiResponse({
        status,
        type: ErrorResponseDto,
        description: DESCRIPTIONS[status] ?? 'Erro interno',
      }),
    ),
  );
}
