import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class RefreshDto {
  /** Só para MOBILE. No WEB o refresh vem no cookie e o body é vazio. */
  @ApiPropertyOptional()
  @IsOptional()
  @IsString({ message: 'deve ser texto' })
  refreshToken?: string;
}
