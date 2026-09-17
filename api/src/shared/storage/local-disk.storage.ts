import { randomUUID } from 'node:crypto';
import { mkdir, rm, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfig } from '../config/config.schema.js';
import { FileStorage, type FileToStore, type StoredFile } from './file-storage.js';
import { IMAGE_EXTENSIONS } from './image-type.js';

/** Prefixo público servido pelo Caddy (INFRA.md). Constante de contrato. */
export const UPLOADS_PUBLIC_PATH = '/uploads';

/**
 * Disco local (ADR 0003): grava em UPLOADS_DIR e devolve o caminho público
 * `/uploads/<key>`, relativo à origem — o mesmo caminho vale para o browser
 * em localhost, o celular na rede local e o domínio hospedado. Quem serve os
 * bytes é a borda (Caddy).
 */
@Injectable()
export class LocalDiskStorage extends FileStorage {
  private readonly root: string;

  constructor(config: ConfigService<AppConfig, true>) {
    super();
    this.root = config.get('UPLOADS_DIR', { infer: true });
  }

  async put(file: FileToStore, keyPrefix: string): Promise<StoredFile> {
    const ext = IMAGE_EXTENSIONS[file.mime] ?? 'bin';
    const key = `${keyPrefix}/${randomUUID()}.${ext}`;
    const target = this.pathFor(key);
    await mkdir(path.dirname(target), { recursive: true });
    await writeFile(target, file.buffer, { flag: 'wx' }); // chave nova, nunca sobrescreve
    return { key, url: this.urlFor(key) };
  }

  async delete(key: string): Promise<void> {
    await rm(this.pathFor(key), { force: true });
  }

  urlFor(key: string): string {
    return `${UPLOADS_PUBLIC_PATH}/${key}`;
  }

  private pathFor(key: string): string {
    const resolved = path.resolve(this.root, key);
    if (!resolved.startsWith(`${path.resolve(this.root)}${path.sep}`)) {
      throw new Error(`chave de storage inválida: ${key}`);
    }
    return resolved;
  }
}
