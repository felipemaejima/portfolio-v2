import type { ContactLink } from '../../../generated/prisma/client.js';

export interface ContactLinkData {
  label: string;
  value: string;
  url: string;
}

export abstract class ContactLinkRepository {
  abstract findAll(): Promise<ContactLink[]>;
  abstract findById(id: string): Promise<ContactLink | null>;
  /** Entra no fim. */
  abstract create(data: ContactLinkData): Promise<ContactLink>;
  abstract update(id: string, data: ContactLinkData): Promise<ContactLink>;
  abstract delete(id: string): Promise<void>;
  abstract reorder(ids: string[]): Promise<void>;
}
