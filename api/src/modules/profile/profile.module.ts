import { Module } from '@nestjs/common';
import { PrismaProfileRepository } from './adapters/prisma-profile.repository.js';
import { ProfileRepository } from './ports/profile.repository.js';
import { ProfileController } from './profile.controller.js';
import { ProfileService } from './profile.service.js';

@Module({
  controllers: [ProfileController],
  providers: [ProfileService, { provide: ProfileRepository, useClass: PrismaProfileRepository }],
  exports: [ProfileService],
})
export class ProfileModule {}
