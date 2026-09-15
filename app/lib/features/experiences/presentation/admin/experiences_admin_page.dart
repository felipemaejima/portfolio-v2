import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/admin_page.dart';
import '../../../../core/ui/async_value_view.dart';
import '../../../../core/ui/failure_text.dart';
import '../../../../core/ui/periods.dart';
import '../../../../core/ui/theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/experiences_provider.dart';

class ExperiencesAdminPage extends ConsumerWidget {
  const ExperiencesAdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AdminPage(
      title: l10n.experienceTitle,
      actions: [FilledButton.icon(onPressed: () => context.go('/admin/experiences/new'), icon: const Icon(Icons.add), label: Text(l10n.newItem))],
      child: AsyncValueView(
        value: ref.watch(experiencesProvider),
        onRetry: () => ref.invalidate(experiencesProvider),
        data: (items) => items.isEmpty
            ? Center(child: Padding(padding: const EdgeInsets.all(32), child: Text(l10n.emptyList)))
            : Column(
                children: [
                  for (final e in items)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('${e.role} · ${e.companyName}'),
                      subtitle: Text(formatExperiencePeriod(e.startDate, e.endDate, current: l10n.periodCurrent), style: const TextStyle(color: AppColors.neutral500)),
                      onTap: () => context.go('/admin/experiences/${e.id}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          if (!await confirm(context, title: l10n.confirmDelete, confirmLabel: l10n.delete, cancelLabel: l10n.cancel)) return;
                          try {
                            await ref.read(experiencesEditorProvider).delete(e.id);
                          } on Object catch (err) {
                            if (context.mounted) notify(context, failureText(l10n, err), error: true);
                          }
                        },
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
