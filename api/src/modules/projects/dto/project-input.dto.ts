import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  IsArray,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUrl,
  MaxLength,
} from 'class-validator';

/** Corpo de POST /projects e PUT /projects/{id}. `slug` não é editável. */
export class ProjectInputDto {
  @ApiProperty({ example: 'Portfolio API' })
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazio' })
  @MaxLength(120, { message: 'no máximo 120 caracteres' })
  name: string;

  /** Usada na listagem/cards. */
  @ApiProperty()
  @IsString({ message: 'deve ser texto' })
  @MaxLength(300, { message: 'no máximo 300 caracteres' })
  shortDescription: string;

  /** Usada no detalhe. */
  @ApiProperty()
  @IsString({ message: 'deve ser texto' })
  @MaxLength(10000, { message: 'no máximo 10000 caracteres' })
  fullDescription: string;

  @ApiProperty({ type: [String], example: ['NestJS', 'Flutter'] })
  @IsArray({ message: 'deve ser uma lista' })
  @ArrayMaxSize(30, { message: 'no máximo 30 tecnologias' })
  @IsString({ each: true, message: 'cada item deve ser texto' })
  @IsNotEmpty({ each: true, message: 'itens não podem ser vazios' })
  @MaxLength(40, { each: true, message: 'cada item com no máximo 40 caracteres' })
  technologies: string[];

  @ApiPropertyOptional({ type: String, nullable: true, example: 'https://github.com/x/y' })
  @IsOptional()
  @IsUrl({ require_protocol: true }, { message: 'deve ser uma URL válida' })
  codeUrl?: string | null;

  @ApiPropertyOptional({ type: String, nullable: true })
  @IsOptional()
  @IsUrl({ require_protocol: true }, { message: 'deve ser uma URL válida' })
  demoUrl?: string | null;
}
