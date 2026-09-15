import { ValidationError } from '../http/errors/domain.errors.js';

/**
 * Contrato de `reorder` (GLOBAL.md §4): a lista recebida deve ser exatamente o
 * conjunto de ids do escopo — nem a mais, nem a menos, sem repetição.
 */
export function assertSameIdSet(expected: readonly string[], received: readonly string[]): void {
  const want = new Set(expected);
  const got = new Set(received);
  const missing = expected.filter((id) => !got.has(id));
  const unknown = received.filter((id) => !want.has(id));
  const messages: string[] = [];
  if (got.size !== received.length) messages.push('não pode ter ids repetidos');
  if (missing.length) messages.push(`faltam ${missing.length} id(s) da coleção`);
  if (unknown.length) messages.push(`${unknown.length} id(s) não pertencem à coleção`);
  if (messages.length) throw new ValidationError({ ids: messages });
}
