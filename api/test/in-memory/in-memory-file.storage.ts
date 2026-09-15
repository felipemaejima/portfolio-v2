import { randomUUID } from 'node:crypto';
import {
  FileStorage,
  type FileToStore,
  type StoredFile,
} from '../../src/shared/storage/file-storage.js';
import { IMAGE_EXTENSIONS } from '../../src/shared/storage/image-type.js';

export class InMemoryFileStorage extends FileStorage {
  readonly files = new Map<string, FileToStore>();

  async put(file: FileToStore, keyPrefix: string): Promise<StoredFile> {
    const key = `${keyPrefix}/${randomUUID()}.${IMAGE_EXTENSIONS[file.mime] ?? 'bin'}`;
    this.files.set(key, file);
    return { key, url: this.urlFor(key) };
  }

  async delete(key: string): Promise<void> {
    this.files.delete(key);
  }

  urlFor(key: string): string {
    return `memory://${key}`;
  }
}
