import { Module } from '@nestjs/common';
import { PrismaOfferingRepository } from './adapters/prisma-offering.repository.js';
import { OfferingsController } from './offerings.controller.js';
import { OfferingsService } from './offerings.service.js';
import { OfferingRepository } from './ports/offering.repository.js';

@Module({
  controllers: [OfferingsController],
  providers: [
    OfferingsService,
    { provide: OfferingRepository, useClass: PrismaOfferingRepository },
  ],
  exports: [OfferingsService],
})
export class OfferingsModule {}
