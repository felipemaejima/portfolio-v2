import '../errors/api_failure.dart';

/// Normaliza qualquer erro do cliente gerado em ApiFailure (camada data/).
Future<T> guard<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on Object catch (e) {
    throw ApiFailure.from(e);
  }
}
