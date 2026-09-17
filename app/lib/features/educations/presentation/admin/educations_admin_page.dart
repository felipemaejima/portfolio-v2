import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/admin_page.dart';
import '../../../../core/ui/async_value_view.dart';
import '../../../../core/ui/failure_text.dart';
import '../../../../core/ui/periods.dart';
import '../../../../core/ui/theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/educations_provider.dart';

class EducationsAdminPage extends ConsumerWidget {
  const EducationsAdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AdminPage(
      title: l10n.navEducation,
      actions: [
        FilledButton.icon(
          onPressed: () => context.go('/admin/educations/new'),
          icon: const Icon(Icons.add),
          label: Text(l10n.newItem),
        ),
      ],
      child: AsyncValueView(
        value: ref.watch(educationsProvider),
        onRetry: () => ref.invalidate(educationsProvider),
        data: (items) => items.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(l10n.emptyList),
                ),
              )
            : Column(
                children: [
                  for (final e in items)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('${e.courseName} · ${e.institution}'),
                      subtitle: Text(
                        formatEducationPeriod(
                          e.startYear,
                          e.endYear,
                          current: l10n.periodCurrent,
                        ),
                        style: const TextStyle(color: AppColors.neutral500),
                      ),
                      onTap: () => context.go('/admin/educations/${e.id}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          if (!await confirm(
                            context,
                            title: l10n.confirmDelete,
                            confirmLabel: l10n.delete,
                            cancelLabel: l10n.cancel,
                          )) {
                            return;
                          }
                          try {
                            await ref
                                .read(educationsEditorProvider)
                                .delete(e.id);
                          } on Object catch (err) {
                            if (context.mounted) {
                              notify(
                                context,
                                failureText(l10n, err),
                                error: true,
                              );
                            }
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
