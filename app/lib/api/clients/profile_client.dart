// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/profile_dto.dart';
import '../models/update_profile_dto.dart';

part 'profile_client.g.dart';

@RestApi()
abstract class ProfileClient {
  factory ProfileClient(Dio dio, {String? baseUrl}) = _ProfileClient;

  /// Dados de apresentação do Admin (seção "Sobre"). Nunca expõe credenciais.
  @GET('/api/v1/profile')
  Future<ProfileDto> getProfile();

  /// Substitui o Profile inteiro.
  @PUT('/api/v1/profile')
  Future<ProfileDto> updateProfile({
    @Body() required UpdateProfileDto body,
  });

  /// Remove a foto.
  @DELETE('/api/v1/profile/image')
  Future<void> deleteProfileImage();
}
