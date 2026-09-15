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
import { ContactService } from './contact.service.js';
import { ContactLinkDto, ContactLinkInputDto } from './dto/contact-link.dto.js';

const { UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY } = HttpStatus;

@ApiTags('contact')
@Controller('contact-links')
export class ContactLinksController {
  constructor(private readonly contact: ContactService) {}

  /** Canais públicos de contato, por `position`. */
  @Public()
  @Get()
  @ApiOkResponse({ type: [ContactLinkDto] })
  @ApiErrorResponses()
  async listContactLinks(): Promise<ContactLinkDto[]> {
    return (await this.contact.listLinks()).map(ContactLinkDto.from);
  }

  /** Cria no fim. */
  @Post()
  @ApiBearerAuth()
  @ApiCreatedResponse({ type: ContactLinkDto })
  @ApiErrorResponses(UNAUTHORIZED, UNPROCESSABLE_ENTITY)
  async createContactLink(@Body() dto: ContactLinkInputDto): Promise<ContactLinkDto> {
    return ContactLinkDto.from(await this.contact.createLink(dto));
  }

  @Put(':id')
  @ApiBearerAuth()
  @ApiOkResponse({ type: ContactLinkDto })
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY)
  async updateContactLink(
    @Param('id', UuidParam) id: string,
    @Body() dto: ContactLinkInputDto,
  ): Promise<ContactLinkDto> {
    return ContactLinkDto.from(await this.contact.updateLink(id, dto));
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND)
  async deleteContactLink(@Param('id', UuidParam) id: string): Promise<void> {
    await this.contact.deleteLink(id);
  }

  /** Ordem de exibição: o conjunto completo de ids na ordem final. */
  @Patch('reorder')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(UNAUTHORIZED, UNPROCESSABLE_ENTITY)
  async reorderContactLinks(@Body() dto: ReorderDto): Promise<void> {
    await this.contact.reorderLinks(dto.ids);
  }
}
