import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsNotEmpty, IsString, MaxLength } from 'class-validator';
import { LanguageLevel } from '../../../shared/domain/enums.js';

export class LocationDto {
  @ApiProperty({ example: 'São Paulo' })
  @IsString({ message: 'deve ser texto' })
  @MaxLength(80, { message: 'no máximo 80 caracteres' })
  city: string;

  @ApiProperty({ example: 'SP' })
  @IsString({ message: 'deve ser texto' })
  @MaxLength(80, { message: 'no máximo 80 caracteres' })
  state: string;

  @ApiProperty({ example: 'Brasil' })
  @IsString({ message: 'deve ser texto' })
  @MaxLength(80, { message: 'no máximo 80 caracteres' })
  country: string;
}

export class LanguageDto {
  /** Nome do idioma, texto livre em PT-BR. */
  @ApiProperty({ example: 'Inglês' })
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazio' })
  @MaxLength(60, { message: 'no máximo 60 caracteres' })
  language: string;

  @ApiProperty({ enum: LanguageLevel, enumName: 'LanguageLevel' })
  @IsEnum(LanguageLevel, { message: 'nível inválido' })
  level: LanguageLevel;
}
