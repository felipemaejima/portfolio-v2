import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Access token em memória, só. Lido pelo AuthInterceptor, escrito pelo AuthNotifier.
class AccessTokenHolder {
  String? value;
}

final accessTokenProvider = Provider<AccessTokenHolder>((ref) => AccessTokenHolder());
