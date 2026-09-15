import { ApiProperty } from '@nestjs/swagger';
import type { Offering } from '../../../generated/prisma/client.js';

/** Serviço oferecido (rótulo "Serviços" na UI). */
export class OfferingDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty()
  title: string;

  @ApiProperty()
  description: string;

  @ApiProperty({ type: 'integer' })
  position: number;

  @ApiProperty({ format: 'date-time' })
  createdAt: string;

  @ApiProperty({ format: 'date-time' })
  updatedAt: string;

  static from(o: Offering): OfferingDto {
    const dto = new OfferingDto();
    dto.id = o.id;
    dto.title = o.title;
    dto.description = o.description;
    dto.position = o.position;
    dto.createdAt = o.createdAt.toISOString();
    dto.updatedAt = o.updatedAt.toISOString();
    return dto;
  }
}
