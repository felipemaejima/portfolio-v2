import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../api/models/profile_dto.dart';
import '../../../core/config/app_config.dart';
import '../../../core/ui/breakpoints.dart';
import '../../../core/ui/enum_labels.dart';
import '../../../core/ui/section.dart';
import '../../../core/ui/theme.dart';
import '../../../l10n/generated/app_localizations.dart';

/// "Sobre": foto, parágrafos e o grid Localização / Disponibilidade / Modalidade / Idiomas.
class AboutSection extends StatelessWidget {
  const AboutSection({required this.profile, super.key});
  final ProfileDto profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wide = Breakpoints.isWide(context);
    final photo = _Photo(url: profile.imageUrl);
    final body = _Body(profile: profile, l10n: l10n);

    return Section(
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                photo,
                const SizedBox(width: 56),
                Expanded(child: body),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [photo, const SizedBox(height: 24), body],
            ),
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 180,
        height: 180,
        child: url == null
            ? const ColoredBox(
                color: AppColors.surface,
                child: Icon(
                  Icons.person_outline,
                  size: 48,
                  color: AppColors.neutral500,
                ),
              )
            : CachedNetworkImage(
                imageUrl: AppConfig.resolve(url!),
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    const ColoredBox(color: AppColors.surface),
              ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.profile, required this.l10n});
  final ProfileDto profile;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final paragraphs = profile.description
        .split(RegExp(r'\n\s*\n'))
        .where((p) => p.trim().isNotEmpty);
    final location = [
      profile.location.city,
      profile.location.state,
    ].where((s) => s.isNotEmpty).join(', ');
    final locationText = [
      location,
      profile.location.country,
    ].where((s) => s.isNotEmpty).join(' — ');

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.aboutTitle, style: text.headlineSmall),
          const SizedBox(height: 20),
          for (final p in paragraphs) ...[
            Text(
              p.trim(),
              style: text.bodyMedium?.copyWith(
                color: AppColors.neutral300,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 32,
            runSpacing: 16,
            children: [
              _Fact(l10n.aboutLocation, locationText),
              _Fact(
                l10n.aboutAvailability,
                joinLabels(profile.availability.map((a) => a.label(l10n))),
              ),
              _Fact(
                l10n.aboutWorkMode,
                joinLabels(
                  profile.workModes.map((w) => w.label(l10n)),
                  last: ' / ',
                ),
              ),
              _Fact(
                l10n.aboutLanguages,
                profile.languages.map((x) => x.language).join(', '),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      width: 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Eyebrow(label), const SizedBox(height: 4), Text(value)],
      ),
    );
  }
}
