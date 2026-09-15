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
    // Um único MaterialApp.router desde o primeiro frame: o GoRouter precisa
    // ser criado enquanto a URL inicial do browser ainda é a rota padrão.
    // Durante o boot da sessão (estado `unknown`) o builder mostra a splash e
    // não insere o filho na árvore — nenhuma página busca dados sem sessão.
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: buildTheme(),
      supportedLocales: const [Locale('pt')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        final auth = ref.watch(authProvider);
        if (auth.isLoading && !auth.hasValue) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return child!;
      },
    );
  }
}
