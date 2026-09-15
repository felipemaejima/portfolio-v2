import { Injectable } from '@nestjs/common';
import type { Experience } from '../../generated/prisma/client.js';
import { NotFoundError, ValidationError } from '../../shared/http/errors/domain.errors.js';
import { type ExperienceData, ExperienceRepository } from './ports/experience.repository.js';

@Injectable()
export class ExperiencesService {
  constructor(private readonly experiences: ExperienceRepository) {}

  list(): Promise<Experience[]> {
    return this.experiences.findAll();
  }

  create(data: ExperienceData): Promise<Experience> {
    assertPeriod(data);
    return this.experiences.create(data);
  }

  async update(id: string, data: ExperienceData): Promise<Experience> {
    await this.require(id);
    assertPeriod(data);
    return this.experiences.update(id, data);
  }

  async remove(id: string): Promise<void> {
    await this.require(id);
    await this.experiences.delete(id);
  }

  private async require(id: string): Promise<Experience> {
    const found = await this.experiences.findById(id);
    if (!found) throw new NotFoundError('Experiência não encontrada.');
    return found;
  }
}

/** `YYYY-MM` compara lexicograficamente. */
export function assertPeriod(data: { startDate: string; endDate: string | null }): void {
  if (data.endDate !== null && data.endDate < data.startDate) {
    throw new ValidationError({ endDate: ['não pode ser anterior ao início'] });
  }
}
