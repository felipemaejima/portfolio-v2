import { randomUUID } from 'node:crypto';
import {
  type ProjectData,
  ProjectRepository,
  type ProjectWithImages,
} from '../../src/modules/projects/ports/project.repository.js';

export class InMemoryProjectRepository extends ProjectRepository {
  readonly projects: ProjectWithImages[] = [];
  failNextAddImages = false;

  private sorted(): ProjectWithImages[] {
    return [...this.projects]
      .sort((a, b) => a.position - b.position)
      .map((p) => ({ ...p, images: [...p.images].sort((a, b) => a.position - b.position) }));
  }

  async findAll(): Promise<ProjectWithImages[]> {
    return this.sorted();
  }

  async findBySlug(slug: string): Promise<ProjectWithImages | null> {
    return this.sorted().find((p) => p.slug === slug) ?? null;
  }

  async findById(id: string): Promise<ProjectWithImages | null> {
    return this.sorted().find((p) => p.id === id) ?? null;
  }

  async slugExists(slug: string): Promise<boolean> {
    return this.projects.some((p) => p.slug === slug);
  }

  async create(data: ProjectData & { slug: string }): Promise<ProjectWithImages> {
    const project: ProjectWithImages = {
      id: randomUUID(),
      ...data,
      position: this.projects.length ? Math.max(...this.projects.map((p) => p.position)) + 1 : 0,
      images: [],
      createdAt: new Date(),
      updatedAt: new Date(),
    };
    this.projects.push(project);
    return project;
  }

  async update(id: string, data: ProjectData): Promise<ProjectWithImages> {
    const p = this.mustFind(id);
    Object.assign(p, data, { updatedAt: new Date() });
    return p;
  }

  async delete(id: string): Promise<void> {
    this.projects.splice(this.projects.indexOf(this.mustFind(id)), 1);
  }

  async reorder(ids: string[]): Promise<void> {
    ids.forEach((id, position) => {
      this.mustFind(id).position = position;
    });
  }

  async addImages(projectId: string, imageKeys: string[]): Promise<ProjectWithImages> {
    if (this.failNextAddImages) {
      this.failNextAddImages = false;
      throw new Error('banco indisponível');
    }
    const p = this.mustFind(projectId);
    const start = p.images.length ? Math.max(...p.images.map((i) => i.position)) + 1 : 0;
    imageKeys.forEach((imageKey, i) => {
      p.images.push({
        id: randomUUID(),
        projectId,
        imageKey,
        position: start + i,
        createdAt: new Date(),
      });
    });
    return p;
  }

  async removeImage(projectId: string, imageId: string): Promise<void> {
    const p = this.mustFind(projectId);
    p.images = p.images.filter((i) => i.id !== imageId);
  }

  async reorderImages(projectId: string, imageIds: string[]): Promise<void> {
    const p = this.mustFind(projectId);
    imageIds.forEach((id, position) => {
      const img = p.images.find((i) => i.id === id);
      if (img) img.position = position;
    });
  }

  private mustFind(id: string): ProjectWithImages {
    const p = this.projects.find((x) => x.id === id);
    if (!p) throw new Error(`projeto ${id} não existe`);
    return p;
  }
}
