import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_app/api/models/contact_link_dto.dart';
import 'package:portfolio_app/api/models/contact_link_input_dto.dart';
import 'package:portfolio_app/api/models/contact_message_dto.dart';
import 'package:portfolio_app/api/models/create_contact_message_dto.dart';
import 'package:portfolio_app/core/errors/api_failure.dart';
import 'package:portfolio_app/features/contact/data/contact_repository.dart';
import 'package:portfolio_app/features/contact/presentation/contact_form.dart';
import 'package:portfolio_app/l10n/generated/app_localizations.dart';

class _FakeContactRepository implements ContactRepository {
  ApiFailure? fail;
  CreateContactMessageDto? sent;

  @override
  Future<void> sendMessage(CreateContactMessageDto body) async {
    if (fail != null) throw fail!;
    sent = body;
  }

  @override
  Future<List<ContactLinkDto>> listLinks() async => [];
  @override
  Future<ContactLinkDto> createLink(ContactLinkInputDto body) =>
      throw UnimplementedError();
  @override
  Future<ContactLinkDto> updateLink(String id, ContactLinkInputDto body) =>
      throw UnimplementedError();
  @override
  Future<void> deleteLink(String id) => throw UnimplementedError();
  @override
  Future<void> reorderLinks(List<String> ids) => throw UnimplementedError();
  @override
  Future<List<ContactMessageDto>> listMessages() => throw UnimplementedError();
  @override
  Future<ContactMessageDto> markRead(String id) => throw UnimplementedError();
  @override
  Future<void> deleteMessage(String id) => throw UnimplementedError();
}

Widget _app(_FakeContactRepository repo) => ProviderScope(
  overrides: [contactRepositoryProvider.overrideWithValue(repo)],
  child: const MaterialApp(
    supportedLocales: [Locale('pt')],
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(body: SingleChildScrollView(child: ContactForm())),
  ),
);

Future<void> _fill(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).at(0), 'Maria');
  await tester.enterText(find.byType(TextField).at(1), 'maria@example.com');
  await tester.enterText(find.byType(TextField).at(2), 'Olá!');
  await tester.tap(find.byType(FilledButton));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('envio ok mostra confirmação com o que foi digitado', (
    tester,
  ) async {
    final repo = _FakeContactRepository();
    await tester.pumpWidget(_app(repo));
    await _fill(tester);
    expect(repo.sent?.email, 'maria@example.com');
    expect(find.text('Mensagem enviada. Obrigado!'), findsOneWidget);
  });

  testWidgets('422 mostra o erro no campo certo', (tester) async {
    final repo = _FakeContactRepository()
      ..fail = const ApiValidation('Dados inválidos.', {
        'email': ['deve ser um e-mail válido'],
      });
    await tester.pumpWidget(_app(repo));
    await _fill(tester);
    expect(find.text('deve ser um e-mail válido'), findsOneWidget);
    expect(find.text('Mensagem enviada. Obrigado!'), findsNothing);
  });

  testWidgets('429 mostra a mensagem amigável', (tester) async {
    final repo = _FakeContactRepository()
      ..fail = const ApiRateLimited('Muitas tentativas.');
    await tester.pumpWidget(_app(repo));
    await _fill(tester);
    expect(
      find.text('Muitas tentativas. Aguarde um instante.'),
      findsOneWidget,
    );
  });
}
