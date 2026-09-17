// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/education_dto.dart';
import '../models/education_input_dto.dart';

part 'educations_client.g.dart';

@RestApi()
abstract class EducationsClient {
  factory EducationsClient(Dio dio, {String? baseUrl}) = _EducationsClient;

  /// Em andamento primeiro; depois as mais recentes.
  @GET('/api/v1/educations')
  Future<List<EducationDto>> listEducations();

  @POST('/api/v1/educations')
  Future<EducationDto> createEducation({
    @Body() required EducationInputDto body,
  });

  @PUT('/api/v1/educations/{id}')
  Future<EducationDto> updateEducation({
    @Path('id') required String id,
    @Body() required EducationInputDto body,
  });

  @DELETE('/api/v1/educations/{id}')
  Future<void> deleteEducation({
    @Path('id') required String id,
  });
}
