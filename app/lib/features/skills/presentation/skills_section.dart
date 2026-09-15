import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/async_value_view.dart';
import '../../../core/ui/section.dart';
import '../../../core/ui/theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/skills_provider.dart';

/// "Habilidades": categorias em colunas (4 no desktop), skills como chips.
class SkillsSection extends ConsumerWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Section(
      title: l10n.navSkills,
      child: AsyncValueView(
        value: ref.watch(skillCategoriesProvider),
        onRetry: () => ref.invalidate(skillCategoriesProvider),
        data: (categories) {
          final visible = categories.where((c) => c.skills.isNotEmpty).toList();
          if (visible.isEmpty) return Text(l10n.emptyList);
          return LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1000 ? 4 : (constraints.maxWidth >= 600 ? 2 : 1);
              const gap = 32.0;
              final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final c in visible)
                    SizedBox(
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.accent300, letterSpacing: 1.2),
                          ),
                          const SizedBox(height: 12),
                          Wrap(spacing: 8, runSpacing: 8, children: [for (final s in c.skills) TagChip(s.name)]),
                        ],
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
