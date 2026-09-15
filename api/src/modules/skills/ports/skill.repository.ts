import type { Skill } from '../../../generated/prisma/client.js';

export abstract class SkillRepository {
  abstract findById(id: string): Promise<Skill | null>;
  /** Entra no fim da categoria. */
  abstract create(categoryId: string, name: string): Promise<Skill>;
  /** Se `categoryId` mudar, vai para o fim da nova categoria. */
  abstract update(id: string, data: { name: string; categoryId: string }): Promise<Skill>;
  abstract delete(id: string): Promise<void>;
  abstract reorderInCategory(categoryId: string, ids: string[]): Promise<void>;
}
