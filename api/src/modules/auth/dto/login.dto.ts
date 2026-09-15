import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsEnum, IsNotEmpty, IsString } from 'class-validator';
import { ClientPlatform } from './client-platform.enum.js';

export class LoginDto {
  @ApiProperty({ example: 'admin@example.com' })
  @IsEmail({}, { message: 'deve ser um e-mail válido' })
  email: string;

  @ApiProperty()
  @IsString({ message: 'deve ser texto' })
  @IsNotEmpty({ message: 'não pode ser vazia' })
  password: string;

  /** WEB → refresh em cookie httpOnly; MOBILE → refresh no body. */
  @ApiProperty({ enum: ClientPlatform, enumName: 'ClientPlatform' })
  @IsEnum(ClientPlatform, { message: 'deve ser WEB ou MOBILE' })
  clientPlatform: ClientPlatform;
}
