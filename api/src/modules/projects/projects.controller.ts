import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Patch,
  Post,
  Put,
  UploadedFiles,
  UseInterceptors,
} from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import {
  ApiBearerAuth,
  ApiBody,
  ApiConsumes,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { Public } from '../../shared/auth/public.decorator.js';
import { ApiErrorResponses } from '../../shared/http/decorators/api-error-responses.decorator.js';
import { ReorderDto } from '../../shared/http/dto/reorder.dto.js';
import { BadRequestError } from '../../shared/http/errors/domain.errors.js';
import { UuidParam } from '../../shared/http/pipes/uuid-param.pipe.js';
import { MAX_UPLOAD_BYTES } from '../../shared/storage/image-type.js';
import { ProjectInputDto } from './dto/project-input.dto.js';
import { ProjectDto } from './dto/project.dto.js';
import { MAX_IMAGES_PER_PROJECT, ProjectsService } from './projects.service.js';

interface UploadedImage {
  buffer: Buffer;
}

const { UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY } = HttpStatus;

@ApiTags('projects')
@Controller('projects')
export class ProjectsController {
  constructor(private readonly projects: ProjectsService) {}

  /** Todos os projetos, por `position`, com galeria. */
  @Public()
  @Get()
  @ApiOkResponse({ type: [ProjectDto] })
  @ApiErrorResponses()
  async listProjects(): Promise<ProjectDto[]> {
    return (await this.projects.list()).map(ProjectDto.from);
  }

  /** Detalhe pelo slug. */
  @Public()
  @Get(':slug')
  @ApiOkResponse({ type: ProjectDto })
  @ApiErrorResponses(NOT_FOUND)
  async getProjectBySlug(@Param('slug') slug: string): Promise<ProjectDto> {
    return ProjectDto.from(await this.projects.getBySlug(slug));
  }

  /** Cria no fim da vitrine; `slug` é derivado do nome. */
  @Post()
  @ApiBearerAuth()
  @ApiCreatedResponse({ type: ProjectDto })
  @ApiErrorResponses(UNAUTHORIZED, UNPROCESSABLE_ENTITY)
  async createProject(@Body() dto: ProjectInputDto): Promise<ProjectDto> {
    return ProjectDto.from(await this.projects.create(toData(dto)));
  }

  /** Substitui os campos; `slug` e galeria não mudam. */
  @Put(':id')
  @ApiBearerAuth()
  @ApiOkResponse({ type: ProjectDto })
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY)
  async updateProject(
    @Param('id', UuidParam) id: string,
    @Body() dto: ProjectInputDto,
  ): Promise<ProjectDto> {
    return ProjectDto.from(await this.projects.update(id, toData(dto)));
  }

  /** Apaga o projeto, suas imagens e os arquivos. */
  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND)
  async deleteProject(@Param('id', UuidParam) id: string): Promise<void> {
    await this.projects.remove(id);
  }

  /** Ordem da vitrine: o conjunto completo de ids na ordem final. */
  @Patch('reorder')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(UNAUTHORIZED, UNPROCESSABLE_ENTITY)
  async reorderProjects(@Body() dto: ReorderDto): Promise<void> {
    await this.projects.reorder(dto.ids);
  }

  /** Acrescenta imagens ao fim da galeria (multipart, campo `files`; jpeg/png/webp até 5 MB cada; 12 por projeto). */
  @Post(':id/images')
  @ApiBearerAuth()
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      required: ['files'],
      properties: {
        files: { type: 'array', items: { type: 'string', format: 'binary' } },
      },
    },
  })
  @UseInterceptors(
    FilesInterceptor('files', MAX_IMAGES_PER_PROJECT, { limits: { fileSize: MAX_UPLOAD_BYTES } }),
  )
  @ApiCreatedResponse({ type: ProjectDto })
  @ApiErrorResponses(
    HttpStatus.BAD_REQUEST,
    UNAUTHORIZED,
    NOT_FOUND,
    HttpStatus.PAYLOAD_TOO_LARGE,
    HttpStatus.UNSUPPORTED_MEDIA_TYPE,
    UNPROCESSABLE_ENTITY,
  )
  async addProjectImages(
    @Param('id', UuidParam) id: string,
    @UploadedFiles() files?: UploadedImage[],
  ): Promise<ProjectDto> {
    if (!files?.length) throw new BadRequestError('Envie ao menos um arquivo no campo "files".');
    return ProjectDto.from(
      await this.projects.addImages(
        id,
        files.map((f) => f.buffer),
      ),
    );
  }

  /** Remove uma imagem da galeria e o arquivo. */
  @Delete(':id/images/:imageId')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND)
  async deleteProjectImage(
    @Param('id', UuidParam) id: string,
    @Param('imageId', UuidParam) imageId: string,
  ): Promise<void> {
    await this.projects.removeImage(id, imageId);
  }

  /** Ordem da galeria: o conjunto completo de ids das imagens na ordem final. */
  @Patch(':id/images/reorder')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY)
  async reorderProjectImages(
    @Param('id', UuidParam) id: string,
    @Body() dto: ReorderDto,
  ): Promise<void> {
    await this.projects.reorderImages(id, dto.ids);
  }
}

function toData(dto: ProjectInputDto) {
  return {
    name: dto.name,
    shortDescription: dto.shortDescription,
    fullDescription: dto.fullDescription,
    technologies: dto.technologies,
    codeUrl: dto.codeUrl ?? null,
    demoUrl: dto.demoUrl ?? null,
  };
}
