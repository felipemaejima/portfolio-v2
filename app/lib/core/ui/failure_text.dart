import '../../l10n/generated/app_localizations.dart';
import '../errors/api_failure.dart';

/// Texto exibível para uma falha: a API já manda PT-BR; rede e inesperado
/// vêm do ARB.
String failureText(AppLocalizations l10n, Object error) =>
    switch (ApiFailure.from(error)) {
      ApiNetwork() => l10n.errorNetwork,
      ApiRateLimited() => l10n.errorRateLimited,
      ApiUnexpected() => l10n.errorUnexpected,
      final ApiFailure f => f.message,
    };
