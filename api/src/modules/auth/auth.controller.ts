import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Req,
  Res,
  UseGuards,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ApiBearerAuth, ApiNoContentResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import type { Request, Response } from 'express';
import type { AuthenticatedAdmin } from '../../shared/auth/authenticated-admin.js';
import { CurrentAdmin } from '../../shared/auth/current-admin.decorator.js';
import { Public } from '../../shared/auth/public.decorator.js';
import type { AppConfig } from '../../shared/config/config.schema.js';
import { ApiErrorResponses } from '../../shared/http/decorators/api-error-responses.decorator.js';
import { UnauthenticatedError } from '../../shared/http/errors/domain.errors.js';
import { THROTTLE_LOGIN_LIMIT, THROTTLE_TTL_MS } from '../../shared/http/throttle.js';
import { AuthService, type IssuedTokens } from './auth.service.js';
import { CookieOriginGuard } from './cookie-origin.guard.js';
import { AdminDto } from './dto/admin.dto.js';
import { AuthTokensDto } from './dto/auth-tokens.dto.js';
import { ClientPlatform } from './dto/client-platform.enum.js';
import { LoginDto } from './dto/login.dto.js';
import { RefreshDto } from './dto/refresh.dto.js';
import { REFRESH_COOKIE, refreshCookieOptions } from './refresh-cookie.js';

const SESSION_EXPIRED = 'Sessão expirada. Entre novamente.';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  private readonly cookieSecure: boolean;

  constructor(
    private readonly auth: AuthService,
    config: ConfigService<AppConfig, true>,
  ) {
    this.cookieSecure = config.get('COOKIE_SECURE', { infer: true });
  }

  /** Autentica o Admin. WEB recebe o refresh em cookie httpOnly; MOBILE, no body. */
  @Public()
  @Throttle({ default: { limit: THROTTLE_LOGIN_LIMIT, ttl: THROTTLE_TTL_MS } })
  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOkResponse({ type: AuthTokensDto })
  @ApiErrorResponses(
    HttpStatus.UNAUTHORIZED,
    HttpStatus.UNPROCESSABLE_ENTITY,
    HttpStatus.TOO_MANY_REQUESTS,
  )
  async login(
    @Body() dto: LoginDto,
    @Res({ passthrough: true }) res: Response,
  ): Promise<AuthTokensDto> {
    const tokens = await this.auth.login(dto.email, dto.password);
    return this.deliver(tokens, dto.clientPlatform, res);
  }

  /** Rotaciona o refresh (cookie primeiro, body como fallback) e devolve um par novo. */
  @Public()
  @UseGuards(CookieOriginGuard)
  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOkResponse({ type: AuthTokensDto })
  @ApiErrorResponses(HttpStatus.UNAUTHORIZED, HttpStatus.UNPROCESSABLE_ENTITY)
  async refresh(
    @Body() dto: RefreshDto,
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
  ): Promise<AuthTokensDto> {
    const fromCookie = readRefreshCookie(req);
    const raw = fromCookie ?? dto.refreshToken;
    if (!raw) throw new UnauthenticatedError(SESSION_EXPIRED);

    const tokens = await this.auth.refresh(raw);
    return this.deliver(tokens, fromCookie ? ClientPlatform.WEB : ClientPlatform.MOBILE, res);
  }

  /** Revoga a família do refresh atual e limpa o cookie. */
  @UseGuards(CookieOriginGuard)
  @Post('logout')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(HttpStatus.UNAUTHORIZED)
  async logout(
    @Body() dto: RefreshDto,
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
  ): Promise<void> {
    await this.auth.logout(readRefreshCookie(req) ?? dto.refreshToken);
    res.clearCookie(REFRESH_COOKIE, refreshCookieOptions(this.cookieSecure));
  }

  /** O Admin autenticado. O app usa no boot para validar a sessão. */
  @Get('me')
  @ApiBearerAuth()
  @ApiOkResponse({ type: AdminDto })
  @ApiErrorResponses(HttpStatus.UNAUTHORIZED)
  async me(@CurrentAdmin() admin: AuthenticatedAdmin): Promise<AdminDto> {
    return AdminDto.from(await this.auth.me(admin.id));
  }

  private deliver(tokens: IssuedTokens, platform: ClientPlatform, res: Response): AuthTokensDto {
    if (platform === ClientPlatform.WEB) {
      res.cookie(REFRESH_COOKIE, tokens.refreshToken, {
        ...refreshCookieOptions(this.cookieSecure),
        expires: tokens.refreshExpiresAt,
      });
      return AuthTokensDto.from(tokens, false);
    }
    return AuthTokensDto.from(tokens, true);
  }
}

function readRefreshCookie(req: Request): string | undefined {
  const value: unknown = req.cookies?.[REFRESH_COOKIE];
  return typeof value === 'string' && value.length > 0 ? value : undefined;
}
