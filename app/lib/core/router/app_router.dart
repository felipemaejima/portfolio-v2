import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin_shell/presentation/admin_dashboard_page.dart';
import '../../features/admin_shell/presentation/admin_shell_page.dart';
import '../../features/admin_shell/presentation/login_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/profile/presentation/admin/profile_form_page.dart';
import '../auth/auth_notifier.dart';
import '../auth/auth_state.dart';

/// Rotas (APP.md §5). `/admin/**` exige sessão; `/admin/login` com sessão volta ao painel.
final routerProvider = Provider<GoRouter>((ref) {
  final authChanged = _AuthChanged();
  ref.listen(authProvider, (_, _) => authChanged.ping());
  ref.onDispose(authChanged.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authChanged,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      if (auth.isLoading) return null; // splash cobre; ver app.dart
      final loggedIn = auth.value is Authenticated;
      final location = state.matchedLocation;
      final isLogin = location == '/admin/login';
      final isAdmin = location.startsWith('/admin');

      if (isAdmin && !isLogin && !loggedIn) {
        return Uri(path: '/admin/login', queryParameters: {'from': state.uri.toString()}).toString();
      }
      if (isLogin && loggedIn) {
        return state.uri.queryParameters['from'] ?? '/admin';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const HomePage()),
      GoRoute(path: '/admin/login', builder: (_, _) => const LoginPage()),
      ShellRoute(
        builder: (_, _, child) => AdminShellPage(child: child),
        routes: [
          GoRoute(path: '/admin', builder: (_, _) => const AdminDashboardPage()),
          GoRoute(path: '/admin/profile', builder: (_, _) => const ProfileFormPage()),
        ],
      ),
    ],
  );
});

class _AuthChanged extends ChangeNotifier {
  void ping() => notifyListeners();
}
