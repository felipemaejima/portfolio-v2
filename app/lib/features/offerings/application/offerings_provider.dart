import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/offering_dto.dart';
import '../../../api/models/offering_input_dto.dart';
import '../data/offerings_repository.dart';

final offeringsProvider = FutureProvider<List<OfferingDto>>(
  (ref) => ref.watch(offeringsRepositoryProvider).list(),
);

class OfferingsEditor {
  OfferingsEditor(this._ref);
  final Ref _ref;
  OfferingsRepository get _repo => _ref.read(offeringsRepositoryProvider);

  Future<void> _then(Future<void> Function() action) async {
    await action();
    _ref.invalidate(offeringsProvider);
  }

  Future<void> create(OfferingInputDto body) => _then(() => _repo.create(body));
  Future<void> update(String id, OfferingInputDto body) =>
      _then(() => _repo.update(id, body));
  Future<void> delete(String id) => _then(() => _repo.delete(id));
  Future<void> reorder(List<String> ids) => _then(() => _repo.reorder(ids));
}

final offeringsEditorProvider = Provider<OfferingsEditor>(OfferingsEditor.new);
