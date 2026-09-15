import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/models/contact_link_dto.dart';
import '../../../api/models/profile_dto.dart';
import '../../../core/ui/breakpoints.dart';
import '../../../core/ui/theme.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Hero do layout de referência: headline, nome, resumo, CTAs, até 3 contatos.
class HeroSection extends StatelessWidget {
  const HeroSection({
    required this.profile,
    required this.onSeeProjects,
    required this.onContact,
    this.contacts = const [],
    super.key,
  });

  final ProfileDto profile;
  final List<ContactLinkDto> contacts;
  final VoidCallback onSeeProjects;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final wide = Breakpoints.isWide(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(wide ? 64 : 20, wide ? 100 : 48, wide ? 64 : 20, wide ? 88 : 48),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (profile.headline.isNotEmpty)
              Text(
                profile.headline.toUpperCase(),
                style: text.labelMedium?.copyWith(color: AppColors.accent300, letterSpacing: 1.6),
              ),
            const SizedBox(height: 16),
            Text(
              profile.name,
              style: (wide ? text.displayMedium : text.headlineLarge)?.copyWith(fontWeight: FontWeight.w500, height: 1.08),
            ),
            if (profile.summary.isNotEmpty) ...[
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(profile.summary, style: text.bodyLarge?.copyWith(color: AppColors.neutral300, height: 1.6)),
              ),
            ],
            const SizedBox(height: 36),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton(onPressed: onSeeProjects, child: Text(l10n.heroSeeProjects)),
                OutlinedButton(
                  onPressed: onContact,
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.text, side: const BorderSide(color: AppColors.divider)),
                  child: Text(l10n.heroContact),
                ),
              ],
            ),
            if (contacts.isNotEmpty) ...[
              const SizedBox(height: 32),
              Wrap(
                spacing: 20,
                children: [
                  for (final c in contacts.take(3))
                    InkWell(
                      onTap: () => launchUrl(Uri.parse(c.url), mode: LaunchMode.externalApplication),
                      child: Text(c.label, style: text.bodySmall?.copyWith(color: AppColors.neutral400)),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
