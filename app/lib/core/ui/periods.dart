/// Formatação de períodos (APP.md §6), espelhando o CV da API.
const _months = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];
const _dash = ' — ';

/// `2023-01` → `jan/2023`.
String formatYearMonth(String value) {
  final parts = value.split('-');
  if (parts.length != 2) return value;
  final month = int.tryParse(parts[1]);
  final name = month != null && month >= 1 && month <= 12 ? _months[month - 1] : parts[1];
  return '$name/${parts[0]}';
}

/// `jan/2023 — atual`, `mar/2021 — dez/2022`.
String formatExperiencePeriod(String start, String? end, {required String current}) =>
    '${formatYearMonth(start)}$_dash${end == null ? current : formatYearMonth(end)}';

/// `2017 — 2021`, `2024 — atual`, ou `2023` quando início = fim.
String formatEducationPeriod(int start, int? end, {required String current}) {
  if (end == null) return '$start$_dash$current';
  if (end == start) return '$start';
  return '$start$_dash$end';
}
