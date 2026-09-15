import { JPEG_STUB, PNG_1X1 } from '../../../test/fixtures/images.js';
import { InMemoryFileStorage } from '../../../test/in-memory/in-memory-file.storage.js';
import { InMemoryProfileRepository } from '../../../test/in-memory/in-memory-profile.repository.js';
import { Availability, LanguageLevel, WorkMode } from '../../shared/domain/enums.js';
import { UnsupportedMediaTypeError } from '../../shared/http/errors/domain.errors.js';
import { parseLanguages, ProfileService } from './profile.service.js';

function make() {
  const repo = new InMemoryProfileRepository();
  const storage = new InMemoryFileStorage();
  return { repo, storage, service: new ProfileService(repo, storage) };
}

describe('ProfileService', () => {
  it('get devolve o singleton com imageUrl null e languages tipado', async () => {
    const { service } = make();
    const view = await service.get();
    expect(view.imageUrl).toBeNull();
    expect(view.languages).toEqual([]);
  });

  it('update substitui os campos e preserva a imagem', async () => {
    const { service, repo } = make();
    repo.profile.imageKey = 'profile/old.png';
    const view = await service.update({
      name: 'Nome',
      headline: 'Dev',
      summary: 's',
      description: 'd',
      city: 'SP',
      state: 'SP',
      country: 'BR',
      availability: [Availability.CLT],
      workModes: [WorkMode.REMOTE, WorkMode.HYBRID],
      languages: [{ language: 'Inglês', level: LanguageLevel.FLUENT }],
    });
    expect(view.name).toBe('Nome');
    expect(view.languages).toEqual([{ language: 'Inglês', level: 'FLUENT' }]);
    expect(view.imageUrl).toBe('memory://profile/old.png');
  });

  describe('updateImage', () => {
    it('grava, aponta o profile e apaga a imagem anterior', async () => {
      const { service, storage } = make();
      const first = await service.updateImage(PNG_1X1);
      expect(first.imageUrl).toMatch(/^memory:\/\/profile\/.+\.png$/);
      expect(storage.files.size).toBe(1);

      const second = await service.updateImage(JPEG_STUB);
      expect(second.imageUrl).toMatch(/\.jpg$/);
      expect(second.imageUrl).not.toBe(first.imageUrl);
      expect(storage.files.size).toBe(1); // a antiga foi embora
    });

    it('tipo não aceito → UnsupportedMediaTypeError e nada é gravado', async () => {
      const { service, storage, repo } = make();
      await expect(service.updateImage(Buffer.from('texto'))).rejects.toBeInstanceOf(
        UnsupportedMediaTypeError,
      );
      expect(storage.files.size).toBe(0);
      expect(repo.profile.imageKey).toBeNull();
    });

    it('se persistir falhar, o arquivo novo é removido e a antiga fica', async () => {
      const { service, storage, repo } = make();
      await service.updateImage(PNG_1X1);
      const [oldKey] = storage.files.keys();

      repo.failNextSetImageKey = true;
      await expect(service.updateImage(JPEG_STUB)).rejects.toThrow('banco indisponível');
      expect([...storage.files.keys()]).toEqual([oldKey]);
      expect(repo.profile.imageKey).toBe(oldKey);
    });
  });

  it('deleteImage limpa a chave e apaga o arquivo; sem imagem é no-op', async () => {
    const { service, storage, repo } = make();
    await service.deleteImage();
    await service.updateImage(PNG_1X1);
    await service.deleteImage();
    expect(repo.profile.imageKey).toBeNull();
    expect(storage.files.size).toBe(0);
  });
});

describe('parseLanguages', () => {
  it('descarta itens malformados e níveis desconhecidos', () => {
    expect(
      parseLanguages([
        { language: 'Inglês', level: 'FLUENT' },
        { language: 'X', level: 'JEDI' },
        'lixo',
        null,
        { language: 42, level: 'BASIC' },
      ]),
    ).toEqual([{ language: 'Inglês', level: 'FLUENT' }]);
    expect(parseLanguages('nada')).toEqual([]);
  });
});
