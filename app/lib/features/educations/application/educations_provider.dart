import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/education_dto.dart';
import '../../../api/models/education_input_dto.dart';
import '../data/educations_repository.dart';

final educationsProvider = FutureProvider<List<EducationDto>>(
  (ref) => ref.watch(educationsRepositoryProvider).list(),
);

final educationByIdProvider = Provider.autoDispose
    .family<EducationDto?, String>(
      (ref, id) => ref
          .watch(educationsProvider)
          .value
          ?.where((e) => e.id == id)
          .firstOrNull,
    );

class EducationsEditor {
  EducationsEditor(this._ref);
  final Ref _ref;
  EducationsRepository get _repo => _ref.read(educationsRepositoryProvider);

  Future<void> create(EducationInputDto body) async {
    await _repo.create(body);
    _ref.invalidate(educationsProvider);
  }

  Future<void> update(String id, EducationInputDto body) async {
    await _repo.update(id, body);
    _ref.invalidate(educationsProvider);
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _ref.invalidate(educationsProvider);
  }
}

final educationsEditorProvider = Provider<EducationsEditor>(
  EducationsEditor.new,
);
