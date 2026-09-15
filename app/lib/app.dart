import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/auth/auth_notifier.dart';
import 'core/router/app_router.dart';
import 'core/ui/theme.dart';
import 'l10n/generated/app_localizations.dart';

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final theme = buildTheme();
    const locales = [Locale('pt')];
    const delegates = [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];

    // Estado `unknown` (boot da sessão): splash antes de qualquer rota decidir.
    if (auth.isLoading && !auth.hasValue) {
      return MaterialApp(
        theme: theme,
        supportedLocales: locales,
        localizationsDelegates: delegates,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: theme,
      supportedLocales: locales,
      localizationsDelegates: delegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
