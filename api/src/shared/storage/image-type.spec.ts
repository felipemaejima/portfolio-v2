import { UnsupportedMediaTypeError } from '../http/errors/domain.errors.js';
import { detectImage } from './image-type.js';

const PNG_1X1 = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
  'base64',
);

describe('detectImage', () => {
  it('reconhece PNG pelo conteúdo', async () => {
    await expect(detectImage(PNG_1X1)).resolves.toEqual({ mime: 'image/png', ext: 'png' });
  });

  it('reconhece JPEG e WebP pelas assinaturas', async () => {
    const jpeg = Buffer.concat([Buffer.from([0xff, 0xd8, 0xff, 0xe0]), Buffer.alloc(64)]);
    await expect(detectImage(jpeg)).resolves.toMatchObject({ mime: 'image/jpeg' });
    const webp = Buffer.concat([
      Buffer.from('RIFF'),
      Buffer.alloc(4),
      Buffer.from('WEBPVP8 '),
      Buffer.alloc(64),
    ]);
    await expect(detectImage(webp)).resolves.toMatchObject({ mime: 'image/webp' });
  });

  it('rejeita texto, PDF e GIF (não aceito) com UnsupportedMediaTypeError', async () => {
    await expect(detectImage(Buffer.from('hello'))).rejects.toBeInstanceOf(
      UnsupportedMediaTypeError,
    );
    await expect(detectImage(Buffer.from('%PDF-1.4\n'))).rejects.toBeInstanceOf(
      UnsupportedMediaTypeError,
    );
    await expect(detectImage(Buffer.from('GIF89a' + '\0'.repeat(32)))).rejects.toBeInstanceOf(
      UnsupportedMediaTypeError,
    );
  });
});
