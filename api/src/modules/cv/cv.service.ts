import { Injectable } from '@nestjs/common';
import { slugify } from '../../shared/domain/slug.js';
import { ContactService } from '../contact/contact.service.js';
import { EducationsService } from '../educations/educations.service.js';
import { ExperiencesService } from '../experiences/experiences.service.js';
import { OfferingsService } from '../offerings/offerings.service.js';
import { ProfileService } from '../profile/profile.service.js';
import { SkillsService } from '../skills/skills.service.js';
import { buildCvDocument, type CvDocument } from './cv-document.js';
import { CvRenderer } from './ports/cv-renderer.js';

export interface RenderedCv {
  filename: string;
  pdf: Buffer;
}

/** Monta o CV sob demanda a partir do estado atual (GLOBAL.md AD-11). Nada é armazenado. */
@Injectable()
export class CvService {
  constructor(
    private readonly renderer: CvRenderer,
    private readonly profile: ProfileService,
    private readonly contact: ContactService,
    private readonly experiences: ExperiencesService,
    private readonly educations: EducationsService,
    private readonly skills: SkillsService,
    private readonly offerings: OfferingsService,
  ) {}

  async document(): Promise<CvDocument> {
    const [profile, contacts, experiences, educations, skillCategories, offerings] =
      await Promise.all([
        this.profile.get(),
        this.contact.listLinks(),
        this.experiences.list(),
        this.educations.list(),
        this.skills.listCategories(),
        this.offerings.list(),
      ]);
    return buildCvDocument({
      profile,
      contacts,
      experiences,
      educations,
      skillCategories,
      offerings,
    });
  }

  async render(): Promise<RenderedCv> {
    const doc = await this.document();
    return {
      filename: `cv-${slugify(doc.name || 'portfolio')}.pdf`,
      pdf: await this.renderer.render(doc),
    };
  }
}
