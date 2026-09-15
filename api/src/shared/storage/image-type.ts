import { fileTypeFromBuffer } from 'file-type';
import { UnsupportedMediaTypeError } from '../http/errors/domain.errors.js';

/** Tipos aceitos (GLOBAL.md §8) e a extensão usada na chave do storage. */
export const IMAGE_EXTENSIONS: Readonly<Record<string, string>> = {
  'image/jpeg': 'jpg',
  'image/png': 'png',
  'image/webp': 'webp',
};

/** Limite por arquivo (GLOBAL.md §8). Constante de contrato, não ambiente. */
export const MAX_UPLOAD_BYTES = 5 * 1024 * 1024;

export interface DetectedImage {
  mime: string;
  ext: string;
}

/** Decide pelo conteúdo (magic bytes), nunca pela extensão ou pelo header do cliente. */
export async function detectImage(buffer: Buffer): Promise<DetectedImage> {
  const detected = await fileTypeFromBuffer(buffer);
  const ext = detected ? IMAGE_EXTENSIONS[detected.mime] : undefined;
  if (!detected || !ext) throw new UnsupportedMediaTypeError();
  return { mime: detected.mime, ext };
}
