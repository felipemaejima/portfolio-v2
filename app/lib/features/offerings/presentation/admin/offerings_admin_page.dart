import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api/models/offering_dto.dart';
import '../../../../api/models/offering_input_dto.dart';
import '../../../../core/ui/admin_page.dart';
import '../../../../core/ui/async_value_view.dart';
import '../../../../core/ui/failure_text.dart';
import '../../../../core/ui/form_errors.dart';
import '../../../../core/ui/reorderable_admin_list.dart';
import '../../../../core/ui/theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/offerings_provider.dart';

class OfferingsAdminPage extends ConsumerWidget {
  const OfferingsAdminPage({super.key});

  Future<void> _edit(BuildContext context, WidgetRef ref, OfferingDto? item) async {
    final input = await showDialog<OfferingInputDto>(context: context, builder: (_) => _OfferingDialog(initial: item));
    if (input == null || !context.mounted) return;
    try {
      final editor = ref.read(offeringsEditorProvider);
      await (item == null ? editor.create(input) : editor.update(item.id, input));
    } on Object catch (e) {
      if (context.mounted) notify(context, failureText(AppLocalizations.of(context), e), error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AdminPage(
      title: l10n.navOfferings,
      actions: [FilledButton.icon(onPressed: () => _edit(context, ref, null), icon: const Icon(Icons.add), label: Text(l10n.newItem))],
      child: AsyncValueView(
        value: ref.watch(offeringsProvider),
        onRetry: () => ref.invalidate(offeringsProvider),
        data: (items) => ReorderableAdminList<OfferingDto>(
          items: items,
          idOf: (o) => o.id,
          onReorder: ref.read(offeringsEditorProvider).reorder,
          itemBuilder: (context, o) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(o.title),
            subtitle: Text(o.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.neutral500)),
            onTap: () => _edit(context, ref, o),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                if (!await confirm(context, title: l10n.confirmDelete, confirmLabel: l10n.delete, cancelLabel: l10n.cancel)) return;
                try {
                  await ref.read(offeringsEditorProvider).delete(o.id);
                } on Object catch (e) {
                  if (context.mounted) notify(context, failureText(l10n, e), error: true);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _OfferingDialog extends StatefulWidget {
  const _OfferingDialog({required this.initial});
  final OfferingDto? initial;

  @override
  State<_OfferingDialog> createState() => _OfferingDialogState();
}

class _OfferingDialogState extends State<_OfferingDialog> {
  late final _title = TextEditingController(text: widget.initial?.title);
  late final _description = TextEditingController(text: widget.initial?.description);
  final _errors = FormErrors.none;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.initial == null ? l10n.newOffering : l10n.editOffering),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _title, autofocus: true, decoration: InputDecoration(labelText: l10n.offeringTitle, errorText: _errors['title'])),
            const SizedBox(height: 12),
            TextField(controller: _description, maxLines: 4, decoration: InputDecoration(labelText: l10n.offeringDescription, errorText: _errors['description'], alignLabelWithHint: true)),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: () => Navigator.pop(context, OfferingInputDto(title: _title.text.trim(), description: _description.text.trim())),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
