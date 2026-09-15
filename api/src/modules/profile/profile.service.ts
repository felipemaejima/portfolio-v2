import { Injectable } from '@nestjs/common';
import type { Profile } from '../../generated/prisma/client.js';
import { LanguageLevel } from '../../shared/domain/enums.js';
import { FileStorage } from '../../shared/storage/file-storage.js';
import { detectImage } from '../../shared/storage/image-type.js';
import {
  type ProfileLanguage,
  ProfileRepository,
  type UpdateProfileData,
} from './ports/profile.repository.js';

const IMAGE_PREFIX = 'profile';

/** Profile com a URL da imagem resolvida e `languages` tipado. */
export type ProfileView = Omit<Profile, 'languages'> & {
  languages: ProfileLanguage[];
  imageUrl: string | null;
};

@Injectable()
export class ProfileService {
  constructor(
    private readonly profiles: ProfileRepository,
    private readonly storage: FileStorage,
  ) {}

  async get(): Promise<ProfileView> {
    return this.view(await this.profiles.get());
  }

  async update(data: UpdateProfileData): Promise<ProfileView> {
    return this.view(await this.profiles.update(data));
  }

  /** Grava a imagem nova, aponta o Profile para ela e só então apaga a antiga. */
  async updateImage(buffer: Buffer): Promise<ProfileView> {
    const { mime } = await detectImage(buffer);
    const previous = (await this.profiles.get()).imageKey;
    const stored = await this.storage.put({ buffer, mime }, IMAGE_PREFIX);

    let profile: Profile;
    try {
      profile = await this.profiles.setImageKey(stored.key);
    } catch (error) {
      await this.storage.delete(stored.key); // compensação: não deixar arquivo órfão
      throw error;
    }
    if (previous) await this.storage.delete(previous);
    return this.view(profile);
  }

  async deleteImage(): Promise<void> {
    const previous = (await this.profiles.get()).imageKey;
    if (!previous) return;
    await this.profiles.setImageKey(null);
    await this.storage.delete(previous);
  }

  private view(profile: Profile): ProfileView {
    return {
      ...profile,
      languages: parseLanguages(profile.languages),
      imageUrl: profile.imageKey ? this.storage.urlFor(profile.imageKey) : null,
    };
  }
}

const LEVELS = new Set<string>(Object.values(LanguageLevel));

/** O JSON só é escrito por PUT /profile (validado), mas leitura defensiva custa pouco. */
export function parseLanguages(json: unknown): ProfileLanguage[] {
  if (!Array.isArray(json)) return [];
  return json.flatMap((item) => {
    if (typeof item !== 'object' || item === null) return [];
    const { language, level } = item as Record<string, unknown>;
    if (typeof language !== 'string' || typeof level !== 'string' || !LEVELS.has(level)) return [];
    return [{ language, level: level as LanguageLevel }];
  });
}
