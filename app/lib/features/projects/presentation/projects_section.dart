import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui/async_value_view.dart';
import '../../../core/ui/section.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/projects_provider.dart';
import 'project_card.dart';

const _homeLimit = 6;

/// Seção "Projetos" da home: os primeiros 6 por position + "Ver todos".
class ProjectsSection extends ConsumerWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Section(
      title: l10n.navProjects,
      child: AsyncValueView(
        value: ref.watch(projectsProvider),
        onRetry: () => ref.invalidate(projectsProvider),
        data: (projects) {
          if (projects.isEmpty) return Text(l10n.emptyList);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProjectsGrid(projects: projects.take(_homeLimit).toList()),
              if (projects.length > _homeLimit) ...[
                const SizedBox(height: 24),
                Center(child: OutlinedButton(onPressed: () => context.go('/projects'), child: Text(l10n.projectsSeeAll))),
              ],
            ],
          );
        },
      ),
    );
  }
}
