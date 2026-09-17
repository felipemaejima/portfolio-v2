import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/project_dto.dart';
import '../../../api/models/project_input_dto.dart';
import '../../../core/network/uploads.dart';
import '../data/projects_repository.dart';

/// Todos os projetos, por position (home e painel compartilham).
final projectsProvider = FutureProvider<List<ProjectDto>>(
  (ref) => ref.watch(projectsRepositoryProvider).list(),
);

/// Detalhe por slug: usa a lista se já estiver carregada, senão busca.
final projectBySlugProvider = FutureProvider.autoDispose
    .family<ProjectDto, String>((ref, slug) async {
      final cached = ref
          .watch(projectsProvider)
          .value
          ?.where((p) => p.slug == slug)
          .firstOrNull;
      return cached ?? await ref.watch(projectsRepositoryProvider).bySlug(slug);
    });

/// Projeto por id, a partir da lista (painel).
final projectByIdProvider = Provider.autoDispose.family<ProjectDto?, String>(
  (ref, id) =>
      ref.watch(projectsProvider).value?.where((p) => p.id == id).firstOrNull,
);

class ProjectsEditor {
  ProjectsEditor(this._ref);
  final Ref _ref;
  ProjectsRepository get _repo => _ref.read(projectsRepositoryProvider);

  Future<ProjectDto> create(ProjectInputDto body) async =>
      _refresh(await _repo.create(body));
  Future<ProjectDto> update(String id, ProjectInputDto body) async =>
      _refresh(await _repo.update(id, body));
  Future<void> delete(String id) async {
    await _repo.delete(id);
    _ref.invalidate(projectsProvider);
  }

  Future<void> reorder(List<String> ids) async {
    await _repo.reorder(ids);
    _ref.invalidate(projectsProvider);
  }

  Future<ProjectDto> addImages(String id, List<PickedImage> images) async =>
      _refresh(await _repo.addImages(id, images));
  Future<void> deleteImage(String id, String imageId) async {
    await _repo.deleteImage(id, imageId);
    _ref.invalidate(projectsProvider);
  }

  Future<void> reorderImages(String id, List<String> ids) async {
    await _repo.reorderImages(id, ids);
    _ref.invalidate(projectsProvider);
  }

  ProjectDto _refresh(ProjectDto p) {
    _ref.invalidate(projectsProvider);
    return p;
  }
}

final projectsEditorProvider = Provider<ProjectsEditor>(ProjectsEditor.new);
