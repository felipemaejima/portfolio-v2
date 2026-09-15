import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayUnique,
  IsArray,
  IsEnum,
  IsNotEmpty,
  IsString,
  MaxLength,
  ValidateNested,
} from 'class-validator';
import { Availability, WorkMode } from '../../../shared/domain/enums.js';
import { LanguageDto, LocationDto } from './profile-parts.dto.js';

/** PUT /profile: substitui o Profile inteiro. */
export class UpdateProfileDto {
  @ApiProperty({ example: 'Nome Sobrenome' })
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazio' })
  @MaxLength(120, { message: 'no máximo 120 caracteres' })
  name: string;

  /** Uma linha acima do nome no hero. */
  @ApiProperty({ example: 'Desenvolvedor Full-Stack' })
  @IsString({ message: 'deve ser texto' })
  @MaxLength(160, { message: 'no máximo 160 caracteres' })
  headline: string;

  /** Parágrafo curto do hero. */
  @ApiProperty()
  @IsString({ message: 'deve ser texto' })
  @MaxLength(600, { message: 'no máximo 600 caracteres' })
  summary: string;

  /** Texto longo do "Sobre mim"; parágrafos separados por linha em branco. */
  @ApiProperty()
  @IsString({ message: 'deve ser texto' })
  @MaxLength(5000, { message: 'no máximo 5000 caracteres' })
  description: string;

  @ApiProperty({ type: LocationDto })
  @ValidateNested()
  @Type(() => LocationDto)
  location: LocationDto;

  @ApiProperty({ enum: Availability, enumName: 'Availability', isArray: true })
  @IsArray({ message: 'deve ser uma lista' })
  @ArrayUnique({ message: 'não pode repetir valores' })
  @IsEnum(Availability, { each: true, message: 'disponibilidade inválida' })
  availability: Availability[];

  @ApiProperty({ enum: WorkMode, enumName: 'WorkMode', isArray: true })
  @IsArray({ message: 'deve ser uma lista' })
  @ArrayUnique({ message: 'não pode repetir valores' })
  @IsEnum(WorkMode, { each: true, message: 'modalidade inválida' })
  workModes: WorkMode[];

  @ApiProperty({ type: [LanguageDto] })
  @IsArray({ message: 'deve ser uma lista' })
  @ArrayMaxSize(10, { message: 'no máximo 10 idiomas' })
  @ValidateNested({ each: true })
  @Type(() => LanguageDto)
  languages: LanguageDto[];
}
