import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api/models/availability.dart';
import '../../../../api/models/language_dto.dart';
import '../../../../api/models/language_level.dart';
import '../../../../api/models/location_dto.dart';
import '../../../../api/models/profile_dto.dart';
import '../../../../api/models/update_profile_dto.dart';
import '../../../../api/models/work_mode.dart';
import '../../../../core/ui/admin_page.dart';
import '../../../../core/ui/async_value_view.dart';
import '../../../../core/ui/enum_labels.dart';
import '../../../../core/ui/failure_text.dart';
import '../../../../core/ui/form_errors.dart';
import '../../../../core/ui/pick_image.dart';
import '../../../../core/ui/theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/profile_provider.dart';

class ProfileFormPage extends ConsumerWidget {
  const ProfileFormPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AdminPage(
      title: l10n.adminProfileTitle,
      child: AsyncValueView(
        value: ref.watch(profileProvider),
        onRetry: () => ref.invalidate(profileProvider),
        data: (profile) => _ProfileForm(key: ValueKey(profile.updatedAt), initial: profile),
      ),
    );
  }
}

class _ProfileForm extends ConsumerStatefulWidget {
  const _ProfileForm({required this.initial, super.key});
  final ProfileDto initial;

  @override
  ConsumerState<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<_ProfileForm> {
  late final _name = TextEditingController(text: widget.initial.name);
  late final _headline = TextEditingController(text: widget.initial.headline);
  late final _summary = TextEditingController(text: widget.initial.summary);
  late final _description = TextEditingController(text: widget.initial.description);
  late final _contactIntro = TextEditingController(text: widget.initial.contactIntro);
  late final _city = TextEditingController(text: widget.initial.location.city);
  late final _state = TextEditingController(text: widget.initial.location.state);
  late final _country = TextEditingController(text: widget.initial.location.country);
  late final Set<Availability> _availability = {...widget.initial.availability};
  late final Set<WorkMode> _workModes = {...widget.initial.workModes};
  late final List<_LanguageRow> _languages = [for (final l in widget.initial.languages) _LanguageRow(l.language, l.level)];
  String? _imageUrl;
  FormErrors _errors = FormErrors.none;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initial.imageUrl;
  }

