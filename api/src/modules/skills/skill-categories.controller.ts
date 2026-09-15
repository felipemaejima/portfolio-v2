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
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { Public } from '../../shared/auth/public.decorator.js';
import { ApiErrorResponses } from '../../shared/http/decorators/api-error-responses.decorator.js';
import { ReorderDto } from '../../shared/http/dto/reorder.dto.js';
import { UuidParam } from '../../shared/http/pipes/uuid-param.pipe.js';
import { CreateSkillDto, SkillCategoryInputDto } from './dto/skill-input.dto.js';
import { SkillCategoryDto, SkillDto } from './dto/skill.dto.js';
import { SkillsService } from './skills.service.js';

const { UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY } = HttpStatus;

@ApiTags('skills')
@Controller('skill-categories')
export class SkillCategoriesController {
  constructor(private readonly skills: SkillsService) {}

  /** Categorias por `position`, cada uma com suas skills por `position`. */
  @Public()
  @Get()
  @ApiOkResponse({ type: [SkillCategoryDto] })
  @ApiErrorResponses()
  async listSkillCategories(): Promise<SkillCategoryDto[]> {
    return (await this.skills.listCategories()).map(SkillCategoryDto.from);
  }

  /** Cria no fim. */
  @Post()
  @ApiBearerAuth()
  @ApiCreatedResponse({ type: SkillCategoryDto })
  @ApiErrorResponses(UNAUTHORIZED, UNPROCESSABLE_ENTITY)
  async createSkillCategory(@Body() dto: SkillCategoryInputDto): Promise<SkillCategoryDto> {
    return SkillCategoryDto.from(await this.skills.createCategory(dto.name));
  }

  @Put(':id')
  @ApiBearerAuth()
  @ApiOkResponse({ type: SkillCategoryDto })
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY)
  async updateSkillCategory(
    @Param('id', UuidParam) id: string,
    @Body() dto: SkillCategoryInputDto,
  ): Promise<SkillCategoryDto> {
    return SkillCategoryDto.from(await this.skills.updateCategory(id, dto.name));
  }

  /** Apaga a categoria e suas skills. */
  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND)
  async deleteSkillCategory(@Param('id', UuidParam) id: string): Promise<void> {
    await this.skills.deleteCategory(id);
  }

  /** Ordem das categorias: o conjunto completo de ids na ordem final. */
  @Patch('reorder')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(UNAUTHORIZED, UNPROCESSABLE_ENTITY)
  async reorderSkillCategories(@Body() dto: ReorderDto): Promise<void> {
    await this.skills.reorderCategories(dto.ids);
  }

  /** Cria uma skill no fim da categoria. */
  @Post(':id/skills')
  @ApiBearerAuth()
  @ApiCreatedResponse({ type: SkillDto })
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY)
  async createSkill(
    @Param('id', UuidParam) categoryId: string,
    @Body() dto: CreateSkillDto,
  ): Promise<SkillDto> {
    return SkillDto.from(await this.skills.createSkill(categoryId, dto.name));
  }

  /** Ordem das skills dentro da categoria: o conjunto completo de ids na ordem final. */
  @Patch(':id/skills/reorder')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY)
  async reorderSkills(
    @Param('id', UuidParam) categoryId: string,
    @Body() dto: ReorderDto,
  ): Promise<void> {
    await this.skills.reorderSkills(categoryId, dto.ids);
  }
}
