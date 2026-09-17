import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/project_dto.dart';
import '../../../api/models/project_input_dto.dart';
import '../../../api/models/reorder_dto.dart';
import '../../../api/rest_client.dart';
import '../../../core/errors/api_failure.dart';
import '../../../core/network/rest_client.dart';
import '../../../core/network/uploads.dart';

class ProjectsRepository {
  ProjectsRepository(this._api, this._uploads);
  final RestClient _api;
  final Uploads _uploads;

  Future<List<ProjectDto>> list() => _guard(_api.projects.listProjects);
  Future<ProjectDto> bySlug(String slug) =>
      _guard(() => _api.projects.getProjectBySlug(slug: slug));
  Future<ProjectDto> create(ProjectInputDto body) =>
      _guard(() => _api.projects.createProject(body: body));
  Future<ProjectDto> update(String id, ProjectInputDto body) =>
      _guard(() => _api.projects.updateProject(id: id, body: body));
  Future<void> delete(String id) =>
      _guard(() => _api.projects.deleteProject(id: id));
  Future<void> reorder(List<String> ids) =>
      _guard(() => _api.projects.reorderProjects(body: ReorderDto(ids: ids)));
  Future<ProjectDto> addImages(String id, List<PickedImage> images) =>
      _guard(() => _uploads.addProjectImages(id, images));
  Future<void> deleteImage(String id, String imageId) =>
      _guard(() => _api.projects.deleteProjectImage(id: id, imageId: imageId));
  Future<void> reorderImages(String id, List<String> ids) => _guard(
    () => _api.projects.reorderProjectImages(
      id: id,
      body: ReorderDto(ids: ids),
    ),
  );
}

Future<T> _guard<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on Object catch (e) {
    throw ApiFailure.from(e);
  }
}

final projectsRepositoryProvider = Provider<ProjectsRepository>(
  (ref) => ProjectsRepository(
    ref.watch(restClientProvider),
    ref.watch(uploadsProvider),
  ),
);
