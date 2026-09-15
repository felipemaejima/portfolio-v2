// Prepara o contrato para o swagger_parser (ADR 0004).
//
// Remove as operações multipart/form-data: o gerador as traduz para
// `dart:io File`, que não existe no Flutter Web. Esses uploads são escritos à
// mão em lib/core/network/uploads.dart com `MultipartFile.fromBytes`.
//
// Uso: dart run tool/prepare_openapi.dart openapi.source.json openapi.json
import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final source = File(args.isNotEmpty ? args[0] : 'openapi.source.json');
  final target = File(args.length > 1 ? args[1] : 'openapi.json');
  final doc = jsonDecode(source.readAsStringSync()) as Map<String, dynamic>;
  final paths = doc['paths'] as Map<String, dynamic>;
  final removed = <String>[];

  for (final entry in paths.entries.toList()) {
    final operations = entry.value as Map<String, dynamic>;
    for (final method in operations.keys.toList()) {
      final op = operations[method] as Map<String, dynamic>;
      final content = (op['requestBody'] as Map<String, dynamic>?)?['content'] as Map<String, dynamic>?;
      if (content != null && content.containsKey('multipart/form-data')) {
        removed.add('${method.toUpperCase()} ${entry.key} (${op['operationId']})');
        operations.remove(method);
      }
    }
    if (operations.isEmpty) paths.remove(entry.key);
  }

  target.writeAsStringSync('${const JsonEncoder.withIndent('  ').convert(doc)}\n');
  stdout.writeln('openapi: ${paths.length} paths → ${target.path}');
  for (final r in removed) {
    stdout.writeln('  multipart excluído (escrito à mão): $r');
  }
}
