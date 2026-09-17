import { Injectable, Logger, type OnModuleDestroy, type OnModuleInit } from '@nestjs/common';
import { RefreshTokenRepository } from './ports/refresh-token.repository.js';

const DAY_MS = 24 * 60 * 60 * 1000;

/**
 * Higiene da tabela refresh_tokens: apaga expirados e revogados há mais de
 * 7 dias (a janela em que a detecção de reuso ainda tem valor forense), no
 * boot e uma vez por dia. Custo: um DELETE por dia.
 */
@Injectable()
export class RefreshTokenJanitor implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(RefreshTokenJanitor.name);
  private timer?: NodeJS.Timeout;

  constructor(private readonly refreshTokens: RefreshTokenRepository) {}

  async onModuleInit(): Promise<void> {
    await this.sweep();
    this.timer = setInterval(() => void this.sweep(), DAY_MS);
    this.timer.unref();
  }

  onModuleDestroy(): void {
    clearInterval(this.timer);
  }

  async sweep(): Promise<void> {
    try {
      const now = new Date();
      const count = await this.refreshTokens.deleteStale(now, new Date(now.getTime() - 7 * DAY_MS));
      if (count > 0) this.logger.log(`${count} refresh token(s) antigos removidos`);
    } catch (error) {
      this.logger.warn(`limpeza de refresh tokens falhou: ${(error as Error).message}`);
    }
  }
}
