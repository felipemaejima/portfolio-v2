import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin_shell/presentation/admin_dashboard_page.dart';
import '../../features/admin_shell/presentation/admin_shell_page.dart';
import '../../features/admin_shell/presentation/login_page.dart';
import '../../features/contact/presentation/admin/contact_links_admin_page.dart';
import '../../features/contact/presentation/admin/messages_admin_page.dart';
import '../../features/contact/presentation/contact_page.dart';
import '../../features/educations/presentation/admin/education_form_page.dart';
import '../../features/educations/presentation/admin/educations_admin_page.dart';
import '../../features/experiences/presentation/admin/experience_form_page.dart';
import '../../features/experiences/presentation/admin/experiences_admin_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/offerings/presentation/admin/offerings_admin_page.dart';
import '../../features/profile/presentation/admin/profile_form_page.dart';
import '../../features/projects/presentation/admin/project_form_page.dart';
import '../../features/projects/presentation/admin/projects_admin_page.dart';
import '../../features/projects/presentation/project_detail_page.dart';
import '../../features/projects/presentation/projects_page.dart';
import '../../features/skills/presentation/admin/skills_admin_page.dart';
import '../auth/auth_notifier.dart';
import '../auth/auth_state.dart';

/// Rotas (APP.md §5). `/admin/**` exige sessão; `/admin/login` com sessão volta ao painel.
/// No mobile o app é só o painel: abre em `/admin` e as rotas públicas redirecionam para lá.
final routerProvider = Provider<GoRouter>((ref) {
  final authChanged = _AuthChanged();
  ref.listen(authProvider, (_, _) => authChanged.ping());
  ref.onDispose(authChanged.dispose);

  return GoRouter(
    initialLocation: kIsWeb ? '/' : '/admin',
    refreshListenable: authChanged,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      if (auth.isLoading) return null; // splash cobre; ver app.dart
      final loggedIn = auth.value is Authenticated;
      final location = state.matchedLocation;
      final isLogin = location == '/admin/login';
      final isAdmin = location.startsWith('/admin');

      if (!kIsWeb && !isAdmin) return '/admin';

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
      GoRoute(path: '/projects', builder: (_, _) => const ProjectsPage()),
      GoRoute(path: '/contact', builder: (_, _) => const ContactPage()),
      GoRoute(path: '/projects/:slug', builder: (_, state) => ProjectDetailPage(slug: state.pathParameters['slug']!)),
      GoRoute(path: '/admin/login', builder: (_, _) => const LoginPage()),
      ShellRoute(
        builder: (_, _, child) => AdminShellPage(child: child),
        routes: [
          GoRoute(path: '/admin', builder: (_, _) => const AdminDashboardPage()),
          GoRoute(path: '/admin/profile', builder: (_, _) => const ProfileFormPage()),
          GoRoute(path: '/admin/projects', builder: (_, _) => const ProjectsAdminPage()),
          GoRoute(path: '/admin/projects/new', builder: (_, _) => const ProjectFormPage()),
          GoRoute(path: '/admin/projects/:id', builder: (_, state) => ProjectFormPage(id: state.pathParameters['id'])),
          GoRoute(path: '/admin/skills', builder: (_, _) => const SkillsAdminPage()),
          GoRoute(path: '/admin/experiences', builder: (_, _) => const ExperiencesAdminPage()),
          GoRoute(path: '/admin/experiences/new', builder: (_, _) => const ExperienceFormPage()),
          GoRoute(path: '/admin/experiences/:id', builder: (_, state) => ExperienceFormPage(id: state.pathParameters['id'])),
          GoRoute(path: '/admin/educations', builder: (_, _) => const EducationsAdminPage()),
          GoRoute(path: '/admin/educations/new', builder: (_, _) => const EducationFormPage()),
          GoRoute(path: '/admin/educations/:id', builder: (_, state) => EducationFormPage(id: state.pathParameters['id'])),
          GoRoute(path: '/admin/offerings', builder: (_, _) => const OfferingsAdminPage()),
          GoRoute(path: '/admin/contact-links', builder: (_, _) => const ContactLinksAdminPage()),
          GoRoute(path: '/admin/messages', builder: (_, _) => const MessagesAdminPage()),
        ],
      ),
    ],
  );
});

class _AuthChanged extends ChangeNotifier {
  void ping() => notifyListeners();
}
