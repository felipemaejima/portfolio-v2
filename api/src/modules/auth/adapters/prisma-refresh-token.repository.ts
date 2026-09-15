import { Injectable } from '@nestjs/common';
import type { RefreshToken } from '../../../generated/prisma/client.js';
import { PrismaService } from '../../../shared/prisma/prisma.service.js';
import { type NewRefreshToken, RefreshTokenRepository } from '../ports/refresh-token.repository.js';

@Injectable()
export class PrismaRefreshTokenRepository extends RefreshTokenRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  create(data: NewRefreshToken): Promise<RefreshToken> {
    return this.prisma.refreshToken.create({ data });
  }

  findByHash(tokenHash: string): Promise<RefreshToken | null> {
    return this.prisma.refreshToken.findUnique({ where: { tokenHash } });
  }

  rotate(currentId: string, next: NewRefreshToken): Promise<RefreshToken> {
    return this.prisma.$transaction(async (tx) => {
      const created = await tx.refreshToken.create({ data: next });
      await tx.refreshToken.update({
        where: { id: currentId },
        data: { replacedById: created.id, revokedAt: new Date() },
      });
      return created;
    });
  }

  async revokeFamily(familyId: string): Promise<void> {
    await this.prisma.refreshToken.updateMany({
      where: { familyId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
  }
}
