import { Body, Controller, Delete, HttpCode, HttpStatus, Param, Put } from '@nestjs/common';
import { ApiBearerAuth, ApiNoContentResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { ApiErrorResponses } from '../../shared/http/decorators/api-error-responses.decorator.js';
import { UuidParam } from '../../shared/http/pipes/uuid-param.pipe.js';
import { UpdateSkillDto } from './dto/skill-input.dto.js';
import { SkillDto } from './dto/skill.dto.js';
import { SkillsService } from './skills.service.js';

const { UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY } = HttpStatus;

@ApiTags('skills')
@Controller('skills')
export class SkillsController {
  constructor(private readonly skills: SkillsService) {}

  /** Renomeia e/ou move de categoria (vai para o fim da nova). */
  @Put(':id')
  @ApiBearerAuth()
  @ApiOkResponse({ type: SkillDto })
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY)
  async updateSkill(
    @Param('id', UuidParam) id: string,
    @Body() dto: UpdateSkillDto,
  ): Promise<SkillDto> {
    return SkillDto.from(await this.skills.updateSkill(id, dto));
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND)
  async deleteSkill(@Param('id', UuidParam) id: string): Promise<void> {
    await this.skills.deleteSkill(id);
  }
}
