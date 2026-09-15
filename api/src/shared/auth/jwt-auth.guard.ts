import { type ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AuthGuard } from '@nestjs/passport';
import { UnauthenticatedError } from '../http/errors/domain.errors.js';
import { IS_PUBLIC_KEY } from './public.decorator.js';

/**
 * Guard global: tudo exige Admin, salvo @Public(). Falha de token vira
 * UnauthenticatedError para o filtro produzir o ErrorResponse do contrato.
 */
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  constructor(private readonly reflector: Reflector) {
    super();
  }

  override canActivate(context: ExecutionContext) {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) return true;
    return super.canActivate(context);
  }

  override handleRequest<TUser>(err: unknown, user: TUser | false): TUser {
    if (err || !user) throw new UnauthenticatedError();
    return user;
  }
}
