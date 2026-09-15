import { Module } from '@nestjs/common';
import { PrismaExperienceRepository } from './adapters/prisma-experience.repository.js';
import { ExperiencesController } from './experiences.controller.js';
import { ExperiencesService } from './experiences.service.js';
import { ExperienceRepository } from './ports/experience.repository.js';

@Module({
  controllers: [ExperiencesController],
  providers: [
    ExperiencesService,
    { provide: ExperienceRepository, useClass: PrismaExperienceRepository },
  ],
  exports: [ExperiencesService],
})
export class ExperiencesModule {}
