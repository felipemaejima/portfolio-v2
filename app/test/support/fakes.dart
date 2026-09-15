import 'package:portfolio_app/api/models/admin_dto.dart';
import 'package:portfolio_app/api/models/auth_tokens_dto.dart';
import 'package:portfolio_app/core/auth/auth_repository.dart';
import 'package:portfolio_app/core/auth/token_store.dart';
import 'package:portfolio_app/core/errors/api_failure.dart';

class InMemoryTokenStore implements TokenStore {
  InMemoryTokenStore([this.refresh]);
  String? refresh;

  @override
  Future<String?> readRefresh() async => refresh;
  @override
  Future<void> writeRefresh(String token) async => refresh = token;
  @override
  Future<void> clear() async => refresh = null;
}

/// Repositório de auth falso: conta chamadas e simula falhas.
class FakeAuthRepository implements AuthRepository {
  int refreshCalls = 0;
  int loginCalls = 0;
  String? logoutCalledWith;
  bool refreshFails = false;
  bool loginFails = false;
  Duration refreshDelay = Duration.zero;
  int _seq = 0;

  static const admin = AdminDto(id: 'admin-id', email: 'admin@example.com');

  AuthTokensDto _tokens() {
    _seq++;
    return AuthTokensDto(accessToken: 'access-$_seq', expiresIn: 900, refreshToken: 'refresh-$_seq');
  }

  @override
  Future<AuthTokensDto> login(String email, String password) async {
    loginCalls++;
    if (loginFails) throw const ApiUnauthenticated('E-mail ou senha inválidos.');
    return _tokens();
  }

  @override
  Future<AuthTokensDto> refresh(String? refreshToken) async {
    refreshCalls++;
    await Future<void>.delayed(refreshDelay);
    if (refreshFails) throw const ApiUnauthenticated('Sessão expirada.');
    return _tokens();
  }

  @override
  Future<void> logout(String? refreshToken) async => logoutCalledWith = refreshToken;

  @override
  Future<AdminDto> me() async => admin;
}
