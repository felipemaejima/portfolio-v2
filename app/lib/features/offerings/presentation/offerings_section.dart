import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/async_value_view.dart';
import '../../../core/ui/section.dart';
import '../../../core/ui/theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/offerings_provider.dart';

/// "Serviços": cards com título + descrição, 4/2/1 colunas.
class OfferingsSection extends ConsumerWidget {
  const OfferingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Section(
      title: l10n.navOfferings,
      child: AsyncValueView(
        value: ref.watch(offeringsProvider),
        onRetry: () => ref.invalidate(offeringsProvider),
        data: (items) {
          if (items.isEmpty) return Text(l10n.emptyList);
          return LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1000
                  ? 4
                  : (constraints.maxWidth >= 600 ? 2 : 1);
              const gap = 20.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final o in items)
                    SizedBox(
                      width: width,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(o.title, style: text.titleMedium),
                            const SizedBox(height: 8),
                            Text(
                              o.description,
                              style: text.bodySmall?.copyWith(
                                color: AppColors.neutral400,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
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
