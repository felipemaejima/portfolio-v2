import type { CookieOptions } from 'express';
import { API_PREFIX } from '../../app.setup.js';

export const REFRESH_COOKIE = 'refresh_token';

/** Cookie httpOnly restrito às rotas de auth (ADR 0002). */
export function refreshCookieOptions(secure: boolean): CookieOptions {
  return { httpOnly: true, secure, sameSite: 'strict', path: `${API_PREFIX}/auth` };
}
