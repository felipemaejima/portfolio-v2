import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/access_token.dart';
import '../auth/auth_notifier.dart';
import '../config/app_config.dart';

BaseOptions _baseOptions() => BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      // Web: cookie de refresh trafega (ADR 0002). Ignorado fora do browser.
      extra: const {'withCredentials': true},
    );

/// Dio "cru" para login/refresh/logout: sem bearer automático, sem retry.
final authDioProvider = Provider<Dio>((ref) => Dio(_baseOptions()));

/// Dio principal: anexa o bearer e, num 401, faz um único refresh e repete.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(_baseOptions());
  final tokens = ref.watch(accessTokenProvider);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = tokens.value;
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    ),
  );

  // QueuedInterceptor: enquanto um refresh roda, as outras falhas esperam na
  // fila e já encontram o token novo — single-flight sem estado extra.
  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onError: (error, handler) async {
        final options = error.requestOptions;
        final is401 = error.response?.statusCode == 401;
        final alreadyRetried = options.extra['retried'] == true;
        if (!is401 || alreadyRetried || options.path.contains('/auth/')) {
          return handler.next(error);
        }

        final token = await ref.read(authProvider.notifier).refreshAccessToken();
        if (token == null) return handler.next(error);

        options.extra['retried'] = true;
        options.headers['Authorization'] = 'Bearer $token';
        try {
          handler.resolve(await dio.fetch<Object?>(options));
        } on DioException catch (e) {
          handler.next(e);
        }
      },
    ),
  );

  return dio;
});
