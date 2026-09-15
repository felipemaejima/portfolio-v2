import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_app/api/models/error_code.dart';
import 'package:portfolio_app/core/errors/api_failure.dart';

DioException _http(int status, Map<String, Object?> body) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      response: Response(requestOptions: RequestOptions(path: '/x'), statusCode: status, data: body),
    );

void main() {
  test('sem resposta → ApiNetwork', () {
    final e = DioException(requestOptions: RequestOptions(path: '/x'), type: DioExceptionType.connectionTimeout);
    expect(ApiFailure.from(e), isA<ApiNetwork>());
  });

  test('decide pelo code do contrato, não pelo status', () {
    expect(ApiFailure.from(_http(401, {'statusCode': 401, 'code': 'UNAUTHENTICATED', 'message': 'Não autenticado.'})), isA<ApiUnauthenticated>());
    expect(ApiFailure.from(_http(404, {'statusCode': 404, 'code': 'NOT_FOUND', 'message': 'x'})), isA<ApiNotFound>());
    expect(ApiFailure.from(_http(429, {'statusCode': 429, 'code': 'RATE_LIMITED', 'message': 'x'})), isA<ApiRateLimited>());
    final rejected = ApiFailure.from(_http(415, {'statusCode': 415, 'code': 'UNSUPPORTED_MEDIA_TYPE', 'message': 'x'}));
    expect(rejected, isA<ApiRejected>());
    expect((rejected as ApiRejected).code, ErrorCode.unsupportedMediaType);
  });

  test('422 carrega details por campo', () {
    final f = ApiFailure.from(_http(422, {
      'statusCode': 422,
      'code': 'VALIDATION_FAILED',
      'message': 'Dados inválidos.',
      'details': {'email': ['deve ser um e-mail válido', 'obrigatório']},
    }));
    expect(f, isA<ApiValidation>());
    expect((f as ApiValidation).field('email'), 'deve ser um e-mail válido · obrigatório');
    expect(f.field('nada'), isNull);
  });

  test('corpo desconhecido (ex.: HTML de proxy) → ApiServer com o status', () {
    final f = ApiFailure.from(_http(502, {'oops': true}));
    expect(f, isA<ApiServer>());
    expect((f as ApiServer).statusCode, 502);
  });

  test('erro que já é ApiFailure passa direto', () {
    const original = ApiNotFound('x');
    expect(identical(ApiFailure.from(original), original), isTrue);
  });
}
