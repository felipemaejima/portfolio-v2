import { Injectable } from '@nestjs/common';
import type { Education } from '../../../generated/prisma/client.js';
import { PrismaService } from '../../../shared/prisma/prisma.service.js';
import { type EducationData, EducationRepository } from '../ports/education.repository.js';

@Injectable()
export class PrismaEducationRepository extends EducationRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  findAll(): Promise<Education[]> {
    return this.prisma.education.findMany({
      orderBy: [{ endYear: { sort: 'desc', nulls: 'first' } }, { startYear: 'desc' }],
    });
  }

  findById(id: string): Promise<Education | null> {
    return this.prisma.education.findUnique({ where: { id } });
  }

  create(data: EducationData): Promise<Education> {
    return this.prisma.education.create({ data });
  }

  update(id: string, data: EducationData): Promise<Education> {
    return this.prisma.education.update({ where: { id }, data });
  }

  async delete(id: string): Promise<void> {
    await this.prisma.education.delete({ where: { id } });
  }
}
