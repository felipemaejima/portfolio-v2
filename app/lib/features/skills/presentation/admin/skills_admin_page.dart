import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api/models/skill_category_dto.dart';
import '../../../../api/models/skill_dto.dart';
import '../../../../core/ui/admin_page.dart';
import '../../../../core/ui/async_value_view.dart';
import '../../../../core/ui/failure_text.dart';
import '../../../../core/ui/reorderable_admin_list.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/skills_provider.dart';

/// Categorias reordenáveis; dentro de cada uma, skills reordenáveis, com
/// criação inline, edição (nome + mover de categoria) e exclusão.
class SkillsAdminPage extends ConsumerWidget {
  const SkillsAdminPage({super.key});

  Future<void> _act(BuildContext context, Future<void> Function() action) async {
    try {
      await action();
    } on Object catch (e) {
      if (context.mounted) notify(context, failureText(AppLocalizations.of(context), e), error: true);
    }
  }

  Future<void> _newCategory(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final name = await _prompt(context, title: l10n.newCategory, label: l10n.categoryName);
    if (name == null || !context.mounted) return;
    await _act(context, () => ref.read(skillsEditorProvider).createCategory(name));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AdminPage(
      title: l10n.navSkills,
      actions: [FilledButton.icon(onPressed: () => _newCategory(context, ref), icon: const Icon(Icons.add), label: Text(l10n.newCategory))],
      child: AsyncValueView(
        value: ref.watch(skillCategoriesProvider),
        onRetry: () => ref.invalidate(skillCategoriesProvider),
        data: (categories) => ReorderableAdminList<SkillCategoryDto>(
          items: categories,
          idOf: (c) => c.id,
          onReorder: ref.read(skillsEditorProvider).reorderCategories,
          itemBuilder: (context, c) => _CategoryCard(category: c, categories: categories, act: (a) => _act(context, a)),
        ),
      ),
    );
  }
}

class _CategoryCard extends ConsumerStatefulWidget {
  const _CategoryCard({required this.category, required this.categories, required this.act});
  final SkillCategoryDto category;
  final List<SkillCategoryDto> categories;
  final Future<void> Function(Future<void> Function()) act;

  @override
  ConsumerState<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends ConsumerState<_CategoryCard> {
  final _newSkill = TextEditingController();

  @override
  void dispose() {
    _newSkill.dispose();
    super.dispose();
  }

  SkillsEditor get _editor => ref.read(skillsEditorProvider);

  Future<void> _addSkill() async {
    final name = _newSkill.text.trim();
    if (name.isEmpty) return;
    await widget.act(() => _editor.createSkill(widget.category.id, name));
    _newSkill.clear();
  }

  Future<void> _rename() async {
    final l10n = AppLocalizations.of(context);
    final name = await _prompt(context, title: l10n.renameCategory, label: l10n.categoryName, initial: widget.category.name);
    if (name == null || !mounted) return;
    await widget.act(() => _editor.renameCategory(widget.category.id, name));
  }

  Future<void> _deleteCategory() async {
    final l10n = AppLocalizations.of(context);
    if (!await confirm(context, title: l10n.confirmDeleteCategory, confirmLabel: l10n.delete, cancelLabel: l10n.cancel)) return;
    await widget.act(() => _editor.deleteCategory(widget.category.id));
  }

  Future<void> _editSkill(SkillDto skill) async {
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (_) => _SkillDialog(skill: skill, categories: widget.categories),
    );
    if (result == null || !mounted) return;
    await widget.act(() => _editor.updateSkill(skill.id, result.$1, result.$2));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = widget.category;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(c.name, style: Theme.of(context).textTheme.titleMedium)),
                IconButton(icon: const Icon(Icons.edit_outlined), tooltip: l10n.renameCategory, onPressed: _rename),
                IconButton(icon: const Icon(Icons.delete_outline), tooltip: l10n.delete, onPressed: _deleteCategory),
              ],
            ),
            ReorderableAdminList<SkillDto>(
              items: c.skills,
              idOf: (s) => s.id,
              emptyText: l10n.noSkillsYet,
              onReorder: (ids) => _editor.reorderSkills(c.id, ids),
              itemBuilder: (context, s) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(s.name),
                onTap: () => _editSkill(s),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => widget.act(() => _editor.deleteSkill(s.id)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newSkill,
                    decoration: InputDecoration(hintText: l10n.newSkillHint, isDense: true),
                    onSubmitted: (_) => _addSkill(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(icon: const Icon(Icons.add), onPressed: _addSkill),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillDialog extends StatefulWidget {
  const _SkillDialog({required this.skill, required this.categories});
  final SkillDto skill;
  final List<SkillCategoryDto> categories;

  @override
  State<_SkillDialog> createState() => _SkillDialogState();
}

class _SkillDialogState extends State<_SkillDialog> {
  late final _name = TextEditingController(text: widget.skill.name);
  late String _categoryId = widget.skill.categoryId;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.editSkill),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _name, autofocus: true, decoration: InputDecoration(labelText: l10n.skillName)),
          const SizedBox(height: 12),
          DropdownMenu<String>(
            initialSelection: _categoryId,
            label: Text(l10n.categoryName),
            onSelected: (v) => _categoryId = v ?? _categoryId,
            dropdownMenuEntries: [for (final c in widget.categories) DropdownMenuEntry(value: c.id, label: c.name)],
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(onPressed: () => Navigator.pop(context, (_name.text.trim(), _categoryId)), child: Text(l10n.save)),
      ],
    );
  }
}

/// Diálogo de um campo de texto; devolve null se cancelado.
Future<String?> _prompt(BuildContext context, {required String title, required String label, String initial = ''}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(controller: controller, autofocus: true, decoration: InputDecoration(labelText: label)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context).cancel)),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text.trim().isEmpty ? null : controller.text.trim()),
          child: Text(AppLocalizations.of(context).save),
        ),
      ],
    ),
  ).whenComplete(controller.dispose);
}

