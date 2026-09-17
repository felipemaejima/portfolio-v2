import '../../api/models/availability.dart';
import '../../api/models/language_level.dart';
import '../../api/models/work_mode.dart';
import '../../l10n/generated/app_localizations.dart';

/// Rótulos PT dos enums do contrato (APP.md §6). A API nunca envia rótulo.
extension AvailabilityLabel on Availability {
  String label(AppLocalizations l10n) => switch (this) {
    Availability.clt => l10n.availabilityClt,
    Availability.pj => l10n.availabilityPj,
    Availability.freelance => l10n.availabilityFreelance,
    Availability.contract => l10n.availabilityContract,
    Availability.$unknown => '?',
  };
}

extension WorkModeLabel on WorkMode {
  String label(AppLocalizations l10n) => switch (this) {
    WorkMode.remote => l10n.workModeRemote,
    WorkMode.hybrid => l10n.workModeHybrid,
    WorkMode.onSite => l10n.workModeOnSite,
    WorkMode.$unknown => '?',
  };
}

extension LanguageLevelLabel on LanguageLevel {
  String label(AppLocalizations l10n) => switch (this) {
    LanguageLevel.basic => l10n.languageLevelBasic,
    LanguageLevel.intermediate => l10n.languageLevelIntermediate,
    LanguageLevel.advanced => l10n.languageLevelAdvanced,
    LanguageLevel.fluent => l10n.languageLevelFluent,
    LanguageLevel.native => l10n.languageLevelNative,
    LanguageLevel.$unknown => '?',
  };
}

/// "CLT e freelance", "Remoto / híbrido" — listas curtas em prosa.
String joinLabels(
  Iterable<String> labels, {
  String separator = ', ',
  String last = ' e ',
}) {
  final list = labels.toList();
  if (list.isEmpty) return '';
  if (list.length == 1) return list.first;
  return '${list.sublist(0, list.length - 1).join(separator)}$last${list.last}';
}
