import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';

/// Placeholder da fase 0; a home real chega com as features (APP.md §9).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.homePlaceholder, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TextButton(onPressed: () => context.go('/admin'), child: Text(l10n.adminTitle)),
          ],
        ),
      ),
    );
  }
}
