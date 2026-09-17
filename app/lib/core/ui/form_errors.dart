import '../errors/api_failure.dart';

/// Erros por campo vindos de um 422, no formato `details` do contrato
/// (`name`, `location.city`, `languages.0.level`).
class FormErrors {
  const FormErrors([this._details = const {}]);
  final Map<String, List<String>> _details;

  static const none = FormErrors();

  factory FormErrors.of(Object? error) =>
      error is ApiValidation ? FormErrors(error.details) : none;

  String? operator [](String field) => _details[field]?.join(' · ');

  bool get isEmpty => _details.isEmpty;

  /// Mensagens de campos que o formulário não exibe individualmente.
  String? others(Iterable<String> shown) {
    final rest = _details.entries
        .where((e) => !shown.contains(e.key))
        .map((e) => '${e.key}: ${e.value.join(', ')}');
    return rest.isEmpty ? null : rest.join('\n');
  }
}
