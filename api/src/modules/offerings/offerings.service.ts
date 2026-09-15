import { Injectable } from '@nestjs/common';
import type { Offering } from '../../generated/prisma/client.js';
import { assertSameIdSet } from '../../shared/domain/reorder.js';
import { NotFoundError } from '../../shared/http/errors/domain.errors.js';
import { type OfferingData, OfferingRepository } from './ports/offering.repository.js';

@Injectable()
export class OfferingsService {
  constructor(private readonly offerings: OfferingRepository) {}

  list(): Promise<Offering[]> {
    return this.offerings.findAll();
  }

  create(data: OfferingData): Promise<Offering> {
    return this.offerings.create(data);
  }

  async update(id: string, data: OfferingData): Promise<Offering> {
    await this.require(id);
    return this.offerings.update(id, data);
  }

  async remove(id: string): Promise<void> {
    await this.require(id);
    await this.offerings.delete(id);
  }

  async reorder(ids: string[]): Promise<void> {
    const all = await this.offerings.findAll();
    assertSameIdSet(
      all.map((o) => o.id),
      ids,
    );
    await this.offerings.reorder(ids);
  }

  private async require(id: string): Promise<Offering> {
    const found = await this.offerings.findById(id);
    if (!found) throw new NotFoundError('Serviço não encontrado.');
    return found;
  }
}
