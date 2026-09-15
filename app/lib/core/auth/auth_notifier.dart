import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/models/auth_tokens_dto.dart';
import '../errors/api_failure.dart';
import 'access_token.dart';
import 'auth_repository.dart';
import 'auth_state.dart';
import 'token_store.dart';

/// Sessão do Admin (APP.md §4). Boot = tentar refresh (cookie no web, store
/// no mobile) e então `me`. Access token só em memória.
class AuthNotifier extends AsyncNotifier<AuthState> {
  Future<String?>? _refreshing;

  AuthRepository get _repo => ref.read(authRepositoryProvider);
  TokenStore get _store => ref.read(tokenStoreProvider);
  AccessTokenHolder get _access => ref.read(accessTokenProvider);

  @override
  Future<AuthState> build() => _boot();

  Future<AuthState> _boot() async {
    final token = await refreshAccessToken();
    if (token == null) return const Anonymous();
    try {
      return Authenticated(await _repo.me());
    } on ApiFailure {
      await _forget();
      return const Anonymous();
    }
  }

  Future<void> login(String email, String password) async {
    final tokens = await _repo.login(email, password);
    await _accept(tokens);
    state = AsyncData(Authenticated(await _repo.me()));
  }

  Future<void> logout() async {
    final refresh = await _store.readRefresh();
    try {
      await _repo.logout(refresh);
    } on ApiFailure {
      // sessão já morta no servidor: localmente o resultado é o mesmo
    }
    await _forget();
    state = const AsyncData(Anonymous());
  }

  /// Rotaciona o refresh e devolve o access novo, ou null se a sessão acabou.
  /// Single-flight: chamadas concorrentes compartilham a mesma Future.
  Future<String?> refreshAccessToken() => _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);

  Future<String?> _doRefresh() async {
    final stored = await _store.readRefresh();
    // Mobile sem refresh guardado: não há sessão. Web: o cookie decide.
    if (stored == null && !kIsWeb) return null;
    try {
      final tokens = await _repo.refresh(stored);
      await _accept(tokens);
      return tokens.accessToken;
    } on ApiFailure {
      await _forget();
      if (state.value is Authenticated) state = const AsyncData(Anonymous());
      return null;
    }
  }

  Future<void> _accept(AuthTokensDto tokens) async {
    _access.value = tokens.accessToken;
    final refresh = tokens.refreshToken;
    if (refresh != null) await _store.writeRefresh(refresh);
  }

  Future<void> _forget() async {
    _access.value = null;
    await _store.clear();
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
