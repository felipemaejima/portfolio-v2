import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/models/contact_link_dto.dart';
import '../../../core/ui/async_value_view.dart';
import '../../../core/ui/breakpoints.dart';
import '../../../core/ui/section.dart';
import '../../../core/ui/theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/contact_provider.dart';
import 'contact_form.dart';

/// "Contato": intro + canais à esquerda, formulário à direita.
class ContactSection extends ConsumerWidget {
  const ContactSection({this.intro, this.divider = true, super.key});
  final String? intro;
  final bool divider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.navContact, style: text.headlineSmall),
        if (intro case final s? when s.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            s,
            style: text.bodyMedium?.copyWith(
              color: AppColors.neutral300,
              height: 1.6,
            ),
          ),
        ],
        const SizedBox(height: 24),
        AsyncValueView(
          value: ref.watch(contactLinksProvider),
          compact: true,
          onRetry: () => ref.invalidate(contactLinksProvider),
          data: (links) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [for (final l in links) _LinkRow(link: l)],
          ),
        ),
      ],
    );
    const right = ContactForm();

    return Section(
      divider: divider,
      child: Breakpoints.isWide(context)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                const SizedBox(width: 64),
                const Expanded(child: right),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [left, const SizedBox(height: 32), right],
            ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.link});
  final ContactLinkDto link;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => launchUrl(
          Uri.parse(link.url),
          mode: LaunchMode.externalApplication,
        ),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${link.label} — ',
                style: text.bodyMedium?.copyWith(color: AppColors.neutral400),
              ),
              TextSpan(
                text: link.value,
                style: text.bodyMedium?.copyWith(color: AppColors.accent300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
