import type { Prisma } from '../../../generated/prisma/client.js';

export type ProjectWithImages = Prisma.ProjectGetPayload<{ include: { images: true } }>;

export interface ProjectData {
  name: string;
  shortDescription: string;
  fullDescription: string;
  technologies: string[];
  codeUrl: string | null;
  demoUrl: string | null;
}

export abstract class ProjectRepository {
  /** Por `position`, imagens por `position`. */
  abstract findAll(): Promise<ProjectWithImages[]>;
  abstract findBySlug(slug: string): Promise<ProjectWithImages | null>;
  abstract findById(id: string): Promise<ProjectWithImages | null>;
  abstract slugExists(slug: string): Promise<boolean>;
  /** Entra no fim (`position` = max + 1). */
  abstract create(data: ProjectData & { slug: string }): Promise<ProjectWithImages>;
  abstract update(id: string, data: ProjectData): Promise<ProjectWithImages>;
  /** Cascata nas imagens (linhas). Arquivos são responsabilidade do service. */
  abstract delete(id: string): Promise<void>;
  /** `position` = índice na lista, em transação. */
  abstract reorder(ids: string[]): Promise<void>;
  /** Entram no fim da galeria, na ordem dada. */
  abstract addImages(projectId: string, imageKeys: string[]): Promise<ProjectWithImages>;
  abstract removeImage(projectId: string, imageId: string): Promise<void>;
  abstract reorderImages(projectId: string, imageIds: string[]): Promise<void>;
}
