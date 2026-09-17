// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_skill_dto.dart';
import '../models/reorder_dto.dart';
import '../models/skill_category_dto.dart';
import '../models/skill_category_input_dto.dart';
import '../models/skill_dto.dart';
import '../models/update_skill_dto.dart';

part 'skills_client.g.dart';

@RestApi()
abstract class SkillsClient {
  factory SkillsClient(Dio dio, {String? baseUrl}) = _SkillsClient;

  /// Categorias por `position`, cada uma com suas skills por `position`.
  @GET('/api/v1/skill-categories')
  Future<List<SkillCategoryDto>> listSkillCategories();

  /// Cria no fim.
  @POST('/api/v1/skill-categories')
  Future<SkillCategoryDto> createSkillCategory({
    @Body() required SkillCategoryInputDto body,
  });

  @PUT('/api/v1/skill-categories/{id}')
  Future<SkillCategoryDto> updateSkillCategory({
    @Path('id') required String id,
    @Body() required SkillCategoryInputDto body,
  });

  /// Apaga a categoria e suas skills.
  @DELETE('/api/v1/skill-categories/{id}')
  Future<void> deleteSkillCategory({
    @Path('id') required String id,
  });

  /// Ordem das categorias: o conjunto completo de ids na ordem final.
  @PATCH('/api/v1/skill-categories/reorder')
  Future<void> reorderSkillCategories({
    @Body() required ReorderDto body,
  });

  /// Cria uma skill no fim da categoria.
  @POST('/api/v1/skill-categories/{id}/skills')
  Future<SkillDto> createSkill({
    @Path('id') required String id,
    @Body() required CreateSkillDto body,
  });

  /// Ordem das skills dentro da categoria: o conjunto completo de ids na ordem final.
  @PATCH('/api/v1/skill-categories/{id}/skills/reorder')
  Future<void> reorderSkills({
    @Path('id') required String id,
    @Body() required ReorderDto body,
  });

  /// Renomeia e/ou move de categoria (vai para o fim da nova).
  @PUT('/api/v1/skills/{id}')
  Future<SkillDto> updateSkill({
    @Path('id') required String id,
    @Body() required UpdateSkillDto body,
  });

  @DELETE('/api/v1/skills/{id}')
  Future<void> deleteSkill({
    @Path('id') required String id,
  });
}
