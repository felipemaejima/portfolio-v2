// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/project_dto.dart';
import '../models/project_input_dto.dart';
import '../models/reorder_dto.dart';

part 'projects_client.g.dart';

@RestApi()
abstract class ProjectsClient {
  factory ProjectsClient(Dio dio, {String? baseUrl}) = _ProjectsClient;

  /// Todos os projetos, por `position`, com galeria.
  @GET('/api/v1/projects')
  Future<List<ProjectDto>> listProjects();

  /// Cria no fim da vitrine; `slug` é derivado do nome.
  @POST('/api/v1/projects')
  Future<ProjectDto> createProject({@Body() required ProjectInputDto body});

  /// Detalhe pelo slug.
  @GET('/api/v1/projects/{slug}')
  Future<ProjectDto> getProjectBySlug({@Path('slug') required String slug});

  /// Substitui os campos; `slug` e galeria não mudam.
  @PUT('/api/v1/projects/{id}')
  Future<ProjectDto> updateProject({
    @Path('id') required String id,
    @Body() required ProjectInputDto body,
  });

  /// Apaga o projeto, suas imagens e os arquivos.
  @DELETE('/api/v1/projects/{id}')
  Future<void> deleteProject({@Path('id') required String id});

  /// Ordem da vitrine: o conjunto completo de ids na ordem final.
  @PATCH('/api/v1/projects/reorder')
  Future<void> reorderProjects({@Body() required ReorderDto body});

  /// Remove uma imagem da galeria e o arquivo.
  @DELETE('/api/v1/projects/{id}/images/{imageId}')
  Future<void> deleteProjectImage({
    @Path('id') required String id,
    @Path('imageId') required String imageId,
  });

  /// Ordem da galeria: o conjunto completo de ids das imagens na ordem final.
  @PATCH('/api/v1/projects/{id}/images/reorder')
  Future<void> reorderProjectImages({
    @Path('id') required String id,
    @Body() required ReorderDto body,
  });
}
