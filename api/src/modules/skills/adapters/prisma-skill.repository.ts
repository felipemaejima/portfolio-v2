import { Injectable } from '@nestjs/common';
import type { Prisma, Skill } from '../../../generated/prisma/client.js';
import { PrismaService } from '../../../shared/prisma/prisma.service.js';
import { SkillRepository } from '../ports/skill.repository.js';

@Injectable()
export class PrismaSkillRepository extends SkillRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  findById(id: string): Promise<Skill | null> {
    return this.prisma.skill.findUnique({ where: { id } });
  }

  create(categoryId: string, name: string): Promise<Skill> {
    return this.prisma.$transaction(async (tx) => {
      const position = await nextPosition(tx, categoryId);
      return tx.skill.create({ data: { categoryId, name, position } });
    });
  }

  update(id: string, data: { name: string; categoryId: string }): Promise<Skill> {
    return this.prisma.$transaction(async (tx) => {
      const current = await tx.skill.findUniqueOrThrow({ where: { id } });
      const moved = current.categoryId !== data.categoryId;
      return tx.skill.update({
        where: { id },
        data: moved ? { ...data, position: await nextPosition(tx, data.categoryId) } : data,
      });
    });
  }

  async delete(id: string): Promise<void> {
    await this.prisma.skill.delete({ where: { id } });
  }

  async reorderInCategory(categoryId: string, ids: string[]): Promise<void> {
    await this.prisma.$transaction(
      ids.map((id, position) =>
        this.prisma.skill.update({ where: { id, categoryId }, data: { position } }),
      ),
    );
  }
}

async function nextPosition(tx: Prisma.TransactionClient, categoryId: string): Promise<number> {
  const max = await tx.skill.aggregate({ where: { categoryId }, _max: { position: true } });
  return (max._max.position ?? -1) + 1;
}
