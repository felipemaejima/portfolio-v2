import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

/** Códigos de erro do contrato (GLOBAL.md §7). O app decide por `code`, nunca por `message`. */
export enum ErrorCode {
  BAD_REQUEST = 'BAD_REQUEST',
  UNAUTHENTICATED = 'UNAUTHENTICATED',
  NOT_FOUND = 'NOT_FOUND',
  PAYLOAD_TOO_LARGE = 'PAYLOAD_TOO_LARGE',
  UNSUPPORTED_MEDIA_TYPE = 'UNSUPPORTED_MEDIA_TYPE',
  VALIDATION_FAILED = 'VALIDATION_FAILED',
  RATE_LIMITED = 'RATE_LIMITED',
  INTERNAL = 'INTERNAL',
}

export class ErrorResponseDto {
  @ApiProperty({ example: 422 })
  statusCode: number;

  @ApiProperty({ enum: ErrorCode, enumName: 'ErrorCode' })
  code: ErrorCode;

  /** Texto exibível, em PT-BR. */
  @ApiProperty({ example: 'Dados inválidos.' })
  message: string;

  /** Só em VALIDATION_FAILED: mensagens por campo. */
  @ApiPropertyOptional({
    type: 'object',
    additionalProperties: { type: 'array', items: { type: 'string' } },
    example: { email: ['deve ser um e-mail válido'] },
  })
  details?: Record<string, string[]>;
}
