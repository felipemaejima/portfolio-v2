import type { ContactMessage } from '../../../generated/prisma/client.js';

export interface ContactMessageData {
  name: string;
  email: string;
  message: string;
}

export abstract class ContactMessageRepository {
  /** Mais recentes primeiro. */
  abstract findAll(): Promise<ContactMessage[]>;
  abstract findById(id: string): Promise<ContactMessage | null>;
  abstract create(data: ContactMessageData): Promise<ContactMessage>;
  abstract markRead(id: string, readAt: Date): Promise<ContactMessage>;
  abstract delete(id: string): Promise<void>;
}
