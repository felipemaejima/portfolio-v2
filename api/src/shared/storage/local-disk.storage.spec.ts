import { mkdtemp, readFile, rm, stat } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import type { ConfigService } from '@nestjs/config';
import type { AppConfig } from '../config/config.schema.js';
import { LocalDiskStorage } from './local-disk.storage.js';

function makeStorage(root: string) {
  const config = {
    get: (key: string) =>
      ({ UPLOADS_DIR: root, PUBLIC_UPLOADS_BASE_URL: 'http://localhost/uploads/' })[key],
  } as unknown as ConfigService<AppConfig, true>;
  return new LocalDiskStorage(config);
}

describe('LocalDiskStorage', () => {
  let root: string;
  beforeEach(async () => {
    root = await mkdtemp(path.join(tmpdir(), 'uploads-'));
  });
  afterEach(async () => {
    await rm(root, { recursive: true, force: true });
  });

  it('grava sob o prefixo com chave uuid.ext e devolve URL pública', async () => {
    const storage = makeStorage(root);
    const stored = await storage.put({ buffer: Buffer.from('png!'), mime: 'image/png' }, 'profile');

    expect(stored.key).toMatch(/^profile\/[0-9a-f-]{36}\.png$/);
    expect(stored.url).toBe(`http://localhost/uploads/${stored.key}`);
    expect(await readFile(path.join(root, stored.key), 'utf8')).toBe('png!');
  });

  it('delete é idempotente', async () => {
    const storage = makeStorage(root);
    const stored = await storage.put({ buffer: Buffer.from('x'), mime: 'image/jpeg' }, 'p');
    await storage.delete(stored.key);
    await expect(stat(path.join(root, stored.key))).rejects.toThrow();
    await expect(storage.delete(stored.key)).resolves.toBeUndefined();
  });

  it('rejeita chave que escapa do diretório raiz', async () => {
    const storage = makeStorage(root);
    await expect(storage.delete('../../etc/passwd')).rejects.toThrow(/inválida/);
  });
});
