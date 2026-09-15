import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../shared/prisma/prisma.service.js';
import {
  type ProjectData,
  ProjectRepository,
  type ProjectWithImages,
} from '../ports/project.repository.js';

const withImages = { images: { orderBy: { position: 'asc' as const } } };

@Injectable()
export class PrismaProjectRepository extends ProjectRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  findAll(): Promise<ProjectWithImages[]> {
    return this.prisma.project.findMany({ orderBy: { position: 'asc' }, include: withImages });
  }

  findBySlug(slug: string): Promise<ProjectWithImages | null> {
    return this.prisma.project.findUnique({ where: { slug }, include: withImages });
  }

  findById(id: string): Promise<ProjectWithImages | null> {
    return this.prisma.project.findUnique({ where: { id }, include: withImages });
  }

  async slugExists(slug: string): Promise<boolean> {
    return (await this.prisma.project.count({ where: { slug } })) > 0;
  }

  create(data: ProjectData & { slug: string }): Promise<ProjectWithImages> {
    return this.prisma.$transaction(async (tx) => {
      const max = await tx.project.aggregate({ _max: { position: true } });
      return tx.project.create({
        data: { ...data, position: (max._max.position ?? -1) + 1 },
        include: withImages,
      });
    });
  }

  update(id: string, data: ProjectData): Promise<ProjectWithImages> {
    return this.prisma.project.update({ where: { id }, data, include: withImages });
  }

  async delete(id: string): Promise<void> {
    await this.prisma.project.delete({ where: { id } });
  }

  async reorder(ids: string[]): Promise<void> {
    await this.prisma.$transaction(
      ids.map((id, position) => this.prisma.project.update({ where: { id }, data: { position } })),
    );
  }

  addImages(projectId: string, imageKeys: string[]): Promise<ProjectWithImages> {
    return this.prisma.$transaction(async (tx) => {
      const max = await tx.projectImage.aggregate({
        where: { projectId },
        _max: { position: true },
      });
      const start = (max._max.position ?? -1) + 1;
      await tx.projectImage.createMany({
        data: imageKeys.map((imageKey, i) => ({ projectId, imageKey, position: start + i })),
      });
      return tx.project.findUniqueOrThrow({ where: { id: projectId }, include: withImages });
    });
  }

  async removeImage(projectId: string, imageId: string): Promise<void> {
    await this.prisma.projectImage.delete({ where: { id: imageId, projectId } });
  }

  async reorderImages(projectId: string, imageIds: string[]): Promise<void> {
    await this.prisma.$transaction(
      imageIds.map((id, position) =>
        this.prisma.projectImage.update({ where: { id, projectId }, data: { position } }),
      ),
    );
  }
}
