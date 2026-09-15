import type { CvDocument } from '../cv-document.js';

/** Port: transforma o CvDocument em bytes de PDF. */
export abstract class CvRenderer {
  abstract render(doc: CvDocument): Promise<Buffer>;
}
