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
import { OfferingInputDto } from './dto/offering-input.dto.js';
import { OfferingDto } from './dto/offering.dto.js';
import { OfferingsService } from './offerings.service.js';

const { UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY } = HttpStatus;

@ApiTags('offerings')
@Controller('offerings')
export class OfferingsController {
  constructor(private readonly offerings: OfferingsService) {}

  /** Serviços oferecidos, por `position`. */
  @Public()
  @Get()
  @ApiOkResponse({ type: [OfferingDto] })
  @ApiErrorResponses()
  async listOfferings(): Promise<OfferingDto[]> {
    return (await this.offerings.list()).map(OfferingDto.from);
  }

  /** Cria no fim. */
  @Post()
  @ApiBearerAuth()
  @ApiCreatedResponse({ type: OfferingDto })
  @ApiErrorResponses(UNAUTHORIZED, UNPROCESSABLE_ENTITY)
  async createOffering(@Body() dto: OfferingInputDto): Promise<OfferingDto> {
    return OfferingDto.from(await this.offerings.create(dto));
  }

  @Put(':id')
  @ApiBearerAuth()
  @ApiOkResponse({ type: OfferingDto })
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY)
  async updateOffering(
    @Param('id', UuidParam) id: string,
    @Body() dto: OfferingInputDto,
  ): Promise<OfferingDto> {
    return OfferingDto.from(await this.offerings.update(id, dto));
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND)
  async deleteOffering(@Param('id', UuidParam) id: string): Promise<void> {
    await this.offerings.remove(id);
  }

  /** Ordem de exibição: o conjunto completo de ids na ordem final. */
  @Patch('reorder')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(UNAUTHORIZED, UNPROCESSABLE_ENTITY)
  async reorderOfferings(@Body() dto: ReorderDto): Promise<void> {
    await this.offerings.reorder(dto.ids);
  }
}
