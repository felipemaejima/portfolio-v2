import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsString, MaxLength } from 'class-validator';
import type { ContactMessage } from '../../../generated/prisma/client.js';

/** POST /contact-messages — enviado por um Visitor. */
export class CreateContactMessageDto {
  @ApiProperty({ example: 'Maria' })
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazio' })
  @MaxLength(120, { message: 'no máximo 120 caracteres' })
  name: string;

  @ApiProperty({ example: 'maria@example.com' })
  @IsEmail({}, { message: 'deve ser um e-mail válido' })
  @MaxLength(254, { message: 'no máximo 254 caracteres' })
  email: string;

  @ApiProperty()
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazia' })
  @MaxLength(5000, { message: 'no máximo 5000 caracteres' })
  message: string;
}

export class ContactMessageDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty()
  name: string;

  @ApiProperty()
  email: string;

  @ApiProperty()
  message: string;

  /** null = não lida. */
  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  readAt: string | null;

  @ApiProperty({ format: 'date-time' })
  createdAt: string;

  static from(m: ContactMessage): ContactMessageDto {
    const dto = new ContactMessageDto();
    dto.id = m.id;
    dto.name = m.name;
    dto.email = m.email;
    dto.message = m.message;
    dto.readAt = m.readAt ? m.readAt.toISOString() : null;
    dto.createdAt = m.createdAt.toISOString();
    return dto;
  }
}
