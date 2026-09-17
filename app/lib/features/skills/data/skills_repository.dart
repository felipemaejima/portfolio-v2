import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/create_skill_dto.dart';
import '../../../api/models/reorder_dto.dart';
import '../../../api/models/skill_category_dto.dart';
import '../../../api/models/skill_category_input_dto.dart';
import '../../../api/models/skill_dto.dart';
import '../../../api/models/update_skill_dto.dart';
import '../../../api/rest_client.dart';
import '../../../core/data/guard.dart';
import '../../../core/network/rest_client.dart';

class SkillsRepository {
  SkillsRepository(this._api);
  final RestClient _api;

  Future<List<SkillCategoryDto>> list() =>
      guard(_api.skills.listSkillCategories);
  Future<SkillCategoryDto> createCategory(String name) => guard(
    () => _api.skills.createSkillCategory(
      body: SkillCategoryInputDto(name: name),
    ),
  );
  Future<SkillCategoryDto> updateCategory(String id, String name) => guard(
    () => _api.skills.updateSkillCategory(
      id: id,
      body: SkillCategoryInputDto(name: name),
    ),
  );
  Future<void> deleteCategory(String id) =>
      guard(() => _api.skills.deleteSkillCategory(id: id));
  Future<void> reorderCategories(List<String> ids) => guard(
    () => _api.skills.reorderSkillCategories(body: ReorderDto(ids: ids)),
  );
  Future<SkillDto> createSkill(String categoryId, String name) => guard(
    () => _api.skills.createSkill(
      id: categoryId,
      body: CreateSkillDto(name: name),
    ),
  );
  Future<SkillDto> updateSkill(String id, String name, String categoryId) =>
      guard(
        () => _api.skills.updateSkill(
          id: id,
          body: UpdateSkillDto(name: name, categoryId: categoryId),
        ),
      );
  Future<void> deleteSkill(String id) =>
      guard(() => _api.skills.deleteSkill(id: id));
  Future<void> reorderSkills(String categoryId, List<String> ids) => guard(
    () => _api.skills.reorderSkills(
      id: categoryId,
      body: ReorderDto(ids: ids),
    ),
  );
}

final skillsRepositoryProvider = Provider<SkillsRepository>(
  (ref) => SkillsRepository(ref.watch(restClientProvider)),
);
