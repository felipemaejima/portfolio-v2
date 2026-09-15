import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../api/models/contact_message_dto.dart';
import '../../../../core/ui/admin_page.dart';
import '../../../../core/ui/async_value_view.dart';
import '../../../../core/ui/failure_text.dart';
import '../../../../core/ui/theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/contact_provider.dart';

/// Inbox: mais recentes primeiro, não lidas em destaque; abrir marca como lida.
class MessagesAdminPage extends ConsumerWidget {
  const MessagesAdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AdminPage(
      title: l10n.adminMessages,
      child: AsyncValueView(
        value: ref.watch(contactMessagesProvider),
        onRetry: () => ref.invalidate(contactMessagesProvider),
        data: (items) => items.isEmpty
            ? Center(child: Padding(padding: const EdgeInsets.all(32), child: Text(l10n.emptyList)))
            : Column(children: [for (final m in items) _MessageTile(message: m)]),
      ),
    );
  }
}

class _MessageTile extends ConsumerWidget {
  const _MessageTile({required this.message});
  final ContactMessageDto message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unread = message.readAt == null;
    final date = DateFormat('dd/MM/yyyy HH:mm').format(message.createdAt.toLocal());

    Future<void> act(Future<void> Function() action) async {
      try {
        await action();
      } on Object catch (e) {
        if (context.mounted) notify(context, failureText(l10n, e), error: true);
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        onExpansionChanged: (open) {
          if (open && unread) act(() => ref.read(contactEditorProvider).markRead(message.id));
        },
        leading: Icon(unread ? Icons.mark_email_unread_outlined : Icons.drafts_outlined, color: unread ? AppColors.accent : AppColors.neutral500),
        title: Text(message.name, style: TextStyle(fontWeight: unread ? FontWeight.w600 : FontWeight.normal)),
        subtitle: Text('${message.email} · $date', style: const TextStyle(color: AppColors.neutral500)),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            if (!await confirm(context, title: l10n.confirmDelete, confirmLabel: l10n.delete, cancelLabel: l10n.cancel)) return;
            await act(() => ref.read(contactEditorProvider).deleteMessage(message.id));
          },
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(alignment: Alignment.centerLeft, child: SelectableText(message.message)),
          ),
        ],
      ),
    );
  }
}
