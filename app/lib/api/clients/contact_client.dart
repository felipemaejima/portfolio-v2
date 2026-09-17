// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/contact_link_dto.dart';
import '../models/contact_link_input_dto.dart';
import '../models/contact_message_dto.dart';
import '../models/create_contact_message_dto.dart';
import '../models/reorder_dto.dart';

part 'contact_client.g.dart';

@RestApi()
abstract class ContactClient {
  factory ContactClient(Dio dio, {String? baseUrl}) = _ContactClient;

  /// Canais públicos de contato, por `position`.
  @GET('/api/v1/contact-links')
  Future<List<ContactLinkDto>> listContactLinks();

  /// Cria no fim.
  @POST('/api/v1/contact-links')
  Future<ContactLinkDto> createContactLink({
    @Body() required ContactLinkInputDto body,
  });

  @PUT('/api/v1/contact-links/{id}')
  Future<ContactLinkDto> updateContactLink({
    @Path('id') required String id,
    @Body() required ContactLinkInputDto body,
  });

  @DELETE('/api/v1/contact-links/{id}')
  Future<void> deleteContactLink({
    @Path('id') required String id,
  });

  /// Ordem de exibição: o conjunto completo de ids na ordem final.
  @PATCH('/api/v1/contact-links/reorder')
  Future<void> reorderContactLinks({
    @Body() required ReorderDto body,
  });

  /// Visitor envia uma mensagem. Só persiste; sem corpo de resposta. 3/min por IP.
  @POST('/api/v1/contact-messages')
  Future<void> sendContactMessage({
    @Body() required CreateContactMessageDto body,
  });

  /// Inbox do Admin, mais recentes primeiro.
  @GET('/api/v1/contact-messages')
  Future<List<ContactMessageDto>> listContactMessages();

  /// Marca como lida (idempotente).
  @PATCH('/api/v1/contact-messages/{id}/read')
  Future<ContactMessageDto> markContactMessageRead({
    @Path('id') required String id,
  });

  @DELETE('/api/v1/contact-messages/{id}')
  Future<void> deleteContactMessage({
    @Path('id') required String id,
  });
}
