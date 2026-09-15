import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsInt, IsNotEmpty, IsOptional, IsString, Max, MaxLength, Min } from 'class-validator';

export class EducationInputDto {
  @ApiProperty({ example: 'Bacharelado em Ciência da Computação' })
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazio' })
  @MaxLength(160, { message: 'no máximo 160 caracteres' })
  courseName: string;

  @ApiProperty({ example: 'Nome da Universidade' })
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazio' })
  @MaxLength(160, { message: 'no máximo 160 caracteres' })
  institution: string;

  @ApiProperty({ type: 'integer', example: 2017 })
  @IsInt({ message: 'deve ser um ano' })
  @Min(1900, { message: 'ano inválido' })
  @Max(2100, { message: 'ano inválido' })
  startYear: number;

  /** null = em andamento. Igual a `startYear` → exibe um ano só. */
  @ApiPropertyOptional({ type: 'integer', nullable: true, example: 2021 })
  @IsOptional()
  @IsInt({ message: 'deve ser um ano' })
  @Min(1900, { message: 'ano inválido' })
  @Max(2100, { message: 'ano inválido' })
  endYear?: number | null;
}
