import { ValidationPipe, type ValidationError as ClassValidatorError } from '@nestjs/common';
import { ValidationError } from '../errors/domain.errors.js';

/** Achata erros aninhados do class-validator em `{ 'campo.sub': ['msg'] }`. */
export function toDetails(errors: ClassValidatorError[], prefix = ''): Record<string, string[]> {
  const details: Record<string, string[]> = {};
  for (const error of errors) {
    const path = prefix ? `${prefix}.${error.property}` : error.property;
    const messages = Object.values(error.constraints ?? {});
    if (messages.length) details[path] = messages;
    if (error.children?.length) Object.assign(details, toDetails(error.children, path));
  }
  return details;
}

export function createValidationPipe(): ValidationPipe {
  return new ValidationPipe({
    whitelist: true,
    forbidNonWhitelisted: true,
    transform: true,
    stopAtFirstError: false,
    exceptionFactory: (errors) => new ValidationError(toDetails(errors)),
  });
}
