import { createHash, randomBytes, randomUUID } from 'node:crypto';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import argon2 from 'argon2';
import type { Admin } from '../../generated/prisma/client.js';
import type { AccessTokenPayload } from '../../shared/auth/authenticated-admin.js';
import type { AppConfig } from '../../shared/config/config.schema.js';
import { UnauthenticatedError } from '../../shared/http/errors/domain.errors.js';
import { AdminRepository } from './ports/admin.repository.js';
import { type NewRefreshToken, RefreshTokenRepository } from './ports/refresh-token.repository.js';

export interface IssuedTokens {
  accessToken: string;
  /** segundos */
  expiresIn: number;
  refreshToken: string;
  refreshExpiresAt: Date;
}

const INVALID_CREDENTIALS = 'E-mail ou senha inválidos.';
const SESSION_EXPIRED = 'Sessão expirada. Entre novamente.';
const DAY_MS = 24 * 60 * 60 * 1000;

export function hashRefreshToken(raw: string): string {
  return createHash('sha256').update(raw).digest('hex');
}

/**
 * Regra de auth (API.md §4): senha argon2id; access JWT curto; refresh opaco
 * rotativo por família, com detecção de reuso.
 */
@Injectable()
export class AuthService {
  private readonly refreshTtlMs: number;
  /** Hash de sacrifício: mantém o tempo do login constante quando o e-mail não existe. */
  private readonly decoyHash = argon2.hash(randomUUID(), { type: argon2.argon2id });

  constructor(
    private readonly admins: AdminRepository,
    private readonly refreshTokens: RefreshTokenRepository,
    private readonly jwt: JwtService,
    config: ConfigService<AppConfig, true>,
  ) {
    this.refreshTtlMs = config.get('REFRESH_TTL_DAYS', { infer: true }) * DAY_MS;
  }

  async login(email: string, password: string): Promise<IssuedTokens> {
    const admin = await this.admins.findByEmail(email);
    const hash = admin?.passwordHash ?? (await this.decoyHash);
    const ok = await argon2.verify(hash, password);
    if (!admin || !ok) throw new UnauthenticatedError(INVALID_CREDENTIALS);

    const next = this.newRefresh(admin.id, randomUUID());
    await this.refreshTokens.create(next.record);
    return this.issue(admin, next);
  }

  async refresh(rawRefreshToken: string): Promise<IssuedTokens> {
    const current = await this.refreshTokens.findByHash(hashRefreshToken(rawRefreshToken));
    if (!current) throw new UnauthenticatedError(SESSION_EXPIRED);

    if (current.revokedAt || current.replacedById) {
      // Reuso de um token já rotacionado: alguém tem uma cópia. Derruba a família.
      await this.refreshTokens.revokeFamily(current.familyId);
      throw new UnauthenticatedError(SESSION_EXPIRED);
    }
    if (current.expiresAt.getTime() <= Date.now()) throw new UnauthenticatedError(SESSION_EXPIRED);

    const admin = await this.admins.findById(current.adminId);
    if (!admin) throw new UnauthenticatedError(SESSION_EXPIRED);

    const next = this.newRefresh(admin.id, current.familyId);
    await this.refreshTokens.rotate(current.id, next.record);
    return this.issue(admin, next);
  }

  /** Revoga a família do refresh apresentado. Sem refresh, não há o que revogar. */
  async logout(rawRefreshToken: string | undefined): Promise<void> {
    if (!rawRefreshToken) return;
    const current = await this.refreshTokens.findByHash(hashRefreshToken(rawRefreshToken));
    if (current) await this.refreshTokens.revokeFamily(current.familyId);
  }

  async me(adminId: string): Promise<Admin> {
    const admin = await this.admins.findById(adminId);
    if (!admin) throw new UnauthenticatedError();
    return admin;
  }

  private newRefresh(adminId: string, familyId: string): { raw: string; record: NewRefreshToken } {
    const raw = randomBytes(32).toString('base64url');
    return {
      raw,
      record: {
        adminId,
        familyId,
        tokenHash: hashRefreshToken(raw),
        expiresAt: new Date(Date.now() + this.refreshTtlMs),
      },
    };
  }

  private issue(admin: Admin, next: { raw: string; record: NewRefreshToken }): IssuedTokens {
    const payload: AccessTokenPayload = { sub: admin.id, email: admin.email };
    const accessToken = this.jwt.sign(payload);
    const { exp, iat } = this.jwt.decode<{ exp: number; iat: number }>(accessToken);
    return {
      accessToken,
      expiresIn: exp - iat,
      refreshToken: next.raw,
      refreshExpiresAt: next.record.expiresAt,
    };
  }
}
