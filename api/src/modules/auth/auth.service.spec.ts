import { randomUUID } from 'node:crypto';
import type { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import argon2 from 'argon2';
import { InMemoryAdminRepository } from '../../../test/in-memory/in-memory-admin.repository.js';
import { InMemoryRefreshTokenRepository } from '../../../test/in-memory/in-memory-refresh-token.repository.js';
import type { Admin } from '../../generated/prisma/client.js';
import type { AppConfig } from '../../shared/config/config.schema.js';
import { UnauthenticatedError } from '../../shared/http/errors/domain.errors.js';
import { AuthService, hashRefreshToken } from './auth.service.js';

const PASSWORD = 'senha-correta';

async function makeAdmin(): Promise<Admin> {
  return {
    id: randomUUID(),
    email: 'admin@example.com',
    passwordHash: await argon2.hash(PASSWORD, { type: argon2.argon2id }),
    createdAt: new Date(),
    updatedAt: new Date(),
  };
}

function makeService(admins: Admin[], refreshTtlDays = 30) {
  const adminRepo = new InMemoryAdminRepository(admins);
  const tokenRepo = new InMemoryRefreshTokenRepository();
  const jwt = new JwtService({ secret: 'x'.repeat(32), signOptions: { expiresIn: '15m' } });
  const config = {
    get: (key: keyof AppConfig) => ({ REFRESH_TTL_DAYS: refreshTtlDays })[key as string],
  } as unknown as ConfigService<AppConfig, true>;
  return { service: new AuthService(adminRepo, tokenRepo, jwt, config), tokenRepo, jwt };
}

describe('AuthService', () => {
  let admin: Admin;
  beforeAll(async () => {
    admin = await makeAdmin();
  });

  describe('login', () => {
    it('emite access JWT e refresh opaco persistido como hash', async () => {
      const { service, tokenRepo, jwt } = makeService([admin]);
      const tokens = await service.login(admin.email, PASSWORD);

      expect(jwt.verify(tokens.accessToken)).toMatchObject({ sub: admin.id, email: admin.email });
      expect(tokens.expiresIn).toBe(15 * 60);
      expect(tokenRepo.tokens).toHaveLength(1);
      expect(tokenRepo.tokens[0]?.tokenHash).toBe(hashRefreshToken(tokens.refreshToken));
      expect(tokenRepo.tokens[0]?.tokenHash).not.toBe(tokens.refreshToken);
    });

    it('rejeita senha errada e e-mail desconhecido com a mesma mensagem', async () => {
      const { service } = makeService([admin]);
      await expect(service.login(admin.email, 'errada')).rejects.toThrow(
        new UnauthenticatedError('E-mail ou senha inválidos.'),
      );
      await expect(service.login('ninguem@example.com', PASSWORD)).rejects.toThrow(
        new UnauthenticatedError('E-mail ou senha inválidos.'),
      );
    });
  });

  describe('refresh', () => {
    it('rotaciona: devolve par novo na mesma família e invalida o anterior', async () => {
      const { service, tokenRepo } = makeService([admin]);
      const first = await service.login(admin.email, PASSWORD);
      const second = await service.refresh(first.refreshToken);

      expect(second.refreshToken).not.toBe(first.refreshToken);
      const [old, fresh] = tokenRepo.tokens;
      expect(fresh?.familyId).toBe(old?.familyId);
      expect(old?.replacedById).toBe(fresh?.id);
      expect(old?.revokedAt).not.toBeNull();
    });

    it('reuso de um refresh já rotacionado revoga a família inteira', async () => {
      const { service, tokenRepo } = makeService([admin]);
      const first = await service.login(admin.email, PASSWORD);
      const second = await service.refresh(first.refreshToken);

      await expect(service.refresh(first.refreshToken)).rejects.toBeInstanceOf(
        UnauthenticatedError,
      );
      // o token mais novo (legítimo) também morreu
      await expect(service.refresh(second.refreshToken)).rejects.toBeInstanceOf(
        UnauthenticatedError,
      );
      expect(tokenRepo.tokens.every((t) => t.revokedAt !== null)).toBe(true);
    });

    it('refresh expirado é rejeitado', async () => {
      const { service } = makeService([admin], 0);
      const tokens = await service.login(admin.email, PASSWORD);
      await expect(service.refresh(tokens.refreshToken)).rejects.toBeInstanceOf(
        UnauthenticatedError,
      );
    });

    it('refresh desconhecido é rejeitado', async () => {
      const { service } = makeService([admin]);
      await expect(service.refresh('inventado')).rejects.toBeInstanceOf(UnauthenticatedError);
    });

    it('famílias são independentes: logout de uma não afeta a outra', async () => {
      const { service } = makeService([admin]);
      const web = await service.login(admin.email, PASSWORD);
      const mobile = await service.login(admin.email, PASSWORD);

      await service.logout(web.refreshToken);
      await expect(service.refresh(web.refreshToken)).rejects.toBeInstanceOf(UnauthenticatedError);
      await expect(service.refresh(mobile.refreshToken)).resolves.toBeDefined();
    });
  });

  describe('logout', () => {
    it('sem refresh é no-op; com refresh desconhecido também', async () => {
      const { service } = makeService([admin]);
      await expect(service.logout(undefined)).resolves.toBeUndefined();
      await expect(service.logout('inventado')).resolves.toBeUndefined();
    });
  });
});
