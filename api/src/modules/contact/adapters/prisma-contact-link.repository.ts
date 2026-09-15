import { Injectable } from '@nestjs/common';
import type { ContactLink } from '../../../generated/prisma/client.js';
import { PrismaService } from '../../../shared/prisma/prisma.service.js';
import { type ContactLinkData, ContactLinkRepository } from '../ports/contact-link.repository.js';

@Injectable()
export class PrismaContactLinkRepository extends ContactLinkRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  findAll(): Promise<ContactLink[]> {
    return this.prisma.contactLink.findMany({ orderBy: { position: 'asc' } });
  }

  findById(id: string): Promise<ContactLink | null> {
    return this.prisma.contactLink.findUnique({ where: { id } });
  }

  create(data: ContactLinkData): Promise<ContactLink> {
    return this.prisma.$transaction(async (tx) => {
      const max = await tx.contactLink.aggregate({ _max: { position: true } });
      return tx.contactLink.create({ data: { ...data, position: (max._max.position ?? -1) + 1 } });
    });
  }

  update(id: string, data: ContactLinkData): Promise<ContactLink> {
    return this.prisma.contactLink.update({ where: { id }, data });
  }

  async delete(id: string): Promise<void> {
    await this.prisma.contactLink.delete({ where: { id } });
  }

  async reorder(ids: string[]): Promise<void> {
    await this.prisma.$transaction(
      ids.map((id, position) =>
        this.prisma.contactLink.update({ where: { id }, data: { position } }),
      ),
    );
  }
}
