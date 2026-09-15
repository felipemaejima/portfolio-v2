import { Injectable } from '@nestjs/common';
import type { Experience } from '../../../generated/prisma/client.js';
import { PrismaService } from '../../../shared/prisma/prisma.service.js';
import { type ExperienceData, ExperienceRepository } from '../ports/experience.repository.js';

@Injectable()
export class PrismaExperienceRepository extends ExperienceRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  findAll(): Promise<Experience[]> {
    return this.prisma.experience.findMany({
      orderBy: [{ endDate: { sort: 'desc', nulls: 'first' } }, { startDate: 'desc' }],
    });
  }

  findById(id: string): Promise<Experience | null> {
    return this.prisma.experience.findUnique({ where: { id } });
  }

  create(data: ExperienceData): Promise<Experience> {
    return this.prisma.experience.create({ data });
  }

  update(id: string, data: ExperienceData): Promise<Experience> {
    return this.prisma.experience.update({ where: { id }, data });
  }

  async delete(id: string): Promise<void> {
    await this.prisma.experience.delete({ where: { id } });
  }
}
