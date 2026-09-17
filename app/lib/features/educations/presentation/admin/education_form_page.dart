import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../api/models/education_dto.dart';
import '../../../../api/models/education_input_dto.dart';
import '../../../../core/ui/admin_page.dart';
import '../../../../core/ui/async_value_view.dart';
import '../../../../core/ui/failure_text.dart';
import '../../../../core/ui/form_errors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/educations_provider.dart';

class EducationFormPage extends ConsumerWidget {
  const EducationFormPage({this.id, super.key});
  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (id == null) {
      return AdminPage(
        title: l10n.newEducation,
        child: const _Form(initial: null),
      );
    }
    return AdminPage(
      title: l10n.editEducation,
      child: AsyncValueView(
        value: ref.watch(educationsProvider),
        onRetry: () => ref.invalidate(educationsProvider),
        data: (_) {
          final item = ref.watch(educationByIdProvider(id!));
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
  final EducationDto? initial;

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> {
  late final _course = TextEditingController(text: widget.initial?.courseName);
  late final _institution = TextEditingController(
    text: widget.initial?.institution,
  );
  late final _start = TextEditingController(
    text: widget.initial?.startYear.toString(),
  );
  late final _end = TextEditingController(
    text: widget.initial?.endYear?.toString(),
  );
  FormErrors _errors = FormErrors.none;
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_course, _institution, _start, _end]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final start = int.tryParse(_start.text.trim());
    final endText = _end.text.trim();
    final end = endText.isEmpty ? null : int.tryParse(endText);
    if (start == null || (endText.isNotEmpty && end == null)) {
      setState(
        () => _errors = FormErrors({
          if (start == null) 'startYear': [l10n.invalidYear],
          if (endText.isNotEmpty && end == null) 'endYear': [l10n.invalidYear],
        }),
      );
      return;
    }
    setState(() {
      _busy = true;
      _errors = FormErrors.none;
    });
    final input = EducationInputDto(
      courseName: _course.text.trim(),
      institution: _institution.text.trim(),
      startYear: start,
      endYear: end,
    );
    try {
      final editor = ref.read(educationsEditorProvider);
      if (widget.initial == null) {
        await editor.create(input);
        if (mounted) context.go('/admin/educations');
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
        _text(_course, l10n.educationCourse, 'courseName'),
        _text(_institution, l10n.educationInstitution, 'institution'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _text(
                _start,
                l10n.educationStartYear,
                'startYear',
                number: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _text(
                _end,
                l10n.educationEndYear,
                'endYear',
                number: true,
              ),
            ),
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
    bool number = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: c,
      keyboardType: number ? TextInputType.number : null,
      decoration: InputDecoration(labelText: label, errorText: _errors[field]),
    ),
  );
}
