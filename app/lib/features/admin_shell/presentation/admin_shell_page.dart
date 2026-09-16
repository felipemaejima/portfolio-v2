import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_notifier.dart';
import '../../../core/auth/auth_state.dart';
import '../../../core/ui/breakpoints.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'admin_destinations.dart';

/// Layout do painel (APP.md §5): rail lateral no web/desktop, barra inferior no mobile.
class AdminShellPage extends ConsumerWidget {
  const AdminShellPage({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authProvider).value;
    final email = auth is Authenticated ? auth.admin.email : '';
    final wide = Breakpoints.isWide(context);
    final items = adminDestinations(l10n);
    final selected = selectedDestination(items, GoRouterState.of(context).matchedLocation);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminTitle),
        actions: [
          if (email.isNotEmpty && wide) Padding(padding: const EdgeInsets.only(right: 12), child: Center(child: Text(email))),
          if (kIsWeb) IconButton(tooltip: l10n.homeLink, icon: const Icon(Icons.public), onPressed: () => context.go('/')),
          IconButton(tooltip: l10n.logout, icon: const Icon(Icons.logout), onPressed: () => ref.read(authProvider.notifier).logout()),
        ],
      ),
      body: wide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: selected,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: (i) => context.go(items[i].path),
                  destinations: [for (final d in items) NavigationRailDestination(icon: Icon(d.icon), label: Text(d.label))],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            )
          : child,
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: selected,
              onDestinationSelected: (i) => context.go(items[i].path),
              destinations: [for (final d in items) NavigationDestination(icon: Icon(d.icon), label: d.label)],
            ),
    );
  }
}
