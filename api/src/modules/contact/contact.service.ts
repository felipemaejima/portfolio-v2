import { Injectable } from '@nestjs/common';
import type { ContactLink, ContactMessage } from '../../generated/prisma/client.js';
import { assertSameIdSet } from '../../shared/domain/reorder.js';
import { NotFoundError } from '../../shared/http/errors/domain.errors.js';
import { type ContactLinkData, ContactLinkRepository } from './ports/contact-link.repository.js';
import {
  type ContactMessageData,
  ContactMessageRepository,
} from './ports/contact-message.repository.js';

@Injectable()
export class ContactService {
  constructor(
    private readonly links: ContactLinkRepository,
    private readonly messages: ContactMessageRepository,
  ) {}

  // ---- links ----

  listLinks(): Promise<ContactLink[]> {
    return this.links.findAll();
  }

  createLink(data: ContactLinkData): Promise<ContactLink> {
    return this.links.create(data);
  }

  async updateLink(id: string, data: ContactLinkData): Promise<ContactLink> {
    await this.requireLink(id);
    return this.links.update(id, data);
  }

  async deleteLink(id: string): Promise<void> {
    await this.requireLink(id);
    await this.links.delete(id);
  }

  async reorderLinks(ids: string[]): Promise<void> {
    const all = await this.links.findAll();
    assertSameIdSet(
      all.map((l) => l.id),
      ids,
    );
    await this.links.reorder(ids);
  }

  // ---- messages (AD-8: só persiste) ----

  async receiveMessage(data: ContactMessageData): Promise<void> {
    await this.messages.create(data);
  }

  listMessages(): Promise<ContactMessage[]> {
    return this.messages.findAll();
  }

  /** Idempotente: uma mensagem já lida mantém o `readAt` original. */
  async markRead(id: string): Promise<ContactMessage> {
    const message = await this.requireMessage(id);
    return message.readAt ? message : this.messages.markRead(id, new Date());
  }

  async deleteMessage(id: string): Promise<void> {
    await this.requireMessage(id);
    await this.messages.delete(id);
  }

  private async requireLink(id: string): Promise<ContactLink> {
    const found = await this.links.findById(id);
    if (!found) throw new NotFoundError('Link de contato não encontrado.');
    return found;
  }

  private async requireMessage(id: string): Promise<ContactMessage> {
    const found = await this.messages.findById(id);
    if (!found) throw new NotFoundError('Mensagem não encontrada.');
    return found;
  }
}
