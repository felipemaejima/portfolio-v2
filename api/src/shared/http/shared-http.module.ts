import { Module } from '@nestjs/common';
import { APP_FILTER, APP_PIPE } from '@nestjs/core';
import { HttpExceptionFilter } from './filters/http-exception.filter.js';
import { createValidationPipe } from './pipes/validation.pipe.js';

/** Filtro de erro e pipe de validação globais (API.md §5). */
@Module({
  providers: [
    { provide: APP_FILTER, useClass: HttpExceptionFilter },
    { provide: APP_PIPE, useFactory: createValidationPipe },
  ],
})
export class SharedHttpModule {}
