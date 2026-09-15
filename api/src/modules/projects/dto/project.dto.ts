import { ApiProperty } from '@nestjs/swagger';
import type { ProjectImageView, ProjectView } from '../projects.service.js';

export class ProjectImageDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  /** URL pública permanente. */
  @ApiProperty()
  url: string;

  @ApiProperty({ type: 'integer' })
  position: number;

  static from(image: ProjectImageView): ProjectImageDto {
    const dto = new ProjectImageDto();
    dto.id = image.id;
    dto.url = image.url;
    dto.position = image.position;
    return dto;
  }
}

export class ProjectDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty()
  name: string;

  /** Identificador público na rota de detalhe; imutável. */
  @ApiProperty({ example: 'portfolio-api' })
  slug: string;

  @ApiProperty()
  shortDescription: string;

  @ApiProperty()
  fullDescription: string;

  @ApiProperty({ type: [String] })
  technologies: string[];

  @ApiProperty({ type: String, nullable: true })
  codeUrl: string | null;

  @ApiProperty({ type: String, nullable: true })
  demoUrl: string | null;

  @ApiProperty({ type: 'integer' })
  position: number;

  /** Galeria, por `position`. A primeira é a capa. */
  @ApiProperty({ type: [ProjectImageDto] })
  images: ProjectImageDto[];

  @ApiProperty({ format: 'date-time' })
  createdAt: string;

  @ApiProperty({ format: 'date-time' })
  updatedAt: string;

  static from(view: ProjectView): ProjectDto {
    const dto = new ProjectDto();
    dto.id = view.id;
    dto.name = view.name;
    dto.slug = view.slug;
    dto.shortDescription = view.shortDescription;
    dto.fullDescription = view.fullDescription;
    dto.technologies = view.technologies;
    dto.codeUrl = view.codeUrl;
    dto.demoUrl = view.demoUrl;
    dto.position = view.position;
    dto.images = view.images.map(ProjectImageDto.from);
    dto.createdAt = view.createdAt.toISOString();
    dto.updatedAt = view.updatedAt.toISOString();
    return dto;
  }
}
