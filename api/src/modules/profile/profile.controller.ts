import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Put,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiBearerAuth,
  ApiBody,
  ApiConsumes,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { Public } from '../../shared/auth/public.decorator.js';
import { ApiErrorResponses } from '../../shared/http/decorators/api-error-responses.decorator.js';
import { BadRequestError } from '../../shared/http/errors/domain.errors.js';
import { MAX_UPLOAD_BYTES } from '../../shared/storage/image-type.js';
import { ProfileDto } from './dto/profile.dto.js';
import { UpdateProfileDto } from './dto/update-profile.dto.js';
import { ProfileService } from './profile.service.js';

/** O que o multer entrega em memória; só o que usamos. */
interface UploadedImage {
  buffer: Buffer;
}

@ApiTags('profile')
@Controller('profile')
export class ProfileController {
  constructor(private readonly profile: ProfileService) {}

  /** Dados de apresentação do Admin (seção "Sobre"). Nunca expõe credenciais. */
  @Public()
  @Get()
  @ApiOkResponse({ type: ProfileDto })
  @ApiErrorResponses()
  async getProfile(): Promise<ProfileDto> {
    return ProfileDto.from(await this.profile.get());
  }

  /** Substitui o Profile inteiro. */
  @Put()
  @ApiBearerAuth()
  @ApiOkResponse({ type: ProfileDto })
  @ApiErrorResponses(HttpStatus.UNAUTHORIZED, HttpStatus.UNPROCESSABLE_ENTITY)
  async updateProfile(@Body() dto: UpdateProfileDto): Promise<ProfileDto> {
    const { location, contactIntro, ...rest } = dto;
    return ProfileDto.from(
      await this.profile.update({ ...rest, ...location, contactIntro: contactIntro ?? null }),
    );
  }

  /** Substitui a foto (multipart, campo `file`; jpeg/png/webp até 5 MB). */
  @Put('image')
  @ApiBearerAuth()
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      required: ['file'],
      properties: { file: { type: 'string', format: 'binary' } },
    },
  })
  @UseInterceptors(FileInterceptor('file', { limits: { fileSize: MAX_UPLOAD_BYTES, files: 1 } }))
  @ApiOkResponse({ type: ProfileDto })
  @ApiErrorResponses(
    HttpStatus.BAD_REQUEST,
    HttpStatus.UNAUTHORIZED,
    HttpStatus.PAYLOAD_TOO_LARGE,
    HttpStatus.UNSUPPORTED_MEDIA_TYPE,
  )
  async updateProfileImage(@UploadedFile() file?: UploadedImage): Promise<ProfileDto> {
    if (!file) throw new BadRequestError('Envie o arquivo no campo "file".');
    return ProfileDto.from(await this.profile.updateImage(file.buffer));
  }

  /** Remove a foto. */
  @Delete('image')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(HttpStatus.UNAUTHORIZED)
  async deleteProfileImage(): Promise<void> {
    await this.profile.deleteImage();
  }
}
