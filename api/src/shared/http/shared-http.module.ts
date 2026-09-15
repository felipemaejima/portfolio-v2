import { Module } from '@nestjs/common';
import { APP_FILTER, APP_GUARD, APP_PIPE } from '@nestjs/core';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { HttpExceptionFilter } from './filters/http-exception.filter.js';
import { createValidationPipe } from './pipes/validation.pipe.js';
import { THROTTLE_DEFAULT_LIMIT, THROTTLE_TTL_MS } from './throttle.js';

/** Filtro de erro, pipe de validação e rate limit globais (API.md §5). */
@Module({
  imports: [ThrottlerModule.forRoot([{ ttl: THROTTLE_TTL_MS, limit: THROTTLE_DEFAULT_LIMIT }])],
  providers: [
    { provide: APP_FILTER, useClass: HttpExceptionFilter },
    { provide: APP_PIPE, useFactory: createValidationPipe },
    { provide: APP_GUARD, useClass: ThrottlerGuard },
  ],
})
export class SharedHttpModule {}
