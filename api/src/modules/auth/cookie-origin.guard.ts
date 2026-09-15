import { type CanActivate, type ExecutionContext, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Request } from 'express';
import type { AppConfig } from '../../shared/config/config.schema.js';
import { UnauthenticatedError } from '../../shared/http/errors/domain.errors.js';
import { REFRESH_COOKIE } from './refresh-cookie.js';

/**
 * Defesa extra ao SameSite=Strict (ADR 0002): uma request que traz o cookie
 * de refresh precisa vir da mesma origem/site. Requests sem cookie (mobile)
 * passam direto.
 */
@Injectable()
export class CookieOriginGuard implements CanActivate {
  constructor(private readonly config: ConfigService<AppConfig, true>) {}

  canActivate(context: ExecutionContext): boolean {
    const req = context.switchToHttp().getRequest<Request>();
    if (!req.cookies?.[REFRESH_COOKIE]) return true;
    if (!isTrustedOrigin(req, this.config.get('CORS_ORIGINS', { infer: true }))) {
      throw new UnauthenticatedError('Cookie de sessão recusado para esta origem.');
    }
    return true;
  }
}

export function isTrustedOrigin(req: Request, allowedOrigins: string[]): boolean {
  const fetchSite = req.get('sec-fetch-site');
  if (fetchSite) return fetchSite !== 'cross-site';

  const origin = req.get('origin') ?? referrerOrigin(req.get('referer'));
  if (!origin) return true; // sem sinal de browser: nada a comparar

  if (allowedOrigins.includes(origin)) return true;
  try {
    return new URL(origin).host === req.get('host');
  } catch {
    return false;
  }
}

function referrerOrigin(referer: string | undefined): string | undefined {
  if (!referer) return undefined;
  try {
    return new URL(referer).origin;
  } catch {
    return undefined;
  }
}
