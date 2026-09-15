// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'cv_client.g.dart';

@RestApi()
abstract class CvClient {
  factory CvClient(Dio dio, {String? baseUrl}) = _CvClient;

  /// PDF do currículo, gerado agora a partir dos dados atuais.
  @GET('/api/v1/cv')
  @DioResponseType(ResponseType.stream)
  Stream<String> downloadCv();
}
