// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/offering_dto.dart';
import '../models/offering_input_dto.dart';
import '../models/reorder_dto.dart';

part 'offerings_client.g.dart';

@RestApi()
abstract class OfferingsClient {
  factory OfferingsClient(Dio dio, {String? baseUrl}) = _OfferingsClient;

  /// Serviços oferecidos, por `position`.
  @GET('/api/v1/offerings')
  Future<List<OfferingDto>> listOfferings();

  /// Cria no fim.
  @POST('/api/v1/offerings')
  Future<OfferingDto> createOffering({@Body() required OfferingInputDto body});

  @PUT('/api/v1/offerings/{id}')
  Future<OfferingDto> updateOffering({
    @Path('id') required String id,
    @Body() required OfferingInputDto body,
  });

  @DELETE('/api/v1/offerings/{id}')
  Future<void> deleteOffering({@Path('id') required String id});

  /// Ordem de exibição: o conjunto completo de ids na ordem final.
  @PATCH('/api/v1/offerings/reorder')
  Future<void> reorderOfferings({@Body() required ReorderDto body});
}
