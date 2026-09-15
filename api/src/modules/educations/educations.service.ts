import { Injectable } from '@nestjs/common';
import type { Education } from '../../generated/prisma/client.js';
import { NotFoundError, ValidationError } from '../../shared/http/errors/domain.errors.js';
import { type EducationData, EducationRepository } from './ports/education.repository.js';

@Injectable()
export class EducationsService {
  constructor(private readonly educations: EducationRepository) {}

  list(): Promise<Education[]> {
    return this.educations.findAll();
  }

  create(data: EducationData): Promise<Education> {
    assertYears(data);
    return this.educations.create(data);
  }

  async update(id: string, data: EducationData): Promise<Education> {
    await this.require(id);
    assertYears(data);
    return this.educations.update(id, data);
  }

  async remove(id: string): Promise<void> {
    await this.require(id);
    await this.educations.delete(id);
  }

  private async require(id: string): Promise<Education> {
    const found = await this.educations.findById(id);
    if (!found) throw new NotFoundError('Formação não encontrada.');
    return found;
  }
}

export function assertYears(data: { startYear: number; endYear: number | null }): void {
  if (data.endYear !== null && data.endYear < data.startYear) {
    throw new ValidationError({ endYear: ['não pode ser anterior ao início'] });
  }
}
