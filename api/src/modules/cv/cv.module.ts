import { Module } from '@nestjs/common';
import { ContactModule } from '../contact/contact.module.js';
import { EducationsModule } from '../educations/educations.module.js';
import { ExperiencesModule } from '../experiences/experiences.module.js';
import { OfferingsModule } from '../offerings/offerings.module.js';
import { ProfileModule } from '../profile/profile.module.js';
import { SkillsModule } from '../skills/skills.module.js';
import { PdfmakeCvRenderer } from './adapters/pdfmake-cv.renderer.js';
import { CvController } from './cv.controller.js';
import { CvService } from './cv.service.js';
import { CvRenderer } from './ports/cv-renderer.js';

/** Depende de todos os módulos de conteúdo: é o último (API.md §6, fase 9). */
@Module({
  imports: [
    ProfileModule,
    ContactModule,
    ExperiencesModule,
    EducationsModule,
    SkillsModule,
    OfferingsModule,
  ],
  controllers: [CvController],
  providers: [CvService, { provide: CvRenderer, useClass: PdfmakeCvRenderer }],
})
export class CvModule {}
