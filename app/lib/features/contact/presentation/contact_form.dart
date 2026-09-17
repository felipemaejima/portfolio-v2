import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/create_contact_message_dto.dart';
import '../../../core/errors/api_failure.dart';
import '../../../core/ui/failure_text.dart';
import '../../../core/ui/form_errors.dart';
import '../../../core/ui/theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/contact_provider.dart';

/// Nome / E-mail / Mensagem → POST /contact-messages. 422 por campo, 429 amigável.
class ContactForm extends ConsumerStatefulWidget {
  const ContactForm({super.key});

  @override
  ConsumerState<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends ConsumerState<ContactForm> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  FormErrors _errors = FormErrors.none;
  String? _error;
  bool _busy = false;
  bool _sent = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _errors = FormErrors.none;
      _error = null;
    });
    try {
      await ref
          .read(contactEditorProvider)
          .send(
            CreateContactMessageDto(
              name: _name.text.trim(),
              email: _email.text.trim(),
              message: _message.text.trim(),
            ),
          );
      setState(() => _sent = true);
    } on ApiValidation catch (e) {
      setState(() => _errors = FormErrors.of(e));
    } on Object catch (e) {
      setState(() => _error = failureText(l10n, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_sent) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: AppColors.accent300),
            const SizedBox(width: 12),
            Expanded(child: Text(l10n.contactSent)),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _name,
          decoration: InputDecoration(
            labelText: l10n.contactName,
            errorText: _errors['name'],
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: l10n.contactEmail,
            errorText: _errors['email'],
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _message,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: l10n.contactMessage,
            errorText: _errors['message'],
            alignLabelWithHint: true,
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _busy ? null : _send,
          child: Text(l10n.contactSend),
        ),
      ],
    );
  }
}
