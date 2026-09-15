import { JPEG_STUB, PNG_1X1 } from '../../../test/fixtures/images.js';
import { InMemoryFileStorage } from '../../../test/in-memory/in-memory-file.storage.js';
import { InMemoryProjectRepository } from '../../../test/in-memory/in-memory-project.repository.js';
import {
  NotFoundError,
  UnsupportedMediaTypeError,
  ValidationError,
} from '../../shared/http/errors/domain.errors.js';
import { MAX_IMAGES_PER_PROJECT, ProjectsService } from './projects.service.js';

const DATA = {
  name: 'Portfolio API',
  shortDescription: 'curta',
  fullDescription: 'longa',
  technologies: ['NestJS'],
  codeUrl: null,
  demoUrl: null,
};

function make() {
  const repo = new InMemoryProjectRepository();
  const storage = new InMemoryFileStorage();
  return { repo, storage, service: new ProjectsService(repo, storage) };
}

describe('ProjectsService', () => {
  it('create deriva o slug, garante unicidade com sufixo e entra no fim', async () => {
    const { service } = make();
    const a = await service.create(DATA);
    const b = await service.create({ ...DATA, name: 'Portfólio API!' });
    const c = await service.create(DATA);
    expect([a.slug, b.slug, c.slug]).toEqual([
      'portfolio-api',
      'portfolio-api-2',
      'portfolio-api-3',
    ]);
    expect([a.position, b.position, c.position]).toEqual([0, 1, 2]);
  });

  it('update não altera o slug mesmo mudando o nome', async () => {
    const { service } = make();
    const created = await service.create(DATA);
    const updated = await service.update(created.id, { ...DATA, name: 'Outro Nome' });
    expect(updated.name).toBe('Outro Nome');
    expect(updated.slug).toBe('portfolio-api');
  });

  it('getBySlug / update / remove de inexistente → NotFoundError', async () => {
    const { service } = make();
    await expect(service.getBySlug('nada')).rejects.toBeInstanceOf(NotFoundError);
    await expect(service.update('x', DATA)).rejects.toBeInstanceOf(NotFoundError);
    await expect(service.remove('x')).rejects.toBeInstanceOf(NotFoundError);
  });

  it('reorder exige o conjunto exato; aplica a ordem', async () => {
    const { service } = make();
    const a = await service.create(DATA);
    const b = await service.create(DATA);
    await expect(service.reorder([a.id])).rejects.toBeInstanceOf(ValidationError);
    await expect(service.reorder([a.id, b.id, 'z'])).rejects.toBeInstanceOf(ValidationError);
    await service.reorder([b.id, a.id]);
    expect((await service.list()).map((p) => p.id)).toEqual([b.id, a.id]);
  });

  describe('galeria', () => {
    it('addImages grava sob projects/<id>, entra no fim e a view resolve URLs', async () => {
      const { service, storage } = make();
      const p = await service.create(DATA);
      const withOne = await service.addImages(p.id, [PNG_1X1]);
      const withThree = await service.addImages(p.id, [JPEG_STUB, PNG_1X1]);
      expect(withOne.images).toHaveLength(1);
      expect(withThree.images.map((i) => i.position)).toEqual([0, 1, 2]);
      expect(withThree.images[1]!.url).toMatch(new RegExp(`^memory://projects/${p.id}/.+\\.jpg$`));
      expect(storage.files.size).toBe(3);
    });

    it('limite de 12 é cumulativo → ValidationError em `files`, sem gravar', async () => {
      const { service, storage } = make();
      const p = await service.create(DATA);
      await service.addImages(p.id, Array(MAX_IMAGES_PER_PROJECT - 1).fill(PNG_1X1));
      await expect(service.addImages(p.id, [PNG_1X1, PNG_1X1])).rejects.toSatisfy((e: unknown) => {
        expect(e).toBeInstanceOf(ValidationError);
        expect((e as ValidationError).details['files']?.[0]).toMatch(/12/);
        return true;
      });
      expect(storage.files.size).toBe(MAX_IMAGES_PER_PROJECT - 1);
    });

    it('um arquivo inválido no lote rejeita o lote inteiro antes de gravar', async () => {
      const { service, storage } = make();
      const p = await service.create(DATA);
      await expect(service.addImages(p.id, [PNG_1X1, Buffer.from('txt')])).rejects.toBeInstanceOf(
        UnsupportedMediaTypeError,
      );
      expect(storage.files.size).toBe(0);
    });

    it('falha ao persistir remove os arquivos recém-gravados', async () => {
      const { service, storage, repo } = make();
      const p = await service.create(DATA);
      repo.failNextAddImages = true;
      await expect(service.addImages(p.id, [PNG_1X1, PNG_1X1])).rejects.toThrow(
        'banco indisponível',
      );
      expect(storage.files.size).toBe(0);
    });

    it('removeImage apaga linha e arquivo; imagem de outro projeto → NotFound', async () => {
      const { service, storage } = make();
      const a = await service.addImages((await service.create(DATA)).id, [PNG_1X1]);
      const b = await service.create(DATA);
      await expect(service.removeImage(b.id, a.images[0]!.id)).rejects.toBeInstanceOf(
        NotFoundError,
      );
      await service.removeImage(a.id, a.images[0]!.id);
      expect(storage.files.size).toBe(0);
    });

    it('reorderImages valida o conjunto do próprio projeto', async () => {
      const { service } = make();
      const p = await service.addImages((await service.create(DATA)).id, [PNG_1X1, PNG_1X1]);
      const [x, y] = p.images.map((i) => i.id);
      await expect(service.reorderImages(p.id, [x!])).rejects.toBeInstanceOf(ValidationError);
      await service.reorderImages(p.id, [y!, x!]);
      expect((await service.getBySlug(p.slug)).images.map((i) => i.id)).toEqual([y, x]);
    });

    it('remove apaga os arquivos da galeria', async () => {
      const { service, storage } = make();
      const p = await service.addImages((await service.create(DATA)).id, [PNG_1X1, JPEG_STUB]);
      await service.remove(p.id);
      expect(storage.files.size).toBe(0);
      await expect(service.getBySlug(p.slug)).rejects.toBeInstanceOf(NotFoundError);
    });
  });
});
