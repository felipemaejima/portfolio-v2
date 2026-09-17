import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/models/project_dto.dart';
import '../../../core/config/app_config.dart';
import '../../../core/ui/section.dart';
import '../../../core/ui/theme.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Card do grid (layout de referência): capa, nome, descrição curta, chips, links.
class ProjectCard extends StatelessWidget {
  const ProjectCard({required this.project, super.key});
  final ProjectDto project;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final cover = project.images.isEmpty ? null : project.images.first.url;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: InkWell(
        onTap: () => context.go('/projects/${project.slug}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: cover == null
                  ? const ColoredBox(
                      color: AppColors.surface2,
                      child: Icon(
                        Icons.image_outlined,
                        color: AppColors.neutral600,
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: AppConfig.resolve(cover),
                      fit: BoxFit.cover,
                      placeholder: (_, _) =>
                          const ColoredBox(color: AppColors.surface2),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.name, style: text.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    project.shortDescription,
                    style: text.bodySmall?.copyWith(
                      color: AppColors.neutral400,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final t in project.technologies.take(4)) TagChip(t),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (project.codeUrl case final url?)
                        _Link(l10n.projectCode, url),
                      if (project.demoUrl case final url?)
                        _Link(l10n.projectDemo, url),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Link extends StatelessWidget {
  const _Link(this.label, this.url);
  final String label;
  final String url;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () =>
        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      minimumSize: Size.zero,
    ),
    child: Text(label, style: const TextStyle(color: AppColors.accent300)),
  );
}

/// Grid responsivo de cards: 3 colunas no desktop, 2 no tablet, 1 no mobile.
class ProjectsGrid extends StatelessWidget {
  const ProjectsGrid({required this.projects, super.key});
  final List<ProjectDto> projects;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1100 ? 3 : (width >= 700 ? 2 : 1);
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 24.0;
        final cardWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final p in projects)
              SizedBox(
                width: cardWidth,
                child: ProjectCard(project: p),
              ),
          ],
        );
      },
    );
  }
}
