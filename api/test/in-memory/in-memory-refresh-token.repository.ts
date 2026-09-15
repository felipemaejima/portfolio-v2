import { randomUUID } from 'node:crypto';
import type { RefreshToken } from '../../src/generated/prisma/client.js';
import {
  type NewRefreshToken,
  RefreshTokenRepository,
} from '../../src/modules/auth/ports/refresh-token.repository.js';

export class InMemoryRefreshTokenRepository extends RefreshTokenRepository {
  readonly tokens: RefreshToken[] = [];

  async create(data: NewRefreshToken): Promise<RefreshToken> {
    const token: RefreshToken = {
      id: randomUUID(),
      ...data,
      revokedAt: null,
      replacedById: null,
      createdAt: new Date(),
    };
    this.tokens.push(token);
    return token;
  }

  async findByHash(tokenHash: string): Promise<RefreshToken | null> {
    return this.tokens.find((t) => t.tokenHash === tokenHash) ?? null;
  }

  async rotate(currentId: string, next: NewRefreshToken): Promise<RefreshToken> {
    const created = await this.create(next);
    const current = this.tokens.find((t) => t.id === currentId);
    if (!current) throw new Error(`refresh ${currentId} não existe`);
    current.replacedById = created.id;
    current.revokedAt = new Date();
    return created;
  }

  async revokeFamily(familyId: string): Promise<void> {
    for (const t of this.tokens) {
      if (t.familyId === familyId && !t.revokedAt) t.revokedAt = new Date();
    }
  }
}
