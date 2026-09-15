import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_notifier.dart';
import '../../../core/auth/auth_state.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Layout do painel (APP.md §5): nav lateral no web/desktop, bottom nav no mobile.
/// Os destinos entram conforme as features chegam.
class AdminShellPage extends ConsumerWidget {
  const AdminShellPage({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final admin = ref.watch(authProvider).value;
    final email = admin is Authenticated ? admin.admin.email : '';
    final wide = MediaQuery.sizeOf(context).width >= 900;

    final body = Row(
      children: [
        if (wide)
          NavigationRail(
            selectedIndex: 0,
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(icon: const Icon(Icons.dashboard_outlined), label: Text(l10n.adminTitle)),
            ],
            onDestinationSelected: (_) => context.go('/admin'),
          ),
        Expanded(child: child),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminTitle),
        actions: [
          if (email.isNotEmpty) Padding(padding: const EdgeInsets.only(right: 12), child: Center(child: Text(email))),
          IconButton(
            tooltip: l10n.logout,
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: body,
    );
  }
}
