import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../api/models/experience_dto.dart';
import '../../../../api/models/experience_input_dto.dart';
import '../../../../core/ui/admin_page.dart';
import '../../../../core/ui/async_value_view.dart';
import '../../../../core/ui/failure_text.dart';
import '../../../../core/ui/form_errors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/experiences_provider.dart';

class ExperienceFormPage extends ConsumerWidget {
  const ExperienceFormPage({this.id, super.key});
  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (id == null) {
      return AdminPage(
        title: l10n.newExperience,
        child: const _Form(initial: null),
      );
    }
    return AdminPage(
      title: l10n.editExperience,
      child: AsyncValueView(
        value: ref.watch(experiencesProvider),
        onRetry: () => ref.invalidate(experiencesProvider),
        data: (_) {
          final item = ref.watch(experienceByIdProvider(id!));
          return item == null
              ? Text(l10n.notFound)
              : _Form(key: ValueKey(item.updatedAt), initial: item);
        },
      ),
    );
  }
}

class _Form extends ConsumerStatefulWidget {
  const _Form({required this.initial, super.key});
  final ExperienceDto? initial;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  late final _role = TextEditingController(text: widget.initial?.role);
  late final _company = TextEditingController(
    text: widget.initial?.companyName,
  );
  late final _activities = TextEditingController(
    text: widget.initial?.activities.join('\n'),
  );
  late final _start = TextEditingController(text: widget.initial?.startDate);
  late final _end = TextEditingController(text: widget.initial?.endDate);
  FormErrors _errors = FormErrors.none;
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_role, _company, _activities, _start, _end]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _errors = FormErrors.none;
    });
    final input = ExperienceInputDto(
      role: _role.text.trim(),
      companyName: _company.text.trim(),
      activities: _activities.text
          .split('\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
      startDate: _start.text.trim(),
      endDate: _end.text.trim().isEmpty ? null : _end.text.trim(),
    );
    try {
      final editor = ref.read(experiencesEditorProvider);
      if (widget.initial == null) {
        await editor.create(input);
        if (mounted) context.go('/admin/experiences');
      } else {
        await editor.update(widget.initial!.id, input);
      }
      if (mounted) notify(context, l10n.saved);
    } on Object catch (e) {
      if (!mounted) return;
      final errors = FormErrors.of(e);
      setState(() => _errors = errors);
      if (errors.isEmpty) notify(context, failureText(l10n, e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _text(_role, l10n.experienceRole, 'role'),
        _text(_company, l10n.experienceCompany, 'companyName'),
        _text(_activities, l10n.experienceActivities, 'activities', lines: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _text(_start, l10n.experienceStart, 'startDate')),
            const SizedBox(width: 12),
            Expanded(child: _text(_end, l10n.experienceEnd, 'endDate')),
          ],
        ),
        FilledButton(onPressed: _busy ? null : _save, child: Text(l10n.save)),
      ],
    );
  }

  Widget _text(
    TextEditingController c,
    String label,
    String field, {
    int lines = 1,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: c,
      maxLines: lines,
      decoration: InputDecoration(
        labelText: label,
        errorText: _errors[field],
        alignLabelWithHint: lines > 1,
      ),
    ),
  );
}
