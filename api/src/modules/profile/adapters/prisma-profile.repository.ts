import { Injectable } from '@nestjs/common';
import type { Profile } from '../../../generated/prisma/client.js';
import { PrismaService } from '../../../shared/prisma/prisma.service.js';
import { ProfileRepository, type UpdateProfileData } from '../ports/profile.repository.js';

const KEY = 'default';

@Injectable()
export class PrismaProfileRepository extends ProfileRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  get(): Promise<Profile> {
    return this.prisma.profile.upsert({ where: { key: KEY }, update: {}, create: {} });
  }

  async update(data: UpdateProfileData): Promise<Profile> {
    await this.get();
    return this.prisma.profile.update({ where: { key: KEY }, data });
  }

  async setImageKey(imageKey: string | null): Promise<Profile> {
    await this.get();
    return this.prisma.profile.update({ where: { key: KEY }, data: { imageKey } });
  }
}
