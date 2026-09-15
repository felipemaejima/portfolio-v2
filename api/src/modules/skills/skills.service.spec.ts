import {
  InMemorySkillCategoryRepository,
  InMemorySkillRepository,
  SkillsStore,
} from '../../../test/in-memory/in-memory-skills.repositories.js';
import { NotFoundError, ValidationError } from '../../shared/http/errors/domain.errors.js';
import { SkillsService } from './skills.service.js';

function make() {
  const store = new SkillsStore();
  return new SkillsService(
    new InMemorySkillCategoryRepository(store),
    new InMemorySkillRepository(store),
  );
}

describe('SkillsService', () => {
  it('categorias entram no fim e reorder exige o conjunto exato', async () => {
    const service = make();
    const a = await service.createCategory('Linguagens');
    const b = await service.createCategory('Bancos');
    expect([a.position, b.position]).toEqual([0, 1]);
    await expect(service.reorderCategories([a.id])).rejects.toBeInstanceOf(ValidationError);
    await service.reorderCategories([b.id, a.id]);
    expect((await service.listCategories()).map((c) => c.name)).toEqual(['Bancos', 'Linguagens']);
  });

  it('skills entram no fim da própria categoria', async () => {
    const service = make();
    const a = await service.createCategory('A');
    const b = await service.createCategory('B');
    const s1 = await service.createSkill(a.id, 'TS');
    const s2 = await service.createSkill(a.id, 'Go');
    const s3 = await service.createSkill(b.id, 'Postgres');
    expect([s1.position, s2.position, s3.position]).toEqual([0, 1, 0]);
  });

  it('mover skill de categoria a coloca no fim da nova', async () => {
    const service = make();
    const a = await service.createCategory('A');
    const b = await service.createCategory('B');
    const s = await service.createSkill(a.id, 'TS');
    await service.createSkill(b.id, 'Postgres');
    const moved = await service.updateSkill(s.id, { name: 'TypeScript', categoryId: b.id });
    expect(moved).toMatchObject({ name: 'TypeScript', categoryId: b.id, position: 1 });
    expect((await service.listCategories())[0]!.skills).toHaveLength(0);
  });

  it('renomear sem mover preserva a posição', async () => {
    const service = make();
    const a = await service.createCategory('A');
    await service.createSkill(a.id, 'x');
    const s = await service.createSkill(a.id, 'y');
    const renamed = await service.updateSkill(s.id, { name: 'z', categoryId: a.id });
    expect(renamed.position).toBe(1);
  });

  it('categoria inexistente em create/update de skill → NotFound / ValidationError', async () => {
    const service = make();
    const a = await service.createCategory('A');
    const s = await service.createSkill(a.id, 'x');
    await expect(service.createSkill('nada', 'x')).rejects.toBeInstanceOf(NotFoundError);
    await expect(service.updateSkill(s.id, { name: 'x', categoryId: 'nada' })).rejects.toSatisfy(
      (e: unknown) => {
        expect(e).toBeInstanceOf(ValidationError);
        expect((e as ValidationError).details['categoryId']).toBeDefined();
        return true;
      },
    );
  });

  it('reorder de skills valida o conjunto da categoria', async () => {
    const service = make();
    const a = await service.createCategory('A');
    const b = await service.createCategory('B');
    const s1 = await service.createSkill(a.id, 'x');
    const s2 = await service.createSkill(a.id, 'y');
    const other = await service.createSkill(b.id, 'z');
    await expect(service.reorderSkills(a.id, [s1.id, other.id])).rejects.toBeInstanceOf(
      ValidationError,
    );
    await service.reorderSkills(a.id, [s2.id, s1.id]);
    expect((await service.listCategories())[0]!.skills.map((s) => s.id)).toEqual([s2.id, s1.id]);
  });

  it('apagar categoria leva as skills junto', async () => {
    const service = make();
    const a = await service.createCategory('A');
    const s = await service.createSkill(a.id, 'x');
    await service.deleteCategory(a.id);
    await expect(service.deleteSkill(s.id)).rejects.toBeInstanceOf(NotFoundError);
  });
});
