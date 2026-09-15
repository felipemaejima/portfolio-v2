import type { Experience } from '../../../generated/prisma/client.js';

export interface ExperienceData {
  role: string;
  companyName: string;
  activities: string[];
  startDate: string;
  endDate: string | null;
}

export abstract class ExperienceRepository {
  /** Atual primeiro; depois `endDate` desc, `startDate` desc (GLOBAL.md §6). */
  abstract findAll(): Promise<Experience[]>;
  abstract findById(id: string): Promise<Experience | null>;
  abstract create(data: ExperienceData): Promise<Experience>;
  abstract update(id: string, data: ExperienceData): Promise<Experience>;
  abstract delete(id: string): Promise<void>;
}
