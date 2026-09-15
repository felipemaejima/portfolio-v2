import type { Education, Experience } from '../../generated/prisma/client.js';
import { Availability, LanguageLevel, WorkMode } from '../../shared/domain/enums.js';
import type { ContactLink, Offering } from '../../generated/prisma/client.js';
import type { ProfileView } from '../profile/profile.service.js';
import type { SkillCategoryWithSkills } from '../skills/ports/skill-category.repository.js';

/**
 * Modelo de dados do CV, já em texto de apresentação (PT-BR). É a única
 * fronteira da API onde rótulos em PT existem: o PDF é apresentação.
 * Não depende do pdfmake — o renderer é quem conhece a biblioteca.
 */
export interface CvDocument {
  name: string;
  headline: string;
  summary: string;
  description: string;
  location: string;
  availability: string[];
  workModes: string[];
  languages: string[];
  contacts: { label: string; value: string }[];
  experiences: { role: string; companyName: string; period: string; activities: string[] }[];
  educations: { courseName: string; institution: string; period: string }[];
  skills: { category: string; items: string[] }[];
  offerings: { title: string; description: string }[];
}

export interface CvSources {
  profile: ProfileView;
  contacts: ContactLink[];
  experiences: Experience[];
  educations: Education[];
  skillCategories: SkillCategoryWithSkills[];
  offerings: Offering[];
}

export const AVAILABILITY_LABEL: Record<Availability, string> = {
  [Availability.CLT]: 'CLT',
  [Availability.PJ]: 'PJ',
  [Availability.FREELANCE]: 'Freelance',
  [Availability.CONTRACT]: 'Contrato',
};

export const WORK_MODE_LABEL: Record<WorkMode, string> = {
  [WorkMode.REMOTE]: 'Remoto',
  [WorkMode.HYBRID]: 'Híbrido',
  [WorkMode.ON_SITE]: 'Presencial',
};

export const LANGUAGE_LEVEL_LABEL: Record<LanguageLevel, string> = {
  [LanguageLevel.BASIC]: 'Básico',
  [LanguageLevel.INTERMEDIATE]: 'Intermediário',
  [LanguageLevel.ADVANCED]: 'Avançado',
  [LanguageLevel.FLUENT]: 'Fluente',
  [LanguageLevel.NATIVE]: 'Nativo',
};

const MONTHS = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];
const CURRENT = 'atual';
const DASH = ' — ';

/** `2023-01` → `jan/2023`. */
export function formatYearMonth(value: string): string {
  const [year, month] = value.split('-');
  return `${MONTHS[Number(month) - 1] ?? month}/${year}`;
}

/** `jan/2023 — atual`, `mar/2021 — dez/2022`. */
export function formatExperiencePeriod(startDate: string, endDate: string | null): string {
  return `${formatYearMonth(startDate)}${DASH}${endDate ? formatYearMonth(endDate) : CURRENT}`;
}

/** `2017 — 2021`, `2024 — atual`, ou só `2023` quando início = fim. */
export function formatEducationPeriod(startYear: number, endYear: number | null): string {
  if (endYear === null) return `${startYear}${DASH}${CURRENT}`;
  if (endYear === startYear) return `${startYear}`;
  return `${startYear}${DASH}${endYear}`;
}

export function buildCvDocument(s: CvSources): CvDocument {
  const { profile } = s;
  return {
    name: profile.name,
    headline: profile.headline,
    summary: profile.summary,
    description: profile.description,
    location: [profile.city, profile.state, profile.country].filter(Boolean).join(', '),
    availability: profile.availability.map((a) => AVAILABILITY_LABEL[a]),
    workModes: profile.workModes.map((w) => WORK_MODE_LABEL[w]),
    languages: profile.languages.map((l) => `${l.language} (${LANGUAGE_LEVEL_LABEL[l.level]})`),
    contacts: s.contacts.map(({ label, value }) => ({ label, value })),
    experiences: s.experiences.map((e) => ({
      role: e.role,
      companyName: e.companyName,
      period: formatExperiencePeriod(e.startDate, e.endDate),
      activities: e.activities,
    })),
    educations: s.educations.map((e) => ({
      courseName: e.courseName,
      institution: e.institution,
      period: formatEducationPeriod(e.startYear, e.endYear),
    })),
    skills: s.skillCategories
      .filter((c) => c.skills.length > 0)
      .map((c) => ({ category: c.name, items: c.skills.map((sk) => sk.name) })),
    offerings: s.offerings.map(({ title, description }) => ({ title, description })),
  };
}
