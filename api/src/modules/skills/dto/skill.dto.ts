import { ApiProperty } from '@nestjs/swagger';
import type { Skill } from '../../../generated/prisma/client.js';
import type { SkillCategoryWithSkills } from '../ports/skill-category.repository.js';

export class SkillDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ example: 'TypeScript' })
  name: string;

  /** Posição dentro da categoria. */
  @ApiProperty({ type: 'integer' })
  position: number;

  @ApiProperty({ format: 'uuid' })
  categoryId: string;

  @ApiProperty({ format: 'date-time' })
  createdAt: string;

  @ApiProperty({ format: 'date-time' })
  updatedAt: string;

  static from(skill: Skill): SkillDto {
    const dto = new SkillDto();
    dto.id = skill.id;
    dto.name = skill.name;
    dto.position = skill.position;
    dto.categoryId = skill.categoryId;
    dto.createdAt = skill.createdAt.toISOString();
    dto.updatedAt = skill.updatedAt.toISOString();
    return dto;
  }
}

export class SkillCategoryDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ example: 'Linguagens' })
  name: string;

  @ApiProperty({ type: 'integer' })
  position: number;

  /** Por `position`. */
  @ApiProperty({ type: [SkillDto] })
  skills: SkillDto[];

  @ApiProperty({ format: 'date-time' })
  createdAt: string;

  @ApiProperty({ format: 'date-time' })
  updatedAt: string;

  static from(category: SkillCategoryWithSkills): SkillCategoryDto {
    const dto = new SkillCategoryDto();
    dto.id = category.id;
    dto.name = category.name;
    dto.position = category.position;
    dto.skills = category.skills.map(SkillDto.from);
    dto.createdAt = category.createdAt.toISOString();
    dto.updatedAt = category.updatedAt.toISOString();
    return dto;
  }
}
