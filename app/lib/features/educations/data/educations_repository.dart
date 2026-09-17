import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/education_dto.dart';
import '../../../api/models/education_input_dto.dart';
import '../../../api/rest_client.dart';
import '../../../core/data/guard.dart';
import '../../../core/network/rest_client.dart';

class EducationsRepository {
  EducationsRepository(this._api);
  final RestClient _api;

  Future<List<EducationDto>> list() => guard(_api.educations.listEducations);
  Future<EducationDto> create(EducationInputDto body) =>
      guard(() => _api.educations.createEducation(body: body));
  Future<EducationDto> update(String id, EducationInputDto body) =>
      guard(() => _api.educations.updateEducation(id: id, body: body));
  Future<void> delete(String id) =>
      guard(() => _api.educations.deleteEducation(id: id));
}

final educationsRepositoryProvider = Provider<EducationsRepository>(
  (ref) => EducationsRepository(ref.watch(restClientProvider)),
);
