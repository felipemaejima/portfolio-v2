import type { Education } from '../../../generated/prisma/client.js';

export interface EducationData {
  courseName: string;
  institution: string;
  startYear: number;
  endYear: number | null;
}

export abstract class EducationRepository {
  /** Em andamento primeiro; depois `endYear` desc, `startYear` desc. */
  abstract findAll(): Promise<Education[]>;
  abstract findById(id: string): Promise<Education | null>;
  abstract create(data: EducationData): Promise<Education>;
  abstract update(id: string, data: EducationData): Promise<Education>;
  abstract delete(id: string): Promise<void>;
}
