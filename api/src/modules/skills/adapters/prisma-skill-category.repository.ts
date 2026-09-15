import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../shared/prisma/prisma.service.js';
import {
  SkillCategoryRepository,
  type SkillCategoryWithSkills,
} from '../ports/skill-category.repository.js';

const withSkills = { skills: { orderBy: { position: 'asc' as const } } };

@Injectable()
export class PrismaSkillCategoryRepository extends SkillCategoryRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  findAll(): Promise<SkillCategoryWithSkills[]> {
    return this.prisma.skillCategory.findMany({
      orderBy: { position: 'asc' },
      include: withSkills,
    });
  }

  findById(id: string): Promise<SkillCategoryWithSkills | null> {
    return this.prisma.skillCategory.findUnique({ where: { id }, include: withSkills });
  }

  create(name: string): Promise<SkillCategoryWithSkills> {
    return this.prisma.$transaction(async (tx) => {
      const max = await tx.skillCategory.aggregate({ _max: { position: true } });
      return tx.skillCategory.create({
        data: { name, position: (max._max.position ?? -1) + 1 },
        include: withSkills,
      });
    });
  }

  update(id: string, name: string): Promise<SkillCategoryWithSkills> {
    return this.prisma.skillCategory.update({ where: { id }, data: { name }, include: withSkills });
  }

  async delete(id: string): Promise<void> {
    await this.prisma.skillCategory.delete({ where: { id } });
  }

  async reorder(ids: string[]): Promise<void> {
    await this.prisma.$transaction(
      ids.map((id, position) =>
        this.prisma.skillCategory.update({ where: { id }, data: { position } }),
      ),
    );
  }
}
