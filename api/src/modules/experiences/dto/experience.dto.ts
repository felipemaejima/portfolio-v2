import { ApiProperty } from '@nestjs/swagger';
import type { Experience } from '../../../generated/prisma/client.js';

export class ExperienceDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty()
  role: string;

  @ApiProperty()
  companyName: string;

  @ApiProperty({ type: [String] })
  activities: string[];

  /** `YYYY-MM` */
  @ApiProperty({ example: '2023-01' })
  startDate: string;

  /** `YYYY-MM`; null = atual. */
  @ApiProperty({ type: String, nullable: true })
  endDate: string | null;

  @ApiProperty({ format: 'date-time' })
  createdAt: string;

  @ApiProperty({ format: 'date-time' })
  updatedAt: string;

  static from(e: Experience): ExperienceDto {
    const dto = new ExperienceDto();
    dto.id = e.id;
    dto.role = e.role;
    dto.companyName = e.companyName;
    dto.activities = e.activities;
    dto.startDate = e.startDate;
    dto.endDate = e.endDate;
    dto.createdAt = e.createdAt.toISOString();
    dto.updatedAt = e.updatedAt.toISOString();
    return dto;
  }
}
