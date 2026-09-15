import { ErrorCode } from '../dto/error-response.dto.js';

/**
 * Exceções lançadas por services. Não conhecem HTTP: o HttpExceptionFilter
 * traduz para o ErrorResponse do contrato.
 */
export abstract class DomainError extends Error {
  abstract readonly code: ErrorCode;
  abstract readonly status: number;
  readonly details?: Record<string, string[]>;

  protected constructor(message: string) {
    super(message);
    this.name = new.target.name;
  }
}

export class NotFoundError extends DomainError {
  readonly code = ErrorCode.NOT_FOUND;
  readonly status = 404;
  constructor(message = 'Recurso não encontrado.') {
    super(message);
  }
}

export class ValidationError extends DomainError {
  readonly code = ErrorCode.VALIDATION_FAILED;
  readonly status = 422;
  override readonly details: Record<string, string[]>;
  constructor(details: Record<string, string[]>, message = 'Dados inválidos.') {
    super(message);
    this.details = details;
  }
}

export class UnauthenticatedError extends DomainError {
  readonly code = ErrorCode.UNAUTHENTICATED;
  readonly status = 401;
  constructor(message = 'Não autenticado.') {
    super(message);
  }
}

export class UnsupportedMediaTypeError extends DomainError {
  readonly code = ErrorCode.UNSUPPORTED_MEDIA_TYPE;
  readonly status = 415;
  constructor(message = 'Tipo de arquivo não aceito.') {
    super(message);
  }
}

export class PayloadTooLargeError extends DomainError {
  readonly code = ErrorCode.PAYLOAD_TOO_LARGE;
  readonly status = 413;
  constructor(message = 'Arquivo acima do limite.') {
    super(message);
  }
}
