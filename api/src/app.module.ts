import { Module } from '@nestjs/common';
import { AuthModule } from './modules/auth/auth.module.js';
import { JwtAuthModule } from './shared/auth/jwt-auth.module.js';
import { AppConfigModule } from './shared/config/app-config.module.js';
import { HealthModule } from './shared/health/health.module.js';
import { SharedHttpModule } from './shared/http/shared-http.module.js';
import { PrismaModule } from './shared/prisma/prisma.module.js';

@Module({
  imports: [
    AppConfigModule,
    PrismaModule,
    SharedHttpModule,
    JwtAuthModule,
    HealthModule,
    // módulos de domínio, na ordem das fases (API.md §6)
    AuthModule,
  ],
})
export class AppModule {}
