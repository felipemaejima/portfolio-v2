import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/models/profile_dto.dart';
import '../../api/models/project_dto.dart';
import 'dio.dart';

/// Um arquivo escolhido pelo usuário, como bytes: funciona em web e mobile.
class PickedImage {
  const PickedImage({required this.bytes, required this.filename});
  final Uint8List bytes;
  final String filename;
}

/// As ÚNICAS chamadas escritas à mão (APP.md §3): os endpoints multipart são
/// removidos do contrato antes da geração porque o gerador usaria
/// `dart:io File`, inexistente no Flutter Web.
class Uploads {
  Uploads(this._dio);
  final Dio _dio;

  /// PUT /profile/image
  Future<ProfileDto> updateProfileImage(PickedImage image) async {
    final form = FormData.fromMap({'file': _part(image)});
    final res = await _dio.put<Map<String, Object?>>('/api/v1/profile/image', data: form);
    return ProfileDto.fromJson(res.data!);
  }

  /// POST /projects/{id}/images
  Future<ProjectDto> addProjectImages(String projectId, List<PickedImage> images) async {
    final form = FormData();
    for (final image in images) {
      form.files.add(MapEntry('files', _part(image)));
    }
    final res = await _dio.post<Map<String, Object?>>('/api/v1/projects/$projectId/images', data: form);
    return ProjectDto.fromJson(res.data!);
  }

  static MultipartFile _part(PickedImage image) =>
      MultipartFile.fromBytes(image.bytes, filename: image.filename);
}

final uploadsProvider = Provider<Uploads>((ref) => Uploads(ref.watch(dioProvider)));
