import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../core/ui/async_value_view.dart';
import '../../../core/ui/breakpoints.dart';
import '../../../core/ui/theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../contact/application/contact_provider.dart';
import '../../contact/presentation/contact_section.dart';
import '../../educations/presentation/education_section.dart';
import '../../experiences/presentation/experience_section.dart';
import '../../offerings/presentation/offerings_section.dart';
import '../../profile/application/profile_provider.dart';
import '../../profile/presentation/about_section.dart';
import '../../profile/presentation/hero_section.dart';
import '../../projects/presentation/projects_section.dart';
import '../../skills/presentation/skills_section.dart';

/// Âncoras da home; as seções entram conforme as features chegam (APP.md §9).
enum HomeAnchor { about, projects, skills, experience, education, offerings, contact }

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _keys = {for (final a in HomeAnchor.values) a: GlobalKey()};

  void _scrollTo(HomeAnchor anchor) {
    final ctx = _keys[anchor]!.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final name = profile.value?.name ?? '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            titleSpacing: Breakpoints.isWide(context) ? 64 : 20,
            title: Text(name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            actions: [_Nav(onSelect: _scrollTo), const SizedBox(width: 8)],
          ),
          SliverToBoxAdapter(
            child: AsyncValueView(
              value: profile,
              onRetry: () => ref.invalidate(profileProvider),
              data: (p) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeroSection(
                    profile: p,
                    contacts: ref.watch(contactLinksProvider).value ?? const [],
                    onSeeProjects: () => _scrollTo(HomeAnchor.projects),
                    onContact: () => _scrollTo(HomeAnchor.contact),
                  ),
                  KeyedSubtree(key: _keys[HomeAnchor.about], child: AboutSection(profile: p)),
                  KeyedSubtree(key: _keys[HomeAnchor.skills], child: const SkillsSection()),
                  KeyedSubtree(key: _keys[HomeAnchor.projects], child: const ProjectsSection()),
                  KeyedSubtree(key: _keys[HomeAnchor.experience], child: const ExperienceSection()),
                  KeyedSubtree(key: _keys[HomeAnchor.education], child: const EducationSection()),
                  KeyedSubtree(key: _keys[HomeAnchor.offerings], child: const OfferingsSection()),
                  KeyedSubtree(key: _keys[HomeAnchor.contact], child: ContactSection(intro: p.contactIntro)),
                  _Footer(name: p.name),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Nav extends StatelessWidget {
  const _Nav({required this.onSelect});
  final void Function(HomeAnchor) onSelect;

  static List<(HomeAnchor, String)> _items(AppLocalizations l10n) => [
        (HomeAnchor.about, l10n.navAbout),
        (HomeAnchor.projects, l10n.navProjects),
        (HomeAnchor.skills, l10n.navSkills),
        (HomeAnchor.experience, l10n.navExperience),
        (HomeAnchor.education, l10n.navEducation),
        (HomeAnchor.offerings, l10n.navOfferings),
        (HomeAnchor.contact, l10n.navContact),
      ];

  static Future<void> _downloadCv() =>
      launchUrl(Uri.parse('${AppConfig.apiBaseUrl}/api/v1/cv'), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cv = OutlinedButton(onPressed: _downloadCv, child: Text(l10n.downloadCv));

    if (!Breakpoints.isWide(context)) {
      return Row(
        children: [
          cv,
          PopupMenuButton<HomeAnchor>(
            icon: const Icon(Icons.menu),
            onSelected: onSelect,
            itemBuilder: (_) => [for (final (a, label) in _items(l10n)) PopupMenuItem(value: a, child: Text(label))],
          ),
        ],
      );
    }
    return Row(
      children: [
        for (final (a, label) in _items(l10n))
          TextButton(
            onPressed: () => onSelect(a),
            style: TextButton.styleFrom(foregroundColor: AppColors.text),
            child: Text(label),
          ),
        const SizedBox(width: 16),
        cv,
        const SizedBox(width: 56),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.neutral500);
    return Padding(
      padding: Breakpoints.pagePadding(context).copyWith(top: 32, bottom: 32),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 8,
        children: [
          Text('© ${DateTime.now().year} $name', style: style),
          Text(l10n.footerMadeWith, style: style),
        ],
      ),
    );
  }
}
