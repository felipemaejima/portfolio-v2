import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../api/models/project_dto.dart';
import '../../../../api/models/project_image_dto.dart';
import '../../../../api/models/project_input_dto.dart';
import '../../../../core/ui/admin_page.dart';
import '../../../../core/ui/async_value_view.dart';
import '../../../../core/ui/failure_text.dart';
import '../../../../core/ui/form_errors.dart';
import '../../../../core/ui/pick_image.dart';
import '../../../../core/ui/theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/projects_provider.dart';

const maxImagesPerProject = 12;

/// `/admin/projects/new` (id null) e `/admin/projects/:id`.
class ProjectFormPage extends ConsumerWidget {
  const ProjectFormPage({this.id, super.key});
  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (id == null) {
      return AdminPage(title: l10n.newProject, child: const _ProjectForm(initial: null));
    }
    return AdminPage(
      title: l10n.editProject,
      child: AsyncValueView(
        value: ref.watch(projectsProvider),
        onRetry: () => ref.invalidate(projectsProvider),
        data: (_) {
          final project = ref.watch(projectByIdProvider(id!));
          if (project == null) return Text(l10n.notFound);
          return _ProjectForm(key: ValueKey(project.updatedAt), initial: project);
        },
      ),
    );
  }
}

class _ProjectForm extends ConsumerStatefulWidget {
  const _ProjectForm({required this.initial, super.key});
  final ProjectDto? initial;

  @override
  ConsumerState<_ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<_ProjectForm> {
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _short = TextEditingController(text: widget.initial?.shortDescription);
  late final _full = TextEditingController(text: widget.initial?.fullDescription);
  late final _tech = TextEditingController(text: widget.initial?.technologies.join(', '));
  late final _code = TextEditingController(text: widget.initial?.codeUrl);
  late final _demo = TextEditingController(text: widget.initial?.demoUrl);
  late List<ProjectImageDto> _images = [...?widget.initial?.images];
  FormErrors _errors = FormErrors.none;
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _short, _full, _tech, _code, _demo]) {
      c.dispose();
    }
    super.dispose();
  }

  ProjectInputDto _input() => ProjectInputDto(
        name: _name.text.trim(),
        shortDescription: _short.text.trim(),
        fullDescription: _full.text.trim(),
        technologies: _tech.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
        codeUrl: _code.text.trim().isEmpty ? null : _code.text.trim(),
        demoUrl: _demo.text.trim().isEmpty ? null : _demo.text.trim(),
      );

  Future<void> _run(Future<void> Function() action) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _errors = FormErrors.none;
    });
    try {
      await action();
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

  Future<void> _save() => _run(() async {
        final editor = ref.read(projectsEditorProvider);
        final initial = widget.initial;
        if (initial == null) {
          final created = await editor.create(_input());
          if (mounted) context.go('/admin/projects/${created.id}');
        } else {
          await editor.update(initial.id, _input());
        }
      });

  Future<void> _addImages() async {
    final id = widget.initial!.id;
    final picked = await pickImages();
    if (picked.isEmpty || !mounted) return;
    await _run(() async {
      final updated = await ref.read(projectsEditorProvider).addImages(id, picked);
      setState(() => _images = [...updated.images]);
    });
  }

  Future<void> _removeImage(ProjectImageDto img) => _run(() async {
        await ref.read(projectsEditorProvider).deleteImage(widget.initial!.id, img.id);
        setState(() => _images = _images.where((i) => i.id != img.id).toList());
      });

  Future<void> _reorderImages(int oldIndex, int newIndex) async {
    final before = [..._images];
    setState(() {
      _images.insert(newIndex, _images.removeAt(oldIndex));
    });
    try {
      await ref.read(projectsEditorProvider).reorderImages(widget.initial!.id, _images.map((i) => i.id).toList());
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _images = before);
      notify(context, failureText(AppLocalizations.of(context), e), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final editing = widget.initial != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (editing) Text('/${widget.initial!.slug}', style: const TextStyle(color: AppColors.neutral500)),
        const SizedBox(height: 8),
        _text(_name, l10n.projectName, 'name'),
        _text(_short, l10n.projectShortDescription, 'shortDescription', lines: 2),
        _text(_full, l10n.projectFullDescription, 'fullDescription', lines: 8),
        _text(_tech, l10n.projectTechnologies, 'technologies'),
        _text(_code, l10n.projectCodeUrl, 'codeUrl'),
        _text(_demo, l10n.projectDemoUrl, 'demoUrl'),
        FilledButton(onPressed: _busy ? null : _save, child: Text(l10n.save)),
        if (editing) ...[
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: Text('${l10n.gallery} (${_images.length}/$maxImagesPerProject)', style: Theme.of(context).textTheme.titleMedium)),
              OutlinedButton.icon(
                onPressed: _busy || _images.length >= maxImagesPerProject ? null : _addImages,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: Text(l10n.addImages),
              ),
            ],
          ),
          if (_errors['files'] case final err?) Text(err, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 8),
          Text(l10n.dragToReorder, style: const TextStyle(color: AppColors.neutral500)),
          const SizedBox(height: 8),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            itemCount: _images.length,
            onReorderItem: _reorderImages,
            itemBuilder: (context, i) {
              final img = _images[i];
              return ListTile(
                key: ValueKey(img.id),
                contentPadding: EdgeInsets.zero,
                leading: ReorderableDragStartListener(index: i, child: const Icon(Icons.drag_indicator)),
                title: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(height: 72, child: Align(alignment: Alignment.centerLeft, child: CachedNetworkImage(imageUrl: img.url, height: 72, fit: BoxFit.cover))),
                ),
                trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: _busy ? null : () => _removeImage(img)),
              );
            },
          ),
        ] else
          Padding(padding: const EdgeInsets.only(top: 16), child: Text(l10n.saveBeforeImages, style: const TextStyle(color: AppColors.neutral500))),
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
}
