import { slugify, uniqueSlug } from './slug.js';

describe('slugify', () => {
  it('remove acentos, pontuação e espaços', () => {
    expect(slugify('  Meu Projeto Ágil! (v2) ')).toBe('meu-projeto-agil-v2');
    expect(slugify('API — Portfólio')).toBe('api-portfolio');
  });
  it('nunca devolve vazio', () => {
    expect(slugify('!!!')).toBe('item');
  });
});

describe('uniqueSlug', () => {
  it('acrescenta sufixo numérico até achar um livre', async () => {
    const taken = new Set(['app', 'app-2']);
    expect(await uniqueSlug('app', async (s) => taken.has(s))).toBe('app-3');
    expect(await uniqueSlug('novo', async (s) => taken.has(s))).toBe('novo');
  });
});
