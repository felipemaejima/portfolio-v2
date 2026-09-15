import { Module } from '@nestjs/common';
import { PrismaEducationRepository } from './adapters/prisma-education.repository.js';
import { EducationsController } from './educations.controller.js';
import { EducationsService } from './educations.service.js';
import { EducationRepository } from './ports/education.repository.js';

@Module({
  controllers: [EducationsController],
  providers: [
    EducationsService,
    { provide: EducationRepository, useClass: PrismaEducationRepository },
  ],
  exports: [EducationsService],
})
export class EducationsModule {}
