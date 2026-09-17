import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/clients/auth_client.dart';
import '../../api/models/admin_dto.dart';
import '../../api/models/auth_tokens_dto.dart';
import '../../api/models/client_platform.dart';
import '../../api/models/login_dto.dart';
import '../../api/models/refresh_dto.dart';
import '../errors/api_failure.dart';
import '../network/dio.dart';

/// Envolve o AuthClient gerado. login/refresh usam o Dio cru (sem bearer,
/// sem retry); me/logout usam o Dio principal (com bearer).
class AuthRepository {
  AuthRepository({required AuthClient raw, required AuthClient authed})
    : _raw = raw,
      _authed = authed;

  final AuthClient _raw;
  final AuthClient _authed;

  // ignore_for_file: prefer_initializing_formals — campos privados com nome público

  static ClientPlatform get platform =>
      kIsWeb ? ClientPlatform.web : ClientPlatform.mobile;

  Future<AuthTokensDto> login(String email, String password) => _guard(
    () => _raw.login(
      body: LoginDto(
        email: email,
        password: password,
        clientPlatform: platform,
      ),
    ),
  );

  /// Web: body vazio, o cookie vai sozinho. Mobile: refresh do store.
  Future<AuthTokensDto> refresh(String? refreshToken) =>
      _guard(() => _raw.refresh(body: RefreshDto(refreshToken: refreshToken)));

  Future<void> logout(String? refreshToken) => _guard(
    () => _authed.logout(body: RefreshDto(refreshToken: refreshToken)),
  );

  Future<AdminDto> me() => _guard(_authed.me);

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on Object catch (e) {
      throw ApiFailure.from(e);
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    raw: AuthClient(ref.watch(authDioProvider)),
    authed: AuthClient(ref.watch(dioProvider)),
  ),
);
