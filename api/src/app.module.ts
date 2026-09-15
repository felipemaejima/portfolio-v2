import { Module } from '@nestjs/common';
import { AuthModule } from './modules/auth/auth.module.js';
import { ProfileModule } from './modules/profile/profile.module.js';
import { ProjectsModule } from './modules/projects/projects.module.js';
import { SkillsModule } from './modules/skills/skills.module.js';
import { ExperiencesModule } from './modules/experiences/experiences.module.js';
import { EducationsModule } from './modules/educations/educations.module.js';
import { OfferingsModule } from './modules/offerings/offerings.module.js';
import { JwtAuthModule } from './shared/auth/jwt-auth.module.js';
import { AppConfigModule } from './shared/config/app-config.module.js';
import { HealthModule } from './shared/health/health.module.js';
import { SharedHttpModule } from './shared/http/shared-http.module.js';
import { PrismaModule } from './shared/prisma/prisma.module.js';
import { StorageModule } from './shared/storage/storage.module.js';

@Module({
  imports: [
    AppConfigModule,
    PrismaModule,
    StorageModule,
    SharedHttpModule,
    JwtAuthModule,
    HealthModule,
    // módulos de domínio, na ordem das fases (API.md §6)
    AuthModule,
    ProfileModule,
    ProjectsModule,
    SkillsModule,
    ExperiencesModule,
    EducationsModule,
    OfferingsModule,
  ],
})
export class AppModule {}
