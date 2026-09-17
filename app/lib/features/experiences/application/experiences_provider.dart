import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/experience_dto.dart';
import '../../../api/models/experience_input_dto.dart';
import '../data/experiences_repository.dart';

final experiencesProvider = FutureProvider<List<ExperienceDto>>(
  (ref) => ref.watch(experiencesRepositoryProvider).list(),
);

final experienceByIdProvider = Provider.autoDispose
    .family<ExperienceDto?, String>(
      (ref, id) => ref
          .watch(experiencesProvider)
          .value
          ?.where((e) => e.id == id)
          .firstOrNull,
    );

class ExperiencesEditor {
  ExperiencesEditor(this._ref);
  final Ref _ref;
  ExperiencesRepository get _repo => _ref.read(experiencesRepositoryProvider);

  Future<ExperienceDto> create(ExperienceInputDto body) async {
    final created = await _repo.create(body);
    _ref.invalidate(experiencesProvider);
    return created;
  }

  Future<void> update(String id, ExperienceInputDto body) async {
    await _repo.update(id, body);
    _ref.invalidate(experiencesProvider);
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _ref.invalidate(experiencesProvider);
  }
}

final experiencesEditorProvider = Provider<ExperiencesEditor>(
  ExperiencesEditor.new,
);
