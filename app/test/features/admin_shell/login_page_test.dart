import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_app/core/auth/auth_repository.dart';
import 'package:portfolio_app/core/auth/token_store.dart';
import 'package:portfolio_app/features/admin_shell/presentation/login_page.dart';
import 'package:portfolio_app/l10n/generated/app_localizations.dart';

import '../../support/fakes.dart';

Widget _app(FakeAuthRepository repo) => ProviderScope(
  overrides: [
    authRepositoryProvider.overrideWithValue(repo),
    tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
  ],
  child: const MaterialApp(
    supportedLocales: [Locale('pt')],
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: LoginPage(),
  ),
);

void main() {
  testWidgets('campos vazios não chamam a API', (tester) async {
    final repo = FakeAuthRepository();
    await tester.pumpWidget(_app(repo));
    await tester
        .pumpAndSettle(); // boot da sessão (Anonymous) antes do formulário aparecer
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(find.text('Obrigatório'), findsNWidgets(2));
    expect(repo.loginCalls, 0);
  });

  testWidgets('401 mostra a mensagem da API', (tester) async {
    final repo = FakeAuthRepository()..loginFails = true;
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'admin@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'errada');
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.text('E-mail ou senha inválidos.'), findsOneWidget);
    expect(repo.loginCalls, 1);
  });

  testWidgets('login válido chama a API uma vez', (tester) async {
    final repo = FakeAuthRepository();
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'admin@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'senha');
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(repo.loginCalls, 1);
    expect(find.text('E-mail ou senha inválidos.'), findsNothing);
  });
}
