import { randomUUID } from 'node:crypto';
import type { Skill } from '../../src/generated/prisma/client.js';
import {
  SkillCategoryRepository,
  type SkillCategoryWithSkills,
} from '../../src/modules/skills/ports/skill-category.repository.js';
import { SkillRepository } from '../../src/modules/skills/ports/skill.repository.js';

/** Estado compartilhado entre os dois repositórios, como no banco. */
export class SkillsStore {
  categories: Omit<SkillCategoryWithSkills, 'skills'>[] = [];
  skills: Skill[] = [];

  withSkills(c: Omit<SkillCategoryWithSkills, 'skills'>): SkillCategoryWithSkills {
    return {
      ...c,
      skills: this.skills
        .filter((s) => s.categoryId === c.id)
        .sort((a, b) => a.position - b.position),
    };
  }
}

export class InMemorySkillCategoryRepository extends SkillCategoryRepository {
  constructor(private readonly store: SkillsStore) {
    super();
  }

  async findAll(): Promise<SkillCategoryWithSkills[]> {
    return [...this.store.categories]
      .sort((a, b) => a.position - b.position)
      .map((c) => this.store.withSkills(c));
  }

  async findById(id: string): Promise<SkillCategoryWithSkills | null> {
    const c = this.store.categories.find((x) => x.id === id);
    return c ? this.store.withSkills(c) : null;
  }

  async create(name: string): Promise<SkillCategoryWithSkills> {
    const c = {
      id: randomUUID(),
      name,
      position: this.store.categories.length,
      createdAt: new Date(),
      updatedAt: new Date(),
    };
    this.store.categories.push(c);
    return this.store.withSkills(c);
  }

  async update(id: string, name: string): Promise<SkillCategoryWithSkills> {
    const c = this.store.categories.find((x) => x.id === id)!;
    c.name = name;
    return this.store.withSkills(c);
  }

  async delete(id: string): Promise<void> {
    this.store.categories = this.store.categories.filter((c) => c.id !== id);
    this.store.skills = this.store.skills.filter((s) => s.categoryId !== id);
  }

  async reorder(ids: string[]): Promise<void> {
    ids.forEach((id, position) => {
      this.store.categories.find((c) => c.id === id)!.position = position;
    });
  }
}

export class InMemorySkillRepository extends SkillRepository {
  constructor(private readonly store: SkillsStore) {
    super();
  }

  async findById(id: string): Promise<Skill | null> {
    return this.store.skills.find((s) => s.id === id) ?? null;
  }

  async create(categoryId: string, name: string): Promise<Skill> {
    const skill: Skill = {
      id: randomUUID(),
      categoryId,
      name,
      position: this.next(categoryId),
      createdAt: new Date(),
      updatedAt: new Date(),
    };
    this.store.skills.push(skill);
    return skill;
  }

  async update(id: string, data: { name: string; categoryId: string }): Promise<Skill> {
    const s = this.store.skills.find((x) => x.id === id)!;
    if (s.categoryId !== data.categoryId) s.position = this.next(data.categoryId);
    Object.assign(s, data);
    return s;
  }

  async delete(id: string): Promise<void> {
    this.store.skills = this.store.skills.filter((s) => s.id !== id);
  }

  async reorderInCategory(categoryId: string, ids: string[]): Promise<void> {
    ids.forEach((id, position) => {
      const s = this.store.skills.find((x) => x.id === id && x.categoryId === categoryId);
      if (s) s.position = position;
    });
  }

  private next(categoryId: string): number {
    const positions = this.store.skills
      .filter((s) => s.categoryId === categoryId)
      .map((s) => s.position);
    return positions.length ? Math.max(...positions) + 1 : 0;
  }
}
