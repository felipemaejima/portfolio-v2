import 'package:flutter/material.dart';

import 'breakpoints.dart';
import 'theme.dart';

/// Uma seção da home: título opcional, padding responsivo e divisor.
class Section extends StatelessWidget {
  const Section({required this.child, this.title, this.divider = true, super.key});

  final String? title;
  final Widget child;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (divider) const _GradientDivider(),
        Padding(
          padding: Breakpoints.pagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(title!, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 28),
              ],
              child,
            ],
          ),
        ),
      ],
    );
  }
}

class _GradientDivider extends StatelessWidget {
  const _GradientDivider();

  @override
  Widget build(BuildContext context) {
    final inset = Breakpoints.isWide(context) ? 64.0 : 20.0;
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: inset),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, AppColors.divider, AppColors.divider, Colors.transparent],
          stops: [0, 0.08, 0.92, 1],
        ),
      ),
    );
  }
}

/// Rótulo pequeno em caixa alta acima de um valor (grid do "Sobre").
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.neutral500, letterSpacing: 1.2),
      );
}

/// Chip de texto (skills, tecnologias).
class TagChip extends StatelessWidget {
  const TagChip(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(6)),
        child: Text(text, style: Theme.of(context).textTheme.bodySmall),
      );
}
