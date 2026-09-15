import { Module } from '@nestjs/common';
import { PrismaSkillCategoryRepository } from './adapters/prisma-skill-category.repository.js';
import { PrismaSkillRepository } from './adapters/prisma-skill.repository.js';
import { SkillCategoryRepository } from './ports/skill-category.repository.js';
import { SkillRepository } from './ports/skill.repository.js';
import { SkillCategoriesController } from './skill-categories.controller.js';
import { SkillsController } from './skills.controller.js';
import { SkillsService } from './skills.service.js';

@Module({
  controllers: [SkillCategoriesController, SkillsController],
  providers: [
    SkillsService,
    { provide: SkillCategoryRepository, useClass: PrismaSkillCategoryRepository },
    { provide: SkillRepository, useClass: PrismaSkillRepository },
  ],
})
export class SkillsModule {}
