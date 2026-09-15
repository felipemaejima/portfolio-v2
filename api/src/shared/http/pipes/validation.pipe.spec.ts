import { ReorderDto } from '../dto/reorder.dto.js';
import { ValidationError } from '../errors/domain.errors.js';
import { createValidationPipe, toDetails } from './validation.pipe.js';

const pipe = createValidationPipe();
const meta = { type: 'body' as const, metatype: ReorderDto };

describe('createValidationPipe', () => {
  it('aceita um ReorderDto válido e o transforma em instância', async () => {
    const ids = ['3f4e1b9a-1c2d-4e5f-8a9b-0c1d2e3f4a5b', 'c0ffee00-1c2d-4e5f-8a9b-0c1d2e3f4a5b'];
    const result = await pipe.transform({ ids }, meta);
    expect(result).toBeInstanceOf(ReorderDto);
    expect(result.ids).toEqual(ids);
  });

  it('lança ValidationError com details por campo', async () => {
    await expect(pipe.transform({ ids: ['nope', 'nope'] }, meta)).rejects.toSatisfy(
      (e: unknown) => {
        expect(e).toBeInstanceOf(ValidationError);
        const details = (e as ValidationError).details;
        expect(details['ids']).toEqual(
          expect.arrayContaining(['não pode ter ids repetidos', 'cada item deve ser um UUID']),
        );
        return true;
      },
    );
  });

  it('rejeita campos fora do DTO (forbidNonWhitelisted)', async () => {
    await expect(
      pipe.transform({ ids: ['3f4e1b9a-1c2d-4e5f-8a9b-0c1d2e3f4a5b'], extra: 1 }, meta),
    ).rejects.toBeInstanceOf(ValidationError);
  });
});

describe('toDetails', () => {
  it('achata erros aninhados com caminho pontuado', () => {
    expect(
      toDetails([
        {
          property: 'location',
          children: [{ property: 'city', constraints: { isNotEmpty: 'não pode ser vazio' } }],
        },
      ]),
    ).toEqual({ 'location.city': ['não pode ser vazio'] });
  });
});
