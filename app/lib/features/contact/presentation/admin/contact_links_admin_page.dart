import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api/models/contact_link_dto.dart';
import '../../../../api/models/contact_link_input_dto.dart';
import '../../../../core/ui/admin_page.dart';
import '../../../../core/ui/async_value_view.dart';
import '../../../../core/ui/failure_text.dart';
import '../../../../core/ui/reorderable_admin_list.dart';
import '../../../../core/ui/theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/contact_provider.dart';

class ContactLinksAdminPage extends ConsumerWidget {
  const ContactLinksAdminPage({super.key});

  Future<void> _edit(BuildContext context, WidgetRef ref, ContactLinkDto? item) async {
    final input = await showDialog<ContactLinkInputDto>(context: context, builder: (_) => _LinkDialog(initial: item));
    if (input == null || !context.mounted) return;
    try {
      final editor = ref.read(contactEditorProvider);
      await (item == null ? editor.createLink(input) : editor.updateLink(item.id, input));
    } on Object catch (e) {
      if (context.mounted) notify(context, failureText(AppLocalizations.of(context), e), error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AdminPage(
      title: l10n.adminContactLinks,
      actions: [FilledButton.icon(onPressed: () => _edit(context, ref, null), icon: const Icon(Icons.add), label: Text(l10n.newItem))],
      child: AsyncValueView(
        value: ref.watch(contactLinksProvider),
        onRetry: () => ref.invalidate(contactLinksProvider),
        data: (items) => ReorderableAdminList<ContactLinkDto>(
          items: items,
          idOf: (l) => l.id,
          onReorder: ref.read(contactEditorProvider).reorderLinks,
          itemBuilder: (context, l) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('${l.label} — ${l.value}'),
            subtitle: Text(l.url, style: const TextStyle(color: AppColors.neutral500)),
            onTap: () => _edit(context, ref, l),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                if (!await confirm(context, title: l10n.confirmDelete, confirmLabel: l10n.delete, cancelLabel: l10n.cancel)) return;
                try {
                  await ref.read(contactEditorProvider).deleteLink(l.id);
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

class _LinkDialog extends StatefulWidget {
  const _LinkDialog({required this.initial});
  final ContactLinkDto? initial;

  @override
  State<_LinkDialog> createState() => _LinkDialogState();
}

class _LinkDialogState extends State<_LinkDialog> {
  late final _label = TextEditingController(text: widget.initial?.label);
  late final _value = TextEditingController(text: widget.initial?.value);
  late final _url = TextEditingController(text: widget.initial?.url);

  @override
  void dispose() {
    for (final c in [_label, _value, _url]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.initial == null ? l10n.newContactLink : l10n.editContactLink),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _label, autofocus: true, decoration: InputDecoration(labelText: l10n.contactLinkLabel, hintText: 'GitHub')),
            const SizedBox(height: 12),
            TextField(controller: _value, decoration: InputDecoration(labelText: l10n.contactLinkValue, hintText: 'github.com/usuario')),
            const SizedBox(height: 12),
            TextField(controller: _url, decoration: InputDecoration(labelText: l10n.contactLinkUrl, hintText: 'https://… · mailto:… · tel:…')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: () => Navigator.pop(context, ContactLinkInputDto(label: _label.text.trim(), value: _value.text.trim(), url: _url.text.trim())),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
