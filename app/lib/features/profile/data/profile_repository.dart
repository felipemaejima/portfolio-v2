import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/profile_dto.dart';
import '../../../api/models/update_profile_dto.dart';
import '../../../api/rest_client.dart';
import '../../../core/errors/api_failure.dart';
import '../../../core/network/rest_client.dart';
import '../../../core/network/uploads.dart';

/// Isola o cliente gerado e normaliza erros em ApiFailure.
class ProfileRepository {
  ProfileRepository(this._api, this._uploads);
  final RestClient _api;
  final Uploads _uploads;

  Future<ProfileDto> get() => _guard(_api.profile.getProfile);
  Future<ProfileDto> update(UpdateProfileDto body) =>
      _guard(() => _api.profile.updateProfile(body: body));
  Future<ProfileDto> updateImage(PickedImage image) =>
      _guard(() => _uploads.updateProfileImage(image));
  Future<void> deleteImage() => _guard(_api.profile.deleteProfileImage);
}

Future<T> _guard<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on Object catch (e) {
    throw ApiFailure.from(e);
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(
    ref.watch(restClientProvider),
    ref.watch(uploadsProvider),
  ),
);
