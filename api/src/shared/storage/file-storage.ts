/** Port de armazenamento de arquivos (ADR 0003). A API nunca serve bytes. */
export interface FileToStore {
  buffer: Buffer;
  mime: string;
}

export interface StoredFile {
  /** Identificador imutável no storage (ex.: `profile/uuid.png`). */
  key: string;
  /** Caminho público permanente, relativo à origem da API (`/uploads/...`). */
  url: string;
}

export abstract class FileStorage {
  abstract put(file: FileToStore, keyPrefix: string): Promise<StoredFile>;
  /** Idempotente: apagar o que não existe não é erro. */
  abstract delete(key: string): Promise<void>;
  /** `/uploads/<key>`: o cliente prefixa com a origem que usa para falar com a API. */
  abstract urlFor(key: string): string;
}
