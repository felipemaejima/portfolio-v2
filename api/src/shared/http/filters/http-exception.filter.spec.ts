import { HttpException, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { ErrorCode } from '../dto/error-response.dto.js';
import { NotFoundError, ValidationError } from '../errors/domain.errors.js';
import { toErrorResponse } from './http-exception.filter.js';

describe('toErrorResponse', () => {
  it('traduz DomainError com status, code e message', () => {
    expect(toErrorResponse(new NotFoundError('Projeto não encontrado.'))).toEqual({
      statusCode: 404,
      code: ErrorCode.NOT_FOUND,
      message: 'Projeto não encontrado.',
    });
  });

  it('inclui details em ValidationError', () => {
    const error = new ValidationError({ email: ['deve ser um e-mail válido'] });
    expect(toErrorResponse(error)).toEqual({
      statusCode: 422,
      code: ErrorCode.VALIDATION_FAILED,
      message: 'Dados inválidos.',
      details: { email: ['deve ser um e-mail válido'] },
    });
  });

  it('mapeia HttpException do Nest por status, com mensagem PT-BR', () => {
    expect(toErrorResponse(new NotFoundException('Cannot GET /x'))).toEqual({
      statusCode: 404,
      code: ErrorCode.NOT_FOUND,
      message: 'Recurso não encontrado.',
    });
    expect(toErrorResponse(new UnauthorizedException())).toMatchObject({
      statusCode: 401,
      code: ErrorCode.UNAUTHENTICATED,
    });
  });

  it('4xx sem código próprio vira BAD_REQUEST mantendo o status', () => {
    expect(toErrorResponse(new HttpException('x', 405))).toMatchObject({
      statusCode: 405,
      code: ErrorCode.BAD_REQUEST,
    });
  });

  it('qualquer outra coisa é INTERNAL sem vazar mensagem', () => {
    expect(toErrorResponse(new Error('segredo'))).toEqual({
      statusCode: 500,
      code: ErrorCode.INTERNAL,
      message: 'Erro interno.',
    });
    expect(toErrorResponse(new HttpException('segredo', 503))).toMatchObject({
      statusCode: 503,
      code: ErrorCode.INTERNAL,
      message: 'Erro interno.',
    });
  });
});
