import type { Prisma } from '../../../generated/prisma/client.js';

export type SkillCategoryWithSkills = Prisma.SkillCategoryGetPayload<{ include: { skills: true } }>;

export abstract class SkillCategoryRepository {
  /** Por `position`; skills por `position`. */
  abstract findAll(): Promise<SkillCategoryWithSkills[]>;
  abstract findById(id: string): Promise<SkillCategoryWithSkills | null>;
  /** Entra no fim. */
  abstract create(name: string): Promise<SkillCategoryWithSkills>;
  abstract update(id: string, name: string): Promise<SkillCategoryWithSkills>;
  /** Cascata nas skills. */
  abstract delete(id: string): Promise<void>;
  abstract reorder(ids: string[]): Promise<void>;
}
