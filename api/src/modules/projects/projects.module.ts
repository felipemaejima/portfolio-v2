import { Module } from '@nestjs/common';
import { PrismaProjectRepository } from './adapters/prisma-project.repository.js';
import { ProjectRepository } from './ports/project.repository.js';
import { ProjectsController } from './projects.controller.js';
import { ProjectsService } from './projects.service.js';

@Module({
  controllers: [ProjectsController],
  providers: [ProjectsService, { provide: ProjectRepository, useClass: PrismaProjectRepository }],
})
export class ProjectsModule {}
