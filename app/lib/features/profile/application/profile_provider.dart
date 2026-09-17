import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/profile_dto.dart';
import '../../../api/models/update_profile_dto.dart';
import '../../../core/network/uploads.dart';
import '../data/profile_repository.dart';

/// O Profile público. Mantido vivo: home e painel compartilham.
final profileProvider = FutureProvider<ProfileDto>(
  (ref) => ref.watch(profileRepositoryProvider).get(),
);

/// Mutações do admin; cada uma atualiza o cache do profileProvider.
class ProfileEditor {
  ProfileEditor(this._ref);
  final Ref _ref;

  ProfileRepository get _repo => _ref.read(profileRepositoryProvider);

  Future<ProfileDto> save(UpdateProfileDto body) async =>
      _publish(await _repo.update(body));

  Future<ProfileDto> replaceImage(PickedImage image) async =>
      _publish(await _repo.updateImage(image));

  Future<void> removeImage() async {
    await _repo.deleteImage();
    _ref.invalidate(profileProvider);
  }

  ProfileDto _publish(ProfileDto profile) {
    _ref.invalidate(profileProvider);
    return profile;
  }
}

final profileEditorProvider = Provider<ProfileEditor>(ProfileEditor.new);
