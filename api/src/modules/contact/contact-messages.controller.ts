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
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { Public } from '../../shared/auth/public.decorator.js';
import { ApiErrorResponses } from '../../shared/http/decorators/api-error-responses.decorator.js';
import { UuidParam } from '../../shared/http/pipes/uuid-param.pipe.js';
import { THROTTLE_CONTACT_LIMIT, THROTTLE_TTL_MS } from '../../shared/http/throttle.js';
import { ContactService } from './contact.service.js';
import { ContactMessageDto, CreateContactMessageDto } from './dto/contact-message.dto.js';

const { UNAUTHORIZED, NOT_FOUND, UNPROCESSABLE_ENTITY, TOO_MANY_REQUESTS } = HttpStatus;

@ApiTags('contact')
@Controller('contact-messages')
export class ContactMessagesController {
  constructor(private readonly contact: ContactService) {}

  /** Visitor envia uma mensagem. Só persiste; sem corpo de resposta. 3/min por IP. */
  @Public()
  @Throttle({ default: { limit: THROTTLE_CONTACT_LIMIT, ttl: THROTTLE_TTL_MS } })
  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiCreatedResponse()
  @ApiErrorResponses(UNPROCESSABLE_ENTITY, TOO_MANY_REQUESTS)
  async sendContactMessage(@Body() dto: CreateContactMessageDto): Promise<void> {
    await this.contact.receiveMessage(dto);
  }

  /** Inbox do Admin, mais recentes primeiro. */
  @Get()
  @ApiBearerAuth()
  @ApiOkResponse({ type: [ContactMessageDto] })
  @ApiErrorResponses(UNAUTHORIZED)
  async listContactMessages(): Promise<ContactMessageDto[]> {
    return (await this.contact.listMessages()).map(ContactMessageDto.from);
  }

  /** Marca como lida (idempotente). */
  @Patch(':id/read')
  @ApiBearerAuth()
  @ApiOkResponse({ type: ContactMessageDto })
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND)
  async markContactMessageRead(@Param('id', UuidParam) id: string): Promise<ContactMessageDto> {
    return ContactMessageDto.from(await this.contact.markRead(id));
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBearerAuth()
  @ApiNoContentResponse()
  @ApiErrorResponses(UNAUTHORIZED, NOT_FOUND)
  async deleteContactMessage(@Param('id', UuidParam) id: string): Promise<void> {
    await this.contact.deleteMessage(id);
  }
}
