import { randomUUID } from 'node:crypto';
import type { Profile } from '../../src/generated/prisma/client.js';
import {
  ProfileRepository,
  type UpdateProfileData,
} from '../../src/modules/profile/ports/profile.repository.js';

export class InMemoryProfileRepository extends ProfileRepository {
  profile: Profile = {
    id: randomUUID(),
    key: 'default',
    name: '',
    headline: '',
    summary: '',
    description: '',
    contactIntro: null,
    city: '',
    state: '',
    country: '',
    availability: [],
    workModes: [],
    languages: [],
    imageKey: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  };
  failNextSetImageKey = false;

  async get(): Promise<Profile> {
    return this.profile;
  }

  async update(data: UpdateProfileData): Promise<Profile> {
    this.profile = { ...this.profile, ...data, updatedAt: new Date() };
    return this.profile;
  }

  async setImageKey(imageKey: string | null): Promise<Profile> {
    if (this.failNextSetImageKey) {
      this.failNextSetImageKey = false;
      throw new Error('banco indisponível');
    }
    this.profile = { ...this.profile, imageKey, updatedAt: new Date() };
    return this.profile;
  }
}
