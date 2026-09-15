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
import { EducationInputDto } from './dto/education-input.dto.js';
import { EducationDto } from './dto/education.dto.js';
import { EducationsService } from './educations.service.js';

const { UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY } = HttpStatus;

@ApiTags('educations')
@Controller('educations')
export class EducationsController {
  constructor(private readonly educations: EducationsService) {}

  /** Em andamento primeiro; depois as mais recentes. */
  @Public()
  @Get()
  @ApiOkResponse({ type: [EducationDto] })
  @ApiErrorResponses()
  async listEducations(): Promise<EducationDto[]> {
    return (await this.educations.list()).map(EducationDto.from);
  }

  @Post()
  @ApiBearerAuth()
  @ApiCreatedResponse({ type: EducationDto })
  @ApiErrorResponses(UNAUTHORIZED, UNPROCESSABLE_ENTITY)
  async createEducation(@Body() dto: EducationInputDto): Promise<EducationDto> {
    return EducationDto.from(await this.educations.create(toData(dto)));
  }

  @Put(':id')
  @ApiBearerAuth()
  @ApiOkResponse({ type: EducationDto })
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY)
  async updateEducation(
    @Param('id', UuidParam) id: string,
    @Body() dto: EducationInputDto,
  ): Promise<EducationDto> {
    return EducationDto.from(await this.educations.update(id, toData(dto)));
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND)
  async deleteEducation(@Param('id', UuidParam) id: string): Promise<void> {
    await this.educations.remove(id);
  }
}

function toData(dto: EducationInputDto) {
  return {
    courseName: dto.courseName,
    institution: dto.institution,
    startYear: dto.startYear,
    endYear: dto.endYear ?? null,
  };
}
