import type { Offering } from '../../../generated/prisma/client.js';

export interface OfferingData {
  title: string;
  description: string;
}

export abstract class OfferingRepository {
  abstract findAll(): Promise<Offering[]>;
  abstract findById(id: string): Promise<Offering | null>;
  /** Entra no fim. */
  abstract create(data: OfferingData): Promise<Offering>;
  abstract update(id: string, data: OfferingData): Promise<Offering>;
  abstract delete(id: string): Promise<void>;
  abstract reorder(ids: string[]): Promise<void>;
}
