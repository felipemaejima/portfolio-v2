import { createRequire } from 'node:module';
import path from 'node:path';
import { Injectable } from '@nestjs/common';
import pdfmake from 'pdfmake';
import type { Content } from 'pdfmake';
import type { CvDocument } from '../cv-document.js';
import { CvRenderer } from '../ports/cv-renderer.js';

/** Roboto vem dentro do pacote pdfmake: nada de TTF no repositório. */
function robotoFonts() {
  const require = createRequire(import.meta.url);
  const dir = path.join(path.dirname(require.resolve('pdfmake/package.json')), 'fonts', 'Roboto');
  return {
    Roboto: {
      normal: path.join(dir, 'Roboto-Regular.ttf'),
      bold: path.join(dir, 'Roboto-Medium.ttf'),
      italics: path.join(dir, 'Roboto-Italic.ttf'),
      bolditalics: path.join(dir, 'Roboto-MediumItalic.ttf'),
    },
  };
}

/** @types/pdfmake não expõe o subpath `interfaces` sob nodenext; inferimos do próprio createPdf. */
type TDocumentDefinitions = Parameters<typeof pdfmake.createPdf>[0];

const MUTED = '#555555';

/** Uma coluna, seções na ordem de GLOBAL.md (CV). Layout programático, sem HTML. */
@Injectable()
export class PdfmakeCvRenderer extends CvRenderer {
  constructor() {
    super();
    pdfmake.setFonts(robotoFonts());
  }

  async render(doc: CvDocument): Promise<Buffer> {
    return pdfmake.createPdf(this.definition(doc)).getBuffer();
  }

  private definition(doc: CvDocument): TDocumentDefinitions {
    const content: Content[] = [
      { text: doc.name, style: 'name' },
      ...(doc.headline ? [{ text: doc.headline, style: 'headline' } as Content] : []),
      {
        text: [doc.location, ...doc.contacts.map((c) => `${c.label}: ${c.value}`)]
          .filter(Boolean)
          .join('  ·  '),
        style: 'muted',
        margin: [0, 2, 0, 10],
      },
    ];

    if (doc.summary) content.push({ text: doc.summary, margin: [0, 0, 0, 6] });
    if (doc.description) {
      content.push(
        ...doc.description
          .split(/\n\s*\n/)
          .map((p) => ({ text: p.trim(), margin: [0, 0, 0, 4] }) as Content),
      );
    }

    const facts = [
      doc.availability.length ? `Disponibilidade: ${doc.availability.join(', ')}` : '',
      doc.workModes.length ? `Modalidade: ${doc.workModes.join(', ')}` : '',
      doc.languages.length ? `Idiomas: ${doc.languages.join(', ')}` : '',
    ].filter(Boolean);
    if (facts.length)
      content.push({ text: facts.join('   ·   '), style: 'muted', margin: [0, 4, 0, 0] });

    if (doc.experiences.length) {
      content.push({ text: 'Experiência profissional', style: 'section' });
      for (const e of doc.experiences) {
        content.push(
          { text: [{ text: e.role, bold: true }, { text: `  ·  ${e.companyName}` }] },
          { text: e.period, style: 'muted' },
          ...(e.activities.length ? [{ ul: e.activities, margin: [0, 2, 0, 6] } as Content] : []),
        );
      }
    }

    if (doc.educations.length) {
      content.push({ text: 'Formação', style: 'section' });
      for (const e of doc.educations) {
        content.push(
          { text: [{ text: e.courseName, bold: true }, { text: `  ·  ${e.institution}` }] },
          { text: e.period, style: 'muted', margin: [0, 0, 0, 4] },
        );
      }
    }

    if (doc.skills.length) {
      content.push({ text: 'Habilidades', style: 'section' });
      for (const s of doc.skills) {
        content.push({
          text: [{ text: `${s.category}: `, bold: true }, { text: s.items.join(', ') }],
          margin: [0, 0, 0, 2],
        });
      }
    }

    if (doc.offerings.length) {
      content.push({ text: 'Serviços', style: 'section' });
      for (const o of doc.offerings) {
        content.push({
          text: [{ text: `${o.title}: `, bold: true }, { text: o.description }],
          margin: [0, 0, 0, 2],
        });
      }
    }

    return {
      info: { title: `CV — ${doc.name}`, author: doc.name },
      pageSize: 'A4',
      pageMargins: [48, 48, 48, 48],
      defaultStyle: { font: 'Roboto', fontSize: 10, lineHeight: 1.25 },
      styles: {
        name: { fontSize: 20, bold: true },
        headline: { fontSize: 12, color: MUTED },
        section: { fontSize: 13, bold: true, margin: [0, 14, 0, 6] },
        muted: { color: MUTED, fontSize: 9 },
      },
      content,
    };
  }
}
