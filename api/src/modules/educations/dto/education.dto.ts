import { ApiProperty } from '@nestjs/swagger';
import type { Education } from '../../../generated/prisma/client.js';

export class EducationDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty()
  courseName: string;

  @ApiProperty()
  institution: string;

  @ApiProperty({ type: 'integer' })
  startYear: number;

  /** null = em andamento. */
  @ApiProperty({ type: 'integer', nullable: true })
  endYear: number | null;

  @ApiProperty({ format: 'date-time' })
  createdAt: string;

  @ApiProperty({ format: 'date-time' })
  updatedAt: string;

  static from(e: Education): EducationDto {
    const dto = new EducationDto();
    dto.id = e.id;
    dto.courseName = e.courseName;
    dto.institution = e.institution;
    dto.startYear = e.startYear;
    dto.endYear = e.endYear;
    dto.createdAt = e.createdAt.toISOString();
    dto.updatedAt = e.updatedAt.toISOString();
    return dto;
  }
}
