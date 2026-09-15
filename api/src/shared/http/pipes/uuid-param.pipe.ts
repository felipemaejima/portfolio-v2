import { HttpStatus, ParseUUIDPipe } from '@nestjs/common';

/**
 * `:id` malformado é tratado como recurso inexistente (404), não como 400:
 * para o app não há diferença útil, e evita que um uuid inválido chegue ao
 * Postgres (coluna uuid) e vire 500.
 */
export const UuidParam = new ParseUUIDPipe({ errorHttpStatusCode: HttpStatus.NOT_FOUND });
