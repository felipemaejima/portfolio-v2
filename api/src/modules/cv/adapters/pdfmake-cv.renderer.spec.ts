import { buildCvDocument } from '../cv-document.js';
import { sampleSources } from '../cv-document.spec.js';
import { PdfmakeCvRenderer } from './pdfmake-cv.renderer.js';

describe('PdfmakeCvRenderer', () => {
  it('gera um PDF válido com os dados completos', async () => {
    const pdf = await new PdfmakeCvRenderer().render(buildCvDocument(sampleSources()));
    expect(pdf.subarray(0, 5).toString()).toBe('%PDF-');
    expect(pdf.length).toBeGreaterThan(1000);
  });

  it('gera um PDF mesmo com tudo vazio (portfólio recém-criado)', async () => {
    const sources = sampleSources();
    sources.profile = {
      ...sources.profile,
      name: '',
      headline: '',
      summary: '',
      description: '',
      city: '',
      state: '',
      country: '',
      availability: [],
      workModes: [],
      languages: [],
    };
    sources.contacts = [];
    sources.experiences = [];
    sources.educations = [];
    sources.skillCategories = [];
    sources.offerings = [];
    const pdf = await new PdfmakeCvRenderer().render(buildCvDocument(sources));
    expect(pdf.subarray(0, 5).toString()).toBe('%PDF-');
  });
});
