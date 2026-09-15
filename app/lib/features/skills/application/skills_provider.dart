import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/skill_category_dto.dart';
import '../data/skills_repository.dart';

final skillCategoriesProvider = FutureProvider<List<SkillCategoryDto>>((ref) => ref.watch(skillsRepositoryProvider).list());

/// Toda mutação invalida a lista: ela é pequena e é a fonte de tudo.
class SkillsEditor {
  SkillsEditor(this._ref);
  final Ref _ref;
  SkillsRepository get _repo => _ref.read(skillsRepositoryProvider);

  Future<void> _then(Future<void> Function() action) async {
    await action();
    _ref.invalidate(skillCategoriesProvider);
  }

  Future<void> createCategory(String name) => _then(() => _repo.createCategory(name));
  Future<void> renameCategory(String id, String name) => _then(() => _repo.updateCategory(id, name));
  Future<void> deleteCategory(String id) => _then(() => _repo.deleteCategory(id));
  Future<void> reorderCategories(List<String> ids) => _then(() => _repo.reorderCategories(ids));
  Future<void> createSkill(String categoryId, String name) => _then(() => _repo.createSkill(categoryId, name));
  Future<void> updateSkill(String id, String name, String categoryId) => _then(() => _repo.updateSkill(id, name, categoryId));
  Future<void> deleteSkill(String id) => _then(() => _repo.deleteSkill(id));
  Future<void> reorderSkills(String categoryId, List<String> ids) => _then(() => _repo.reorderSkills(categoryId, ids));
}

final skillsEditorProvider = Provider<SkillsEditor>(SkillsEditor.new);
