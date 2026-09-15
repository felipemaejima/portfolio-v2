import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_app/core/auth/access_token.dart';
import 'package:portfolio_app/core/auth/auth_notifier.dart';
import 'package:portfolio_app/core/auth/auth_repository.dart';
import 'package:portfolio_app/core/auth/auth_state.dart';
import 'package:portfolio_app/core/auth/token_store.dart';
import 'package:portfolio_app/core/errors/api_failure.dart';

import '../../support/fakes.dart';

({ProviderContainer container, FakeAuthRepository repo, InMemoryTokenStore store}) setUp_({String? storedRefresh}) {
  final repo = FakeAuthRepository();
  final store = InMemoryTokenStore(storedRefresh);
  final container = ProviderContainer.test(
    overrides: [
      authRepositoryProvider.overrideWithValue(repo),
      tokenStoreProvider.overrideWithValue(store),
    ],
  );
  return (container: container, repo: repo, store: store);
}

void main() {
  group('boot (mobile: refresh vem do store)', () {
    test('sem refresh guardado → Anonymous sem chamar a API', () async {
      final t = setUp_();
      final state = await t.container.read(authProvider.future);
      expect(state, isA<Anonymous>());
      expect(t.repo.refreshCalls, 0);
    });

    test('com refresh guardado → rotaciona, guarda o novo e carrega me', () async {
      final t = setUp_(storedRefresh: 'refresh-0');
      final state = await t.container.read(authProvider.future);
      expect(state, isA<Authenticated>());
      expect((state as Authenticated).admin.email, 'admin@example.com');
      expect(t.repo.refreshCalls, 1);
      expect(t.store.refresh, 'refresh-1');
      expect(t.container.read(accessTokenProvider).value, 'access-1');
    });

    test('refresh recusado → Anonymous e store limpo', () async {
      final t = setUp_(storedRefresh: 'velho');
      t.repo.refreshFails = true;
      final state = await t.container.read(authProvider.future);
      expect(state, isA<Anonymous>());
      expect(t.store.refresh, isNull);
      expect(t.container.read(accessTokenProvider).value, isNull);
    });
  });

  test('login → Authenticated; logout revoga com o refresh do store e limpa tudo', () async {
    final t = setUp_();
    await t.container.read(authProvider.future);
    final notifier = t.container.read(authProvider.notifier);

    await notifier.login('admin@example.com', 'senha');
    expect(t.container.read(authProvider).value, isA<Authenticated>());
    expect(t.store.refresh, 'refresh-1');

    await notifier.logout();
    expect(t.container.read(authProvider).value, isA<Anonymous>());
    expect(t.repo.logoutCalledWith, 'refresh-1');
    expect(t.store.refresh, isNull);
    expect(t.container.read(accessTokenProvider).value, isNull);
  });

  test('login com credenciais erradas propaga ApiUnauthenticated e mantém Anonymous', () async {
    final t = setUp_();
    await t.container.read(authProvider.future);
    t.repo.loginFails = true;
    await expectLater(
      t.container.read(authProvider.notifier).login('x', 'y'),
      throwsA(isA<ApiUnauthenticated>()),
    );
    expect(t.container.read(authProvider).value, isA<Anonymous>());
  });

  test('refreshAccessToken é single-flight: chamadas concorrentes compartilham uma request', () async {
    final t = setUp_(storedRefresh: 'refresh-0');
    await t.container.read(authProvider.future);
    t.repo.refreshCalls = 0;
    t.repo.refreshDelay = const Duration(milliseconds: 20);
    final notifier = t.container.read(authProvider.notifier);

    final results = await Future.wait([notifier.refreshAccessToken(), notifier.refreshAccessToken(), notifier.refreshAccessToken()]);
    expect(t.repo.refreshCalls, 1);
    expect(results.toSet(), {'access-2'});
  });

  test('refresh falhando com sessão ativa derruba para Anonymous', () async {
    final t = setUp_(storedRefresh: 'refresh-0');
    await t.container.read(authProvider.future);
    t.repo.refreshFails = true;
    final token = await t.container.read(authProvider.notifier).refreshAccessToken();
    expect(token, isNull);
    expect(t.container.read(authProvider).value, isA<Anonymous>());
  });
}
