import { Module } from '@nestjs/common';
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
    // módulos de domínio entram por fase (API.md §6)
  ],
})
export class AppModule {}
