import 'package:dio/dio.dart';

import '../../api/models/error_code.dart';
import '../../api/models/error_response_dto.dart';

/// Falha de API já interpretada pelo `code` do ErrorResponse (GLOBAL.md §7).
/// O app decide por tipo, nunca por texto.
sealed class ApiFailure implements Exception {
  const ApiFailure(this.message);

  /// Texto exibível vindo da API (PT-BR) ou um fallback.
  final String message;

  factory ApiFailure.from(Object error) {
    if (error is ApiFailure) return error;
    if (error is! DioException) return ApiUnexpected('$error');

    final response = error.response;
    if (response == null) return const ApiNetwork();

    final body = _errorBody(response.data);
    final code = body?.code;
    final message = body?.message ?? 'Erro ${response.statusCode}.';
    return switch (code) {
      ErrorCode.unauthenticated => ApiUnauthenticated(message),
      ErrorCode.notFound => ApiNotFound(message),
      ErrorCode.validationFailed => ApiValidation(
        message,
        body?.details ?? const {},
      ),
      ErrorCode.rateLimited => ApiRateLimited(message),
      ErrorCode.payloadTooLarge ||
      ErrorCode.unsupportedMediaType ||
      ErrorCode.badRequest => ApiRejected(message, code!),
      _ => ApiServer(message, response.statusCode ?? 500),
    };
  }

  static ErrorResponseDto? _errorBody(Object? data) {
    if (data is! Map<String, Object?> || data['code'] is! String) return null;
    try {
      return ErrorResponseDto.fromJson(data);
    } on Object {
      return null;
    }
  }

  @override
  String toString() => '$runtimeType: $message';
}

/// Sem resposta: offline, DNS, timeout.
final class ApiNetwork extends ApiFailure {
  const ApiNetwork() : super('Sem conexão com o servidor.');
}

final class ApiUnauthenticated extends ApiFailure {
  const ApiUnauthenticated(super.message);
}

final class ApiNotFound extends ApiFailure {
  const ApiNotFound(super.message);
}

/// 422: mensagens por campo, no formato do contrato.
final class ApiValidation extends ApiFailure {
  const ApiValidation(super.message, this.details);
  final Map<String, List<String>> details;

  String? field(String name) => details[name]?.join(' · ');
}

final class ApiRateLimited extends ApiFailure {
  const ApiRateLimited(super.message);
}

/// 400/413/415: a request foi recusada por forma, não por dados.
final class ApiRejected extends ApiFailure {
  const ApiRejected(super.message, this.code);
  final ErrorCode code;
}

final class ApiServer extends ApiFailure {
  const ApiServer(super.message, this.statusCode);
  final int statusCode;
}

final class ApiUnexpected extends ApiFailure {
  const ApiUnexpected(super.message);
}
