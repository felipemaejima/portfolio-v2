import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  IsArray,
  IsNotEmpty,
  IsOptional,
  IsString,
  Matches,
  MaxLength,
} from 'class-validator';

export const YEAR_MONTH = /^\d{4}-(0[1-9]|1[0-2])$/;

export class ExperienceInputDto {
  @ApiProperty({ example: 'Desenvolvedor Full-Stack' })
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazio' })
  @MaxLength(120, { message: 'no máximo 120 caracteres' })
  role: string;

  @ApiProperty({ example: 'Empresa Atual' })
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazio' })
  @MaxLength(120, { message: 'no máximo 120 caracteres' })
  companyName: string;

  /** Itens; viram bullets no CV. */
  @ApiProperty({ type: [String] })
  @IsArray({ message: 'deve ser uma lista' })
  @ArrayMaxSize(20, { message: 'no máximo 20 itens' })
  @IsString({ each: true, message: 'cada item deve ser texto' })
  @IsNotEmpty({ each: true, message: 'itens não podem ser vazios' })
  @MaxLength(300, { each: true, message: 'cada item com no máximo 300 caracteres' })
  activities: string[];

  /** Mês/ano, `YYYY-MM`. */
  @ApiProperty({ example: '2023-01', pattern: YEAR_MONTH.source })
  @Matches(YEAR_MONTH, { message: 'deve ser YYYY-MM' })
  startDate: string;

  /** Mês/ano, `YYYY-MM`; null = atual. */
  @ApiPropertyOptional({
    type: String,
    nullable: true,
    example: '2024-12',
    pattern: YEAR_MONTH.source,
  })
  @IsOptional()
  @Matches(YEAR_MONTH, { message: 'deve ser YYYY-MM' })
  endDate?: string | null;
}
