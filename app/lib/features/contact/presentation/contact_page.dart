import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../profile/application/profile_provider.dart';
import 'contact_section.dart';

/// `/contact`: a mesma seção da home, em página própria.
class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intro = ref.watch(profileProvider).value?.contactIntro;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/')),
        title: Text(AppLocalizations.of(context).navContact),
      ),
      body: SingleChildScrollView(
        child: ContactSection(intro: intro, divider: false),
      ),
    );
  }
}
