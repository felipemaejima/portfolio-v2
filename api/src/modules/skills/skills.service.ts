import { Injectable } from '@nestjs/common';
import type { Skill } from '../../generated/prisma/client.js';
import { assertSameIdSet } from '../../shared/domain/reorder.js';
import { NotFoundError, ValidationError } from '../../shared/http/errors/domain.errors.js';
import {
  SkillCategoryRepository,
  type SkillCategoryWithSkills,
} from './ports/skill-category.repository.js';
import { SkillRepository } from './ports/skill.repository.js';

const CATEGORY_NOT_FOUND = 'Categoria não encontrada.';
const SKILL_NOT_FOUND = 'Skill não encontrada.';

@Injectable()
export class SkillsService {
  constructor(
    private readonly categories: SkillCategoryRepository,
    private readonly skills: SkillRepository,
  ) {}

  listCategories(): Promise<SkillCategoryWithSkills[]> {
    return this.categories.findAll();
  }

  createCategory(name: string): Promise<SkillCategoryWithSkills> {
    return this.categories.create(name);
  }

  async updateCategory(id: string, name: string): Promise<SkillCategoryWithSkills> {
    await this.requireCategory(id);
    return this.categories.update(id, name);
  }

  async deleteCategory(id: string): Promise<void> {
    await this.requireCategory(id);
    await this.categories.delete(id);
  }

  async reorderCategories(ids: string[]): Promise<void> {
    const all = await this.categories.findAll();
    assertSameIdSet(
      all.map((c) => c.id),
      ids,
    );
    await this.categories.reorder(ids);
  }

  async createSkill(categoryId: string, name: string): Promise<Skill> {
    await this.requireCategory(categoryId);
    return this.skills.create(categoryId, name);
  }

  async updateSkill(id: string, data: { name: string; categoryId: string }): Promise<Skill> {
    await this.requireSkill(id);
    if (!(await this.categories.findById(data.categoryId))) {
      throw new ValidationError({ categoryId: ['categoria não existe'] });
    }
    return this.skills.update(id, data);
  }

  async deleteSkill(id: string): Promise<void> {
    await this.requireSkill(id);
    await this.skills.delete(id);
  }

  async reorderSkills(categoryId: string, ids: string[]): Promise<void> {
    const category = await this.requireCategory(categoryId);
    assertSameIdSet(
      category.skills.map((s) => s.id),
      ids,
    );
    await this.skills.reorderInCategory(categoryId, ids);
  }

  private async requireCategory(id: string): Promise<SkillCategoryWithSkills> {
    const category = await this.categories.findById(id);
    if (!category) throw new NotFoundError(CATEGORY_NOT_FOUND);
    return category;
  }

  private async requireSkill(id: string): Promise<Skill> {
    const skill = await this.skills.findById(id);
    if (!skill) throw new NotFoundError(SKILL_NOT_FOUND);
    return skill;
  }
}
