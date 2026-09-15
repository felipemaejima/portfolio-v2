import { Module } from '@nestjs/common';
import { PrismaContactLinkRepository } from './adapters/prisma-contact-link.repository.js';
import { PrismaContactMessageRepository } from './adapters/prisma-contact-message.repository.js';
import { ContactLinksController } from './contact-links.controller.js';
import { ContactMessagesController } from './contact-messages.controller.js';
import { ContactService } from './contact.service.js';
import { ContactLinkRepository } from './ports/contact-link.repository.js';
import { ContactMessageRepository } from './ports/contact-message.repository.js';

@Module({
  controllers: [ContactLinksController, ContactMessagesController],
  providers: [
    ContactService,
    { provide: ContactLinkRepository, useClass: PrismaContactLinkRepository },
    { provide: ContactMessageRepository, useClass: PrismaContactMessageRepository },
  ],
})
export class ContactModule {}
