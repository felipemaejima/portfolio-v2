import { ValidationError } from '../http/errors/domain.errors.js';
import { assertSameIdSet } from './reorder.js';

describe('assertSameIdSet', () => {
  it('aceita permutação exata', () => {
    expect(() => assertSameIdSet(['a', 'b', 'c'], ['c', 'a', 'b'])).not.toThrow();
  });
  it('acusa faltantes, desconhecidos e repetidos com mensagens por caso', () => {
    try {
      assertSameIdSet(['a', 'b', 'c'], ['a', 'a', 'x']);
      expect.unreachable();
    } catch (e) {
      expect(e).toBeInstanceOf(ValidationError);
      expect((e as ValidationError).details['ids']).toEqual([
        'não pode ter ids repetidos',
        'faltam 2 id(s) da coleção',
        '1 id(s) não pertencem à coleção',
      ]);
    }
  });
});
