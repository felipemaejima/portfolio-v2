import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, MaxLength } from 'class-validator';

export class OfferingInputDto {
  @ApiProperty({ example: 'Desenvolvimento web' })
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazio' })
  @MaxLength(120, { message: 'no máximo 120 caracteres' })
  title: string;

  @ApiProperty({ example: 'Criação de aplicações do zero, do backend ao frontend.' })
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazio' })
  @MaxLength(600, { message: 'no máximo 600 caracteres' })
  description: string;
}
