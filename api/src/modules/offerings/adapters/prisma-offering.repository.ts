import { Injectable } from '@nestjs/common';
import type { Offering } from '../../../generated/prisma/client.js';
import { PrismaService } from '../../../shared/prisma/prisma.service.js';
import { type OfferingData, OfferingRepository } from '../ports/offering.repository.js';

@Injectable()
export class PrismaOfferingRepository extends OfferingRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  findAll(): Promise<Offering[]> {
    return this.prisma.offering.findMany({ orderBy: { position: 'asc' } });
  }

  findById(id: string): Promise<Offering | null> {
    return this.prisma.offering.findUnique({ where: { id } });
  }

  create(data: OfferingData): Promise<Offering> {
    return this.prisma.$transaction(async (tx) => {
      const max = await tx.offering.aggregate({ _max: { position: true } });
      return tx.offering.create({ data: { ...data, position: (max._max.position ?? -1) + 1 } });
    });
  }

  update(id: string, data: OfferingData): Promise<Offering> {
    return this.prisma.offering.update({ where: { id }, data });
  }

  async delete(id: string): Promise<void> {
    await this.prisma.offering.delete({ where: { id } });
  }

  async reorder(ids: string[]): Promise<void> {
    await this.prisma.$transaction(
      ids.map((id, position) => this.prisma.offering.update({ where: { id }, data: { position } })),
    );
  }
}
