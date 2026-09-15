import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/experience_dto.dart';
import '../../../api/models/experience_input_dto.dart';
import '../../../api/rest_client.dart';
import '../../../core/data/guard.dart';
import '../../../core/network/rest_client.dart';

class ExperiencesRepository {
  ExperiencesRepository(this._api);
  final RestClient _api;

  Future<List<ExperienceDto>> list() => guard(_api.experiences.listExperiences);
  Future<ExperienceDto> create(ExperienceInputDto body) => guard(() => _api.experiences.createExperience(body: body));
  Future<ExperienceDto> update(String id, ExperienceInputDto body) => guard(() => _api.experiences.updateExperience(id: id, body: body));
  Future<void> delete(String id) => guard(() => _api.experiences.deleteExperience(id: id));
}

final experiencesRepositoryProvider = Provider<ExperiencesRepository>((ref) => ExperiencesRepository(ref.watch(restClientProvider)));
