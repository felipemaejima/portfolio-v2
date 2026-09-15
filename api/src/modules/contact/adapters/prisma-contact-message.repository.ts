import { Injectable } from '@nestjs/common';
import type { ContactMessage } from '../../../generated/prisma/client.js';
import { PrismaService } from '../../../shared/prisma/prisma.service.js';
import {
  type ContactMessageData,
  ContactMessageRepository,
} from '../ports/contact-message.repository.js';

@Injectable()
export class PrismaContactMessageRepository extends ContactMessageRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  findAll(): Promise<ContactMessage[]> {
    return this.prisma.contactMessage.findMany({ orderBy: { createdAt: 'desc' } });
  }

  findById(id: string): Promise<ContactMessage | null> {
    return this.prisma.contactMessage.findUnique({ where: { id } });
  }

  create(data: ContactMessageData): Promise<ContactMessage> {
    return this.prisma.contactMessage.create({ data });
  }

  markRead(id: string, readAt: Date): Promise<ContactMessage> {
    return this.prisma.contactMessage.update({ where: { id }, data: { readAt } });
  }

  async delete(id: string): Promise<void> {
    await this.prisma.contactMessage.delete({ where: { id } });
  }
}
