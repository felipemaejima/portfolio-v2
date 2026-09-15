import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui/async_value_view.dart';
import '../../../core/ui/breakpoints.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/projects_provider.dart';
import 'project_card.dart';

/// `/projects`: todos, por position.
class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/')),
        title: Text(l10n.navProjects),
      ),
      body: SingleChildScrollView(
        padding: Breakpoints.pagePadding(context),
        child: AsyncValueView(
          value: ref.watch(projectsProvider),
          onRetry: () => ref.invalidate(projectsProvider),
          data: (projects) => projects.isEmpty ? Text(l10n.emptyList) : ProjectsGrid(projects: projects),
        ),
      ),
    );
  }
}
