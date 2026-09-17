import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../api/models/project_dto.dart';
import '../../../../core/ui/admin_page.dart';
import '../../../../core/ui/async_value_view.dart';
import '../../../../core/ui/failure_text.dart';
import '../../../../core/ui/reorderable_admin_list.dart';
import '../../../../core/ui/theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/projects_provider.dart';

class ProjectsAdminPage extends ConsumerWidget {
  const ProjectsAdminPage({super.key});

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    ProjectDto p,
  ) async {
    final l10n = AppLocalizations.of(context);
    if (!await confirm(
      context,
      title: l10n.confirmDelete,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
    )) {
      return;
    }
    try {
      await ref.read(projectsEditorProvider).delete(p.id);
    } on Object catch (e) {
      if (context.mounted) notify(context, failureText(l10n, e), error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AdminPage(
      title: l10n.navProjects,
      actions: [
        FilledButton.icon(
          onPressed: () => context.go('/admin/projects/new'),
          icon: const Icon(Icons.add),
          label: Text(l10n.newItem),
        ),
      ],
      child: AsyncValueView(
        value: ref.watch(projectsProvider),
        onRetry: () => ref.invalidate(projectsProvider),
        data: (projects) => ReorderableAdminList<ProjectDto>(
          items: projects,
          idOf: (p) => p.id,
          onReorder: ref.read(projectsEditorProvider).reorder,
          itemBuilder: (context, p) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: AppColors.surface2,
              child: Text('${p.images.length}'),
            ),
            title: Text(p.name),
            subtitle: Text(
              '/${p.slug}',
              style: const TextStyle(color: AppColors.neutral500),
            ),
            onTap: () => context.go('/admin/projects/${p.id}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.delete,
              onPressed: () => _delete(context, ref, p),
            ),
          ),
        ),
      ),
    );
  }
}
