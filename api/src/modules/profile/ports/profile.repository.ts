import type { Profile } from '../../../generated/prisma/client.js';
import type { Availability, LanguageLevel, WorkMode } from '../../../shared/domain/enums.js';

/** `type` (não `interface`): precisa da index signature implícita para virar Json no Prisma. */
export type ProfileLanguage = {
  language: string;
  level: LanguageLevel;
};

export interface UpdateProfileData {
  name: string;
  headline: string;
  summary: string;
  description: string;
  contactIntro: string | null;
  city: string;
  state: string;
  country: string;
  availability: Availability[];
  workModes: WorkMode[];
  languages: ProfileLanguage[];
}

export abstract class ProfileRepository {
  /** O singleton; cria a linha vazia se o seed ainda não rodou. */
  abstract get(): Promise<Profile>;
  abstract update(data: UpdateProfileData): Promise<Profile>;
  abstract setImageKey(imageKey: string | null): Promise<Profile>;
}
