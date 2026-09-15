import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, Matches, MaxLength } from 'class-validator';
import type { ContactLink } from '../../../generated/prisma/client.js';

/** https://…, mailto:…, tel:… */
export const CONTACT_URL = /^(https?:\/\/\S+|mailto:\S+@\S+|tel:\+?[\d\s().-]+)$/;

export class ContactLinkInputDto {
  /** Nome do canal. */
  @ApiProperty({ example: 'GitHub' })
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazio' })
  @MaxLength(60, { message: 'no máximo 60 caracteres' })
  label: string;

  /** Texto exibido. */
  @ApiProperty({ example: 'github.com/usuario' })
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazio' })
  @MaxLength(160, { message: 'no máximo 160 caracteres' })
  value: string;

  /** Destino abrível pelo app: `https://…`, `mailto:…` ou `tel:…`. */
  @ApiProperty({ example: 'https://github.com/usuario' })
  @IsString({ message: 'deve ser texto' })
  @MaxLength(500, { message: 'no máximo 500 caracteres' })
  @Matches(CONTACT_URL, { message: 'deve começar com https://, http://, mailto: ou tel:' })
  url: string;
}

export class ContactLinkDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty()
  label: string;

  @ApiProperty()
  value: string;

  @ApiProperty()
  url: string;

  @ApiProperty({ type: 'integer' })
  position: number;

  @ApiProperty({ format: 'date-time' })
  createdAt: string;

  @ApiProperty({ format: 'date-time' })
  updatedAt: string;

  static from(l: ContactLink): ContactLinkDto {
    const dto = new ContactLinkDto();
    dto.id = l.id;
    dto.label = l.label;
    dto.value = l.value;
    dto.url = l.url;
    dto.position = l.position;
    dto.createdAt = l.createdAt.toISOString();
    dto.updatedAt = l.updatedAt.toISOString();
    return dto;
  }
}
