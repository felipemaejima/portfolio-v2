import type { RefreshToken } from '../../../generated/prisma/client.js';

export interface NewRefreshToken {
  adminId: string;
  tokenHash: string;
  familyId: string;
  expiresAt: Date;
}

export abstract class RefreshTokenRepository {
  abstract create(data: NewRefreshToken): Promise<RefreshToken>;
  abstract findByHash(tokenHash: string): Promise<RefreshToken | null>;
  /** Atomicamente: cria o sucessor e marca `currentId` como substituído. */
  abstract rotate(currentId: string, next: NewRefreshToken): Promise<RefreshToken>;
  abstract revokeFamily(familyId: string): Promise<void>;
  /** Apaga expirados e os revogados há mais de `revokedBefore`. Devolve quantos. */
  abstract deleteStale(now: Date, revokedBefore: Date): Promise<number>;
}
