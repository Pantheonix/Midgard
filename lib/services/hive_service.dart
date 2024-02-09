import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/browser_client.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/extensions/http_extensions.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/services_constants.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sentry/sentry.dart';

class HiveService {
  final _logger = getLogger('HiveService');
  final _httpClient = BrowserClient()..withCredentials = true;

  static Future<void> init() async {
    if (!kIsWeb) {
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
    }

    Hive
      ..registerAdapter(UserProfileModelAdapter())
      ..registerAdapter(UserRoleAdapter())
      ..registerAdapter(ProblemModelAdapter())
      ..registerAdapter(IoTypeAdapter())
      ..registerAdapter(DifficultyAdapter())
      ..registerAdapter(TestModelAdapter());

    await Hive.openBox<UserProfileModel>(HiveConstants.userProfileBox);
    await Hive.openBox<Uint8List>(HiveConstants.userAvatarBox);
    await Hive.openBox<ProblemModel>(HiveConstants.problemBox);
  }

  static Future<Box<UserProfileModel>> get userProfileBoxAsync =>
      Hive.openBox<UserProfileModel>(
        HiveConstants.userProfileBox,
      );

  static Future<Box<Uint8List>> get userAvatarBoxAsync =>
      Hive.openBox<Uint8List>(
        HiveConstants.userAvatarBox,
      );

  static ValueListenable<Box<UserProfileModel>> get userProfileBoxListenable =>
      Hive.box<UserProfileModel>(
        HiveConstants.userProfileBox,
      ).listenable();

  static ValueListenable<Box<Uint8List>> get userAvatarBox =>
      Hive.box<Uint8List>(
        HiveConstants.userAvatarBox,
      ).listenable();

  static Future<Box<ProblemModel>> get problemBoxAsync =>
      Hive.openBox<ProblemModel>(
        HiveConstants.problemBox,
      );

  static ValueListenable<Box<ProblemModel>> get problemBoxListenable =>
      Hive.box<ProblemModel>(
        HiveConstants.problemBox,
      ).listenable();

  Future<void> saveCurrentUserProfile(UserProfileModel userProfile) async {
    final profileBox =
        await Hive.openBox<UserProfileModel>(HiveConstants.userProfileBox);
    await profileBox.put(HiveConstants.currentUserProfile, userProfile);

    if (userProfile.profilePictureId == null) return;

    final response = await _httpClient.get(
      uriFromEnv(
        ApiConstants.baseUrl,
        '${ApiConstants.imageUrl}/${userProfile.profilePictureId}',
      ),
    );
    _logger.i('Avatar response: ${response.statusCode}');
    await Sentry.captureMessage('Avatar response: ${response.statusCode}');

    if (response.statusCode != HttpStatus.ok) return;

    final avatarBox = await Hive.openBox<Uint8List>(
      HiveConstants.userAvatarBox,
    );
    await avatarBox.put(
      HiveConstants.currentUserAvatarData,
      response.bodyBytes,
    );
  }

  Option<UserProfileModel> getCurrentUserProfile([Box<UserProfileModel>? box]) {
    box ??= Hive.box<UserProfileModel>(HiveConstants.userProfileBox);
    final userProfile = box.get(HiveConstants.currentUserProfile);

    return switch (userProfile) {
      final data? => some(data),
      null => none(),
    };
  }

  Option<Uint8List> getCurrentUserAvatarBlob() {
    final box = Hive.box<Uint8List>(HiveConstants.userAvatarBox);
    final avatarData = box.get(HiveConstants.currentUserAvatarData);

    return switch (avatarData) {
      final data? => some(data),
      null => none(),
    };
  }

  Future<void> saveUserProfile(UserProfileModel userProfile) async {
    final profileBox =
        await Hive.openBox<UserProfileModel>(HiveConstants.userProfileBox);
    await profileBox.put(userProfile.userId, userProfile);

    if (userProfile.profilePictureId == null) return;

    final response = await _httpClient.get(
      uriFromEnv(
        ApiConstants.baseUrl,
        '${ApiConstants.imageUrl}/${userProfile.profilePictureId}',
      ),
    );
    _logger.i('Avatar response: ${response.statusCode}');
    await Sentry.captureMessage('Avatar response: ${response.statusCode}');

    if (response.statusCode != HttpStatus.ok) return;

    final avatarBox = await Hive.openBox<Uint8List>(
      HiveConstants.userAvatarBox,
    );
    await avatarBox.put(
      userProfile.userId,
      response.bodyBytes,
    );
  }

  Option<UserProfileModel> getUserProfile(
    String userId, [
    Box<UserProfileModel>? box,
  ]) {
    box ??= Hive.box<UserProfileModel>(HiveConstants.userProfileBox);
    final userProfile = box.get(userId);

    return switch (userProfile) {
      final data? => some(data),
      null => none(),
    };
  }

  Option<Uint8List> getUserAvatarBlob(
    String userId, [
    Box<Uint8List>? box,
  ]) {
    box ??= Hive.box<Uint8List>(HiveConstants.userAvatarBox);
    final avatarData = box.get(userId);

    return switch (avatarData) {
      final data? => some(data),
      null => none(),
    };
  }

  Future<void> saveProblem(
    ProblemModel problem, [
    Box<ProblemModel>? box,
  ]) async {
    box ??= await Hive.openBox<ProblemModel>(
      HiveConstants.problemBox,
    );
    await box.put(problem.id, problem);
  }

  Option<ProblemModel> getProblem(
    String problemId, [
    Box<ProblemModel>? box,
  ]) {
    box ??= Hive.box<ProblemModel>(HiveConstants.problemBox);
    final problem = box.get(problemId);

    return switch (problem) {
      final data? => some(data),
      null => none(),
    };
  }

  Future<void> clearCurrentUserProfile() async {
    final profileBox =
        await Hive.openBox<UserProfileModel>(HiveConstants.userProfileBox);
    await profileBox.delete(HiveConstants.currentUserProfile);

    final avatarBox =
        await Hive.openBox<Uint8List>(HiveConstants.userAvatarBox);
    await avatarBox.delete(HiveConstants.currentUserAvatarData);
  }
}
