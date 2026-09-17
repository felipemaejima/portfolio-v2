import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/experience_dto.dart';
import '../../../core/ui/async_value_view.dart';
import '../../../core/ui/breakpoints.dart';
import '../../../core/ui/periods.dart';
import '../../../core/ui/section.dart';
import '../../../core/ui/theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/experiences_provider.dart';

/// "Experiência profissional": período à esquerda, cargo/empresa/bullets à direita.
class ExperienceSection extends ConsumerWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Section(
      title: l10n.experienceTitle,
      child: AsyncValueView(
        value: ref.watch(experiencesProvider),
        onRetry: () => ref.invalidate(experiencesProvider),
        data: (items) => items.isEmpty
            ? Text(l10n.emptyList)
            : Column(children: [for (final e in items) _Entry(experience: e)]),
      ),
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry({required this.experience});
  final ExperienceDto experience;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final period = Text(
      formatExperiencePeriod(
        experience.startDate,
        experience.endDate,
        current: l10n.periodCurrent,
      ),
      style: text.bodySmall?.copyWith(color: AppColors.neutral500),
    );
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(experience.role, style: text.titleMedium),
        Text(
          experience.companyName,
          style: text.bodyMedium?.copyWith(color: AppColors.neutral400),
        ),
        const SizedBox(height: 8),
        for (final a in experience.activities)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '•  ',
                  style: TextStyle(color: AppColors.neutral500),
                ),
                Expanded(
                  child: Text(
                    a,
                    style: text.bodyMedium?.copyWith(
                      color: AppColors.neutral300,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Breakpoints.isWide(context)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 180, child: period),
                Expanded(child: body),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [period, const SizedBox(height: 6), body],
            ),
    );
  }
}
