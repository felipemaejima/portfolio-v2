import { randomUUID } from 'node:crypto';
import { Availability, LanguageLevel, WorkMode } from '../../shared/domain/enums.js';
import {
  buildCvDocument,
  type CvSources,
  formatEducationPeriod,
  formatExperiencePeriod,
} from './cv-document.js';

const now = new Date();
const stamps = { createdAt: now, updatedAt: now };

export function sampleSources(): CvSources {
  return {
    profile: {
      id: randomUUID(),
      key: 'default',
      name: 'Nome Sobrenome',
      headline: 'Dev',
      summary: 'Resumo.',
      description: 'Parágrafo 1.\n\nParágrafo 2.',
      contactIntro: null,
      city: 'São Paulo',
      state: 'SP',
      country: 'Brasil',
      availability: [Availability.CLT, Availability.FREELANCE],
      workModes: [WorkMode.REMOTE],
      languages: [{ language: 'Inglês', level: LanguageLevel.FLUENT }],
      imageKey: null,
      imageUrl: null,
      ...stamps,
    },
    contacts: [
      {
        id: randomUUID(),
        label: 'E-mail',
        value: 'x@x.com',
        url: 'mailto:x@x.com',
        position: 0,
        ...stamps,
      },
    ],
    experiences: [
      {
        id: randomUUID(),
        role: 'Dev',
        companyName: 'Empresa',
        activities: ['A', 'B'],
        startDate: '2023-01',
        endDate: null,
        ...stamps,
      },
      {
        id: randomUUID(),
        role: 'Jr',
        companyName: 'Antiga',
        activities: [],
        startDate: '2021-03',
        endDate: '2022-12',
        ...stamps,
      },
    ],
    educations: [
      {
        id: randomUUID(),
        courseName: 'BCC',
        institution: 'Uni',
        startYear: 2017,
        endYear: 2021,
        ...stamps,
      },
      {
        id: randomUUID(),
        courseName: 'Cert',
        institution: 'AWS',
        startYear: 2023,
        endYear: 2023,
        ...stamps,
      },
    ],
    skillCategories: [
      {
        id: randomUUID(),
        name: 'Linguagens',
        position: 0,
        ...stamps,
        skills: [{ id: randomUUID(), categoryId: 'c', name: 'TS', position: 0, ...stamps }],
      },
      { id: randomUUID(), name: 'Vazia', position: 1, ...stamps, skills: [] },
    ],
    offerings: [{ id: randomUUID(), title: 'Web', description: 'Sites.', position: 0, ...stamps }],
  };
}

describe('períodos', () => {
  it('experiência: mês abreviado em PT e "atual"', () => {
    expect(formatExperiencePeriod('2023-01', null)).toBe('jan/2023 — atual');
    expect(formatExperiencePeriod('2021-03', '2022-12')).toBe('mar/2021 — dez/2022');
  });
  it('formação: intervalo, em andamento e ano único', () => {
    expect(formatEducationPeriod(2017, 2021)).toBe('2017 — 2021');
    expect(formatEducationPeriod(2024, null)).toBe('2024 — atual');
    expect(formatEducationPeriod(2023, 2023)).toBe('2023');
  });
});

describe('buildCvDocument', () => {
  it('traduz enums para PT, monta localização e ignora categorias vazias', () => {
    const doc = buildCvDocument(sampleSources());
    expect(doc.location).toBe('São Paulo, SP, Brasil');
    expect(doc.availability).toEqual(['CLT', 'Freelance']);
    expect(doc.workModes).toEqual(['Remoto']);
    expect(doc.languages).toEqual(['Inglês (Fluente)']);
    expect(doc.contacts).toEqual([{ label: 'E-mail', value: 'x@x.com' }]);
    expect(doc.experiences[0]).toMatchObject({
      period: 'jan/2023 — atual',
      activities: ['A', 'B'],
    });
    expect(doc.educations.map((e) => e.period)).toEqual(['2017 — 2021', '2023']);
    expect(doc.skills).toEqual([{ category: 'Linguagens', items: ['TS'] }]);
    expect(doc.offerings).toEqual([{ title: 'Web', description: 'Sites.' }]);
  });
});
