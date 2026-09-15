import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/contact_link_dto.dart';
import '../../../api/models/contact_link_input_dto.dart';
import '../../../api/models/contact_message_dto.dart';
import '../../../api/models/create_contact_message_dto.dart';
import '../../../api/models/reorder_dto.dart';
import '../../../api/rest_client.dart';
import '../../../core/data/guard.dart';
import '../../../core/network/rest_client.dart';

class ContactRepository {
  ContactRepository(this._api);
  final RestClient _api;

  Future<List<ContactLinkDto>> listLinks() => guard(_api.contact.listContactLinks);
  Future<ContactLinkDto> createLink(ContactLinkInputDto body) => guard(() => _api.contact.createContactLink(body: body));
  Future<ContactLinkDto> updateLink(String id, ContactLinkInputDto body) => guard(() => _api.contact.updateContactLink(id: id, body: body));
  Future<void> deleteLink(String id) => guard(() => _api.contact.deleteContactLink(id: id));
  Future<void> reorderLinks(List<String> ids) => guard(() => _api.contact.reorderContactLinks(body: ReorderDto(ids: ids)));

  Future<void> sendMessage(CreateContactMessageDto body) => guard(() => _api.contact.sendContactMessage(body: body));
  Future<List<ContactMessageDto>> listMessages() => guard(_api.contact.listContactMessages);
  Future<ContactMessageDto> markRead(String id) => guard(() => _api.contact.markContactMessageRead(id: id));
  Future<void> deleteMessage(String id) => guard(() => _api.contact.deleteContactMessage(id: id));
}

final contactRepositoryProvider = Provider<ContactRepository>((ref) => ContactRepository(ref.watch(restClientProvider)));
