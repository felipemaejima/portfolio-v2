import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, IsUUID, MaxLength } from 'class-validator';

export class SkillCategoryInputDto {
  @ApiProperty({ example: 'Linguagens' })
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazio' })
  @MaxLength(60, { message: 'no máximo 60 caracteres' })
  name: string;
}

/** POST /skill-categories/{id}/skills — a categoria vem da rota. */
export class CreateSkillDto {
  @ApiProperty({ example: 'TypeScript' })
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazio' })
  @MaxLength(60, { message: 'no máximo 60 caracteres' })
  name: string;
}

/** PUT /skills/{id} — mudar `categoryId` move a skill para o fim da nova categoria. */
export class UpdateSkillDto extends CreateSkillDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID('all', { message: 'deve ser um UUID' })
  categoryId: string;
}
