import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/models/project_dto.dart';
import '../../../core/ui/async_value_view.dart';
import '../../../core/ui/breakpoints.dart';
import '../../../core/ui/section.dart';
import '../../../core/ui/theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/projects_provider.dart';

/// `/projects/:slug`: descrição completa, tecnologias, links e galeria.
class ProjectDetailPage extends ConsumerWidget {
  const ProjectDetailPage({required this.slug, super.key});
  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(projectBySlugProvider(slug));
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/')),
        title: Text(value.value?.name ?? ''),
      ),
      body: SingleChildScrollView(
        padding: Breakpoints.pagePadding(context),
        child: AsyncValueView(
          value: value,
          onRetry: () => ref.invalidate(projectBySlugProvider(slug)),
          data: (p) => _Detail(project: p),
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.project});
  final ProjectDto project;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final paragraphs = project.fullDescription.split(RegExp(r'\n\s*\n')).where((s) => s.trim().isNotEmpty);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.name, style: text.headlineMedium),
          const SizedBox(height: 8),
          Text(project.shortDescription, style: text.bodyLarge?.copyWith(color: AppColors.neutral300)),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: [for (final t in project.technologies) TagChip(t)]),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: [
              if (project.codeUrl case final url?) OutlinedButton(onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication), child: Text(l10n.projectCode)),
              if (project.demoUrl case final url?) FilledButton(onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication), child: Text(l10n.projectDemo)),
            ],
          ),
          if (project.images.isNotEmpty) ...[
            const SizedBox(height: 32),
            for (final img in project.images)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(imageUrl: img.url, fit: BoxFit.contain, placeholder: (_, _) => const AspectRatio(aspectRatio: 16 / 9, child: ColoredBox(color: AppColors.surface))),
                ),
              ),
          ],
          const SizedBox(height: 16),
          for (final p in paragraphs) ...[
            Text(p.trim(), style: text.bodyMedium?.copyWith(color: AppColors.neutral300, height: 1.7)),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
