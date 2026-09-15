import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
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
import { UuidParam } from '../../shared/http/pipes/uuid-param.pipe.js';
import { ExperienceInputDto } from './dto/experience-input.dto.js';
import { ExperienceDto } from './dto/experience.dto.js';
import { ExperiencesService } from './experiences.service.js';

const { UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY } = HttpStatus;

@ApiTags('experiences')
@Controller('experiences')
export class ExperiencesController {
  constructor(private readonly experiences: ExperiencesService) {}

  /** Atual primeiro; depois as mais recentes. */
  @Public()
  @Get()
  @ApiOkResponse({ type: [ExperienceDto] })
  @ApiErrorResponses()
  async listExperiences(): Promise<ExperienceDto[]> {
    return (await this.experiences.list()).map(ExperienceDto.from);
  }

  @Post()
  @ApiBearerAuth()
  @ApiCreatedResponse({ type: ExperienceDto })
  @ApiErrorResponses(UNAUTHORIZED, UNPROCESSABLE_ENTITY)
  async createExperience(@Body() dto: ExperienceInputDto): Promise<ExperienceDto> {
    return ExperienceDto.from(await this.experiences.create(toData(dto)));
  }

  @Put(':id')
  @ApiBearerAuth()
  @ApiOkResponse({ type: ExperienceDto })
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY)
  async updateExperience(
    @Param('id', UuidParam) id: string,
    @Body() dto: ExperienceInputDto,
  ): Promise<ExperienceDto> {
    return ExperienceDto.from(await this.experiences.update(id, toData(dto)));
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND)
  async deleteExperience(@Param('id', UuidParam) id: string): Promise<void> {
    await this.experiences.remove(id);
  }
}

function toData(dto: ExperienceInputDto) {
  return {
    role: dto.role,
    companyName: dto.companyName,
    activities: dto.activities,
    startDate: dto.startDate,
    endDate: dto.endDate ?? null,
  };
}
