import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/offering_dto.dart';
import '../../../api/models/offering_input_dto.dart';
import '../../../api/models/reorder_dto.dart';
import '../../../api/rest_client.dart';
import '../../../core/data/guard.dart';
import '../../../core/network/rest_client.dart';

class OfferingsRepository {
  OfferingsRepository(this._api);
  final RestClient _api;

  Future<List<OfferingDto>> list() => guard(_api.offerings.listOfferings);
  Future<OfferingDto> create(OfferingInputDto body) =>
      guard(() => _api.offerings.createOffering(body: body));
  Future<OfferingDto> update(String id, OfferingInputDto body) =>
      guard(() => _api.offerings.updateOffering(id: id, body: body));
  Future<void> delete(String id) =>
      guard(() => _api.offerings.deleteOffering(id: id));
  Future<void> reorder(List<String> ids) =>
      guard(() => _api.offerings.reorderOfferings(body: ReorderDto(ids: ids)));
}

final offeringsRepositoryProvider = Provider<OfferingsRepository>(
  (ref) => OfferingsRepository(ref.watch(restClientProvider)),
);
