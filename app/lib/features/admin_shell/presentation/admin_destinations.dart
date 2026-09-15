import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';

/// Destinos do painel; crescem conforme as features chegam.
class AdminDestination {
  const AdminDestination({required this.path, required this.icon, required this.label});
  final String path;
  final IconData icon;
  final String label;
}

List<AdminDestination> adminDestinations(AppLocalizations l10n) => [
      AdminDestination(path: '/admin', icon: Icons.dashboard_outlined, label: l10n.adminTitle),
      AdminDestination(path: '/admin/profile', icon: Icons.person_outline, label: l10n.adminProfileTitle),
      AdminDestination(path: '/admin/projects', icon: Icons.work_outline, label: l10n.navProjects),
      AdminDestination(path: '/admin/skills', icon: Icons.psychology_outlined, label: l10n.navSkills),
      AdminDestination(path: '/admin/experiences', icon: Icons.timeline_outlined, label: l10n.navExperience),
      AdminDestination(path: '/admin/educations', icon: Icons.school_outlined, label: l10n.navEducation),
      AdminDestination(path: '/admin/offerings', icon: Icons.handshake_outlined, label: l10n.navOfferings),
    ];

int selectedDestination(List<AdminDestination> items, String location) {
  final i = items.lastIndexWhere((d) => d.path == '/admin' ? location == '/admin' : location.startsWith(d.path));
  return i < 0 ? 0 : i;
}
