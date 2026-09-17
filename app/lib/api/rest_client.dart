// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/auth_client.dart';
import 'clients/profile_client.dart';
import 'clients/projects_client.dart';
import 'clients/skills_client.dart';
import 'clients/experiences_client.dart';
import 'clients/educations_client.dart';
import 'clients/offerings_client.dart';
import 'clients/contact_client.dart';
import 'clients/cv_client.dart';

/// Portfolio API `v1`.
///
/// Contrato da API do portfólio. Ver .specs/GLOBAL.md.
class RestClient {
  RestClient(Dio dio, {String? baseUrl}) : _dio = dio, _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => '1';

  AuthClient? _auth;
  ProfileClient? _profile;
  ProjectsClient? _projects;
  SkillsClient? _skills;
  ExperiencesClient? _experiences;
  EducationsClient? _educations;
  OfferingsClient? _offerings;
  ContactClient? _contact;
  CvClient? _cv;

  AuthClient get auth => _auth ??= AuthClient(_dio, baseUrl: _baseUrl);

  ProfileClient get profile =>
      _profile ??= ProfileClient(_dio, baseUrl: _baseUrl);

  ProjectsClient get projects =>
      _projects ??= ProjectsClient(_dio, baseUrl: _baseUrl);

  SkillsClient get skills => _skills ??= SkillsClient(_dio, baseUrl: _baseUrl);

  ExperiencesClient get experiences =>
      _experiences ??= ExperiencesClient(_dio, baseUrl: _baseUrl);

  EducationsClient get educations =>
      _educations ??= EducationsClient(_dio, baseUrl: _baseUrl);

  OfferingsClient get offerings =>
      _offerings ??= OfferingsClient(_dio, baseUrl: _baseUrl);

  ContactClient get contact =>
      _contact ??= ContactClient(_dio, baseUrl: _baseUrl);

  CvClient get cv => _cv ??= CvClient(_dio, baseUrl: _baseUrl);
}
