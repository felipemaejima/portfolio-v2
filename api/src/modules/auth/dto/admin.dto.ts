import { ApiProperty } from '@nestjs/swagger';
import type { Admin } from '../../../generated/prisma/client.js';

export class AdminDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ example: 'admin@example.com' })
  email: string;

  static from(admin: Pick<Admin, 'id' | 'email'>): AdminDto {
    const dto = new AdminDto();
    dto.id = admin.id;
    dto.email = admin.email;
    return dto;
  }
}
