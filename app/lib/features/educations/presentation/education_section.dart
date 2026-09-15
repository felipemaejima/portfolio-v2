import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/async_value_view.dart';
import '../../../core/ui/breakpoints.dart';
import '../../../core/ui/periods.dart';
import '../../../core/ui/section.dart';
import '../../../core/ui/theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/educations_provider.dart';

/// "Formação": período à esquerda, curso/instituição à direita.
class EducationSection extends ConsumerWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Section(
      title: l10n.navEducation,
      child: AsyncValueView(
        value: ref.watch(educationsProvider),
        onRetry: () => ref.invalidate(educationsProvider),
        data: (items) => items.isEmpty
            ? Text(l10n.emptyList)
            : Column(
                children: [
                  for (final e in items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Builder(builder: (context) {
                        final period = Text(
                          formatEducationPeriod(e.startYear, e.endYear, current: l10n.periodCurrent),
                          style: text.bodySmall?.copyWith(color: AppColors.neutral500),
                        );
                        final body = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.courseName, style: text.titleMedium),
                            Text(e.institution, style: text.bodyMedium?.copyWith(color: AppColors.neutral400)),
                          ],
                        );
                        return Breakpoints.isWide(context)
                            ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 180, child: period), Expanded(child: body)])
                            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [period, const SizedBox(height: 6), body]);
                      }),
                    ),
                ],
              ),
      ),
    );
  }
}
