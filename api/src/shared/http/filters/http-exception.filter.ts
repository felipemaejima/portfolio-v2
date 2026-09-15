import {
  type ArgumentsHost,
  Catch,
  type ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import type { Request, Response } from 'express';
import { ErrorCode, type ErrorResponseDto } from '../dto/error-response.dto.js';
import { DomainError } from '../errors/domain.errors.js';

const MESSAGES: Record<ErrorCode, string> = {
  [ErrorCode.BAD_REQUEST]: 'Requisição inválida.',
  [ErrorCode.UNAUTHENTICATED]: 'Não autenticado.',
  [ErrorCode.NOT_FOUND]: 'Recurso não encontrado.',
  [ErrorCode.PAYLOAD_TOO_LARGE]: 'Arquivo acima do limite.',
  [ErrorCode.UNSUPPORTED_MEDIA_TYPE]: 'Tipo de arquivo não aceito.',
  [ErrorCode.VALIDATION_FAILED]: 'Dados inválidos.',
  [ErrorCode.RATE_LIMITED]: 'Muitas tentativas. Aguarde um instante.',
  [ErrorCode.INTERNAL]: 'Erro interno.',
};

const STATUS_TO_CODE: Partial<Record<number, ErrorCode>> = {
  [HttpStatus.BAD_REQUEST]: ErrorCode.BAD_REQUEST,
  [HttpStatus.UNAUTHORIZED]: ErrorCode.UNAUTHENTICATED,
  [HttpStatus.NOT_FOUND]: ErrorCode.NOT_FOUND,
  [HttpStatus.PAYLOAD_TOO_LARGE]: ErrorCode.PAYLOAD_TOO_LARGE,
  [HttpStatus.UNSUPPORTED_MEDIA_TYPE]: ErrorCode.UNSUPPORTED_MEDIA_TYPE,
  [HttpStatus.UNPROCESSABLE_ENTITY]: ErrorCode.VALIDATION_FAILED,
  [HttpStatus.TOO_MANY_REQUESTS]: ErrorCode.RATE_LIMITED,
};

/** Único ponto que produz o corpo de erro do contrato (GLOBAL.md §7). */
@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(HttpExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const res = ctx.getResponse<Response>();
    const req = ctx.getRequest<Request>();
    const body = toErrorResponse(exception);

    if (body.statusCode >= 500) {
      this.logger.error(
        `${req.method} ${req.url} → ${body.statusCode}`,
        (exception as Error)?.stack,
      );
    }

    res.status(body.statusCode).json(body);
  }
}

export function toErrorResponse(exception: unknown): ErrorResponseDto {
  if (exception instanceof DomainError) {
    return {
      statusCode: exception.status,
      code: exception.code,
      message: exception.message,
      ...(exception.details ? { details: exception.details } : {}),
    };
  }

  if (exception instanceof HttpException) {
    const statusCode = exception.getStatus();
    if (statusCode >= 500) {
      return { statusCode, code: ErrorCode.INTERNAL, message: MESSAGES[ErrorCode.INTERNAL] };
    }
    const code = STATUS_TO_CODE[statusCode] ?? ErrorCode.BAD_REQUEST;
    return { statusCode, code, message: MESSAGES[code] };
  }

  return { statusCode: 500, code: ErrorCode.INTERNAL, message: MESSAGES[ErrorCode.INTERNAL] };
}
