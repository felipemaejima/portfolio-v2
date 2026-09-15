import { ApiProperty } from '@nestjs/swagger';
import { ArrayNotEmpty, ArrayUnique, IsArray, IsUUID } from 'class-validator';

/** Body de todo `PATCH …/reorder`: o conjunto completo de ids do escopo, na ordem final. */
export class ReorderDto {
  @ApiProperty({ type: [String], format: 'uuid' })
  @IsArray({ message: 'deve ser uma lista' })
  @ArrayNotEmpty({ message: 'não pode ser vazia' })
  @ArrayUnique({ message: 'não pode ter ids repetidos' })
  @IsUUID('all', { each: true, message: 'cada item deve ser um UUID' })
  ids: string[];
}
