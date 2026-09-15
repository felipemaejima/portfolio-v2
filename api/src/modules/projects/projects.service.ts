import { Injectable } from '@nestjs/common';
import { assertSameIdSet } from '../../shared/domain/reorder.js';
import { slugify, uniqueSlug } from '../../shared/domain/slug.js';
import { NotFoundError, ValidationError } from '../../shared/http/errors/domain.errors.js';
import { FileStorage } from '../../shared/storage/file-storage.js';
import { detectImage } from '../../shared/storage/image-type.js';
import {
  type ProjectData,
  ProjectRepository,
  type ProjectWithImages,
} from './ports/project.repository.js';

export const MAX_IMAGES_PER_PROJECT = 12;
const IMAGE_PREFIX = 'projects';

export interface ProjectImageView {
  id: string;
  url: string;
  position: number;
}

export type ProjectView = Omit<ProjectWithImages, 'images'> & { images: ProjectImageView[] };

@Injectable()
export class ProjectsService {
  constructor(
    private readonly projects: ProjectRepository,
    private readonly storage: FileStorage,
  ) {}

  async list(): Promise<ProjectView[]> {
    return (await this.projects.findAll()).map((p) => this.view(p));
  }

  async getBySlug(slug: string): Promise<ProjectView> {
    const project = await this.projects.findBySlug(slug);
    if (!project) throw new NotFoundError('Projeto não encontrado.');
    return this.view(project);
  }

  async create(data: ProjectData): Promise<ProjectView> {
    const slug = await uniqueSlug(slugify(data.name), (s) => this.projects.slugExists(s));
    return this.view(await this.projects.create({ ...data, slug }));
  }

  /** `slug` não muda: URLs já compartilhadas continuam válidas. */
  async update(id: string, data: ProjectData): Promise<ProjectView> {
    await this.require(id);
    return this.view(await this.projects.update(id, data));
  }

  /** Apaga linhas (cascata) e depois os arquivos; arquivo órfão é melhor que linha órfã. */
  async remove(id: string): Promise<void> {
    const project = await this.require(id);
    await this.projects.delete(id);
    await Promise.all(project.images.map((img) => this.storage.delete(img.imageKey)));
  }

  async reorder(ids: string[]): Promise<void> {
    const all = await this.projects.findAll();
    assertSameIdSet(
      all.map((p) => p.id),
      ids,
    );
    await this.projects.reorder(ids);
  }

  /** Valida todos os arquivos antes de gravar qualquer um; falha ao persistir remove os novos. */
  async addImages(id: string, buffers: Buffer[]): Promise<ProjectView> {
    const project = await this.require(id);
    if (project.images.length + buffers.length > MAX_IMAGES_PER_PROJECT) {
      throw new ValidationError({
        files: [`no máximo ${MAX_IMAGES_PER_PROJECT} imagens por projeto`],
      });
    }
    const detected = await Promise.all(buffers.map((b) => detectImage(b)));
    const stored = await Promise.all(
      buffers.map((buffer, i) =>
        this.storage.put({ buffer, mime: detected[i]!.mime }, `${IMAGE_PREFIX}/${id}`),
      ),
    );
    try {
      return this.view(
        await this.projects.addImages(
          id,
          stored.map((s) => s.key),
        ),
      );
    } catch (error) {
      await Promise.all(stored.map((s) => this.storage.delete(s.key)));
      throw error;
    }
  }

  async removeImage(id: string, imageId: string): Promise<void> {
    const project = await this.require(id);
    const image = project.images.find((img) => img.id === imageId);
    if (!image) throw new NotFoundError('Imagem não encontrada.');
    await this.projects.removeImage(id, imageId);
    await this.storage.delete(image.imageKey);
  }

  async reorderImages(id: string, imageIds: string[]): Promise<void> {
    const project = await this.require(id);
    assertSameIdSet(
      project.images.map((img) => img.id),
      imageIds,
    );
    await this.projects.reorderImages(id, imageIds);
  }

  private async require(id: string): Promise<ProjectWithImages> {
    const project = await this.projects.findById(id);
    if (!project) throw new NotFoundError('Projeto não encontrado.');
    return project;
  }

  private view(project: ProjectWithImages): ProjectView {
    return {
      ...project,
      images: project.images.map((img) => ({
        id: img.id,
        url: this.storage.urlFor(img.imageKey),
        position: img.position,
      })),
    };
  }
}
