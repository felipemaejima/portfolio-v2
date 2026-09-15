import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import passportJwt from 'passport-jwt';
import type { AppConfig } from '../config/config.schema.js';
import type { AccessTokenPayload, AuthenticatedAdmin } from './authenticated-admin.js';

const { ExtractJwt, Strategy } = passportJwt;

/** Valida o access token sem consultar o banco (API.md §4). */
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(config: ConfigService<AppConfig, true>) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: config.get('JWT_ACCESS_SECRET', { infer: true }),
      ignoreExpiration: false,
    });
  }

  validate(payload: AccessTokenPayload): AuthenticatedAdmin {
    return { id: payload.sub, email: payload.email };
  }
}
