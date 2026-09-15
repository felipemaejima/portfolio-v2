// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/experience_dto.dart';
import '../models/experience_input_dto.dart';

part 'experiences_client.g.dart';

@RestApi()
abstract class ExperiencesClient {
  factory ExperiencesClient(Dio dio, {String? baseUrl}) = _ExperiencesClient;

  /// Atual primeiro; depois as mais recentes.
  @GET('/api/v1/experiences')
  Future<List<ExperienceDto>> listExperiences();

  @POST('/api/v1/experiences')
  Future<ExperienceDto> createExperience({
    @Body() required ExperienceInputDto body,
  });

  @PUT('/api/v1/experiences/{id}')
  Future<ExperienceDto> updateExperience({
    @Path('id') required String id,
    @Body() required ExperienceInputDto body,
  });

  @DELETE('/api/v1/experiences/{id}')
  Future<void> deleteExperience({
    @Path('id') required String id,
  });
}
