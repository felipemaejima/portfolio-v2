// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/admin_dto.dart';
import '../models/auth_tokens_dto.dart';
import '../models/login_dto.dart';
import '../models/refresh_dto.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  /// Autentica o Admin. WEB recebe o refresh em cookie httpOnly; MOBILE, no body.
  @POST('/api/v1/auth/login')
  Future<AuthTokensDto> login({@Body() required LoginDto body});

  /// Rotaciona o refresh (cookie primeiro, body como fallback) e devolve um par novo.
  @POST('/api/v1/auth/refresh')
  Future<AuthTokensDto> refresh({@Body() required RefreshDto body});

  /// Revoga a família do refresh atual e limpa o cookie.
  @POST('/api/v1/auth/logout')
  Future<void> logout({@Body() required RefreshDto body});

  /// O Admin autenticado. O app usa no boot para validar a sessão.
  @GET('/api/v1/auth/me')
  Future<AdminDto> me();
}
