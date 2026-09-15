import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/contact_link_dto.dart';
import '../../../api/models/contact_link_input_dto.dart';
import '../../../api/models/contact_message_dto.dart';
import '../../../api/models/create_contact_message_dto.dart';
import '../data/contact_repository.dart';

final contactLinksProvider = FutureProvider<List<ContactLinkDto>>((ref) => ref.watch(contactRepositoryProvider).listLinks());

/// Inbox do Admin; autoDispose porque só vive no painel.
final contactMessagesProvider =
    FutureProvider.autoDispose<List<ContactMessageDto>>((ref) => ref.watch(contactRepositoryProvider).listMessages());

class ContactEditor {
  ContactEditor(this._ref);
  final Ref _ref;
  ContactRepository get _repo => _ref.read(contactRepositoryProvider);

  Future<void> _links(Future<void> Function() action) async {
    await action();
    _ref.invalidate(contactLinksProvider);
  }

  Future<void> createLink(ContactLinkInputDto body) => _links(() => _repo.createLink(body));
  Future<void> updateLink(String id, ContactLinkInputDto body) => _links(() => _repo.updateLink(id, body));
  Future<void> deleteLink(String id) => _links(() => _repo.deleteLink(id));
  Future<void> reorderLinks(List<String> ids) => _links(() => _repo.reorderLinks(ids));

  Future<void> send(CreateContactMessageDto body) => _repo.sendMessage(body);

  Future<void> markRead(String id) async {
    await _repo.markRead(id);
    _ref.invalidate(contactMessagesProvider);
  }

  Future<void> deleteMessage(String id) async {
    await _repo.deleteMessage(id);
    _ref.invalidate(contactMessagesProvider);
  }
}

final contactEditorProvider = Provider<ContactEditor>(ContactEditor.new);
