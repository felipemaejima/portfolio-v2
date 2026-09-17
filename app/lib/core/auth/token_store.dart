import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Onde o refresh token vive (ADR 0002). O access token nunca toca disco.
abstract class TokenStore {
  Future<String?> readRefresh();
  Future<void> writeRefresh(String token);
  Future<void> clear();
}

/// Mobile: secure storage.
class SecureTokenStore implements TokenStore {
  SecureTokenStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'refresh_token';
  final FlutterSecureStorage _storage;

  @override
  Future<String?> readRefresh() => _storage.read(key: _key);

  @override
  Future<void> writeRefresh(String token) =>
      _storage.write(key: _key, value: token);

  @override
  Future<void> clear() => _storage.delete(key: _key);
}

/// Web: o browser guarda o cookie httpOnly; o app nunca vê o refresh.
/// `readRefresh` devolve null e o boot tenta o refresh mesmo assim.
class WebTokenStore implements TokenStore {
  const WebTokenStore();

  @override
  Future<String?> readRefresh() async => null;

  @override
  Future<void> writeRefresh(String token) async {}

  @override
  Future<void> clear() async {}
}

final tokenStoreProvider = Provider<TokenStore>(
  (ref) => kIsWeb ? const WebTokenStore() : SecureTokenStore(),
);