  @override
  void dispose() {
    for (final c in [_name, _headline, _summary, _description, _contactIntro, _city, _state, _country]) {
      c.dispose();
    }
    for (final l in _languages) {
      l.name.dispose();
    }
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action, {required String success}) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _errors = FormErrors.none;
    });
    try {
      await action();
      if (mounted) notify(context, success);
    } on Object catch (e) {
      if (!mounted) return;
      final errors = FormErrors.of(e);
      setState(() => _errors = errors);
      if (errors.isEmpty) notify(context, failureText(l10n, e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() => _run(
        () async {
          await ref.read(profileEditorProvider).save(UpdateProfileDto(
                name: _name.text.trim(),
                headline: _headline.text.trim(),
                summary: _summary.text.trim(),
                description: _description.text.trim(),
                contactIntro: _contactIntro.text.trim().isEmpty ? null : _contactIntro.text.trim(),
                location: LocationDto(city: _city.text.trim(), state: _state.text.trim(), country: _country.text.trim()),
                availability: _availability.toList(),
                workModes: _workModes.toList(),
                languages: [for (final l in _languages) LanguageDto(language: l.name.text.trim(), level: l.level)],
              ));
        },
        success: AppLocalizations.of(context).saved,
      );

  Future<void> _changePhoto() async {
    final saved = AppLocalizations.of(context).saved;
    final image = await pickImage();
    if (image == null || !mounted) return;
    await _run(
      () async {
        final updated = await ref.read(profileEditorProvider).replaceImage(image);
        setState(() => _imageUrl = updated.imageUrl);
      },
      success: saved,
    );
  }

  Future<void> _removePhoto() => _run(
        () async {
          await ref.read(profileEditorProvider).removeImage();
          setState(() => _imageUrl = null);
        },
        success: AppLocalizations.of(context).saved,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PhotoField(url: _imageUrl, busy: _busy, onChange: _changePhoto, onRemove: _removePhoto),
        const SizedBox(height: 24),
        _text(_name, l10n.profileName, 'name'),
        _text(_headline, l10n.profileHeadline, 'headline'),
        _text(_summary, l10n.profileSummary, 'summary', lines: 3),
        _text(_description, l10n.profileDescription, 'description', lines: 8),
        _text(_contactIntro, l10n.profileContactIntro, 'contactIntro', lines: 3),
        Text(l10n.aboutLocation, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _text(_city, l10n.profileCity, 'location.city')),
            const SizedBox(width: 12),
            SizedBox(width: 100, child: _text(_state, l10n.profileState, 'location.state')),
            const SizedBox(width: 12),
            Expanded(child: _text(_country, l10n.profileCountry, 'location.country')),
          ],
        ),
        _chips<Availability>(
          l10n.aboutAvailability,
          Availability.$valuesDefined,
          _availability,
          (a) => a.label(l10n),
          'availability',
        ),
        _chips<WorkMode>(l10n.aboutWorkMode, WorkMode.$valuesDefined, _workModes, (w) => w.label(l10n), 'workModes'),
        const SizedBox(height: 16),
        Text(l10n.aboutLanguages, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        for (final (i, row) in _languages.indexed) _languageRow(i, row, l10n),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => _languages.add(_LanguageRow('', LanguageLevel.intermediate))),
            icon: const Icon(Icons.add),
            label: Text(l10n.profileAddLanguage),
          ),
        ),
        if (_errors.others(const {}) case final rest?) ...[
          const SizedBox(height: 8),
          Text(rest, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ],
        const SizedBox(height: 24),
        FilledButton(onPressed: _busy ? null : _save, child: Text(l10n.save)),
      ],
    );
  }

  Widget _text(TextEditingController c, String label, String field, {int lines = 1}) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextField(
          controller: c,
          maxLines: lines,
          decoration: InputDecoration(labelText: label, errorText: _errors[field], alignLabelWithHint: lines > 1),
        ),
      );

  Widget _chips<T>(String label, List<T> all, Set<T> selected, String Function(T) name, String field) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final v in all)
                  FilterChip(
                    label: Text(name(v)),
                    selected: selected.contains(v),
                    onSelected: (on) => setState(() => on ? selected.add(v) : selected.remove(v)),
                  ),
              ],
            ),
            if (_errors[field] case final err?) Text(err, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
        ),
      );

  Widget _languageRow(int i, _LanguageRow row, AppLocalizations l10n) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: row.name,
                decoration: InputDecoration(labelText: l10n.profileLanguage, errorText: _errors['languages.$i.language']),
              ),
            ),
            const SizedBox(width: 12),
            DropdownMenu<LanguageLevel>(
              initialSelection: row.level,
              onSelected: (v) => setState(() => row.level = v ?? row.level),
              dropdownMenuEntries: [
                for (final lv in LanguageLevel.$valuesDefined) DropdownMenuEntry(value: lv, label: lv.label(l10n)),
              ],
            ),
            IconButton(
              tooltip: l10n.remove,
              onPressed: () => setState(() => _languages.removeAt(i).name.dispose()),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      );
}

class _LanguageRow {
  _LanguageRow(String name, this.level) : name = TextEditingController(text: name);
  final TextEditingController name;
  LanguageLevel level;
}

class _PhotoField extends StatelessWidget {
  const _PhotoField({required this.url, required this.busy, required this.onChange, required this.onRemove});
  final String? url;
  final bool busy;
  final VoidCallback onChange;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 96,
            height: 96,
            child: url == null
                ? const ColoredBox(color: AppColors.surface, child: Icon(Icons.person_outline, color: AppColors.neutral500))
                : CachedNetworkImage(imageUrl: url!, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 16),
        Wrap(
          spacing: 8,
          children: [
            OutlinedButton(onPressed: busy ? null : onChange, child: Text(l10n.profileChangePhoto)),
            if (url != null) TextButton(onPressed: busy ? null : onRemove, child: Text(l10n.remove)),
          ],
        ),
      ],
    );
  }
}
