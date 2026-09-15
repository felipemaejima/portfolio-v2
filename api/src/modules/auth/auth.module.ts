import { Module } from '@nestjs/common';
import { JwtAuthModule } from '../../shared/auth/jwt-auth.module.js';
import { PrismaAdminRepository } from './adapters/prisma-admin.repository.js';
import { PrismaRefreshTokenRepository } from './adapters/prisma-refresh-token.repository.js';
import { AuthController } from './auth.controller.js';
import { AuthService } from './auth.service.js';
import { CookieOriginGuard } from './cookie-origin.guard.js';
import { AdminRepository } from './ports/admin.repository.js';
import { RefreshTokenRepository } from './ports/refresh-token.repository.js';

@Module({
  imports: [JwtAuthModule],
  controllers: [AuthController],
  providers: [
    AuthService,
    CookieOriginGuard,
    { provide: AdminRepository, useClass: PrismaAdminRepository },
    { provide: RefreshTokenRepository, useClass: PrismaRefreshTokenRepository },
  ],
})
export class AuthModule {}
