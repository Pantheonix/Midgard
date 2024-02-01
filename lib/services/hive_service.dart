import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/browser_client.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/extensions/http_extensions.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/services_constants.dart';
import 'package:sentry/sentry.dart';

class HiveService {
  final _logger = getLogger('HiveService');
  final _httpClient = BrowserClient()..withCredentials = true;

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

  Option<UserProfileModel> getCurrentUserProfile(Box<UserProfileModel> box) {
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

  Option<UserProfileModel> getUserProfile(String userId) {
    final box = Hive.box<UserProfileModel>(HiveConstants.userProfileBox);
    final userProfile = box.get(userId);

    return switch (userProfile) {
      final data? => some(data),
      null => none(),
    };
  }

  Option<Uint8List> getUserAvatarBlob(String userId) {
    final box = Hive.box<Uint8List>(HiveConstants.userAvatarBox);
    final avatarData = box.get(userId);

    return switch (avatarData) {
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
