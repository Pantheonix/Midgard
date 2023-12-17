import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:http/browser_client.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/services_constants.dart';

class HiveService {
  final _logger = getLogger('HiveService');
  final _httpClient = BrowserClient()..withCredentials = true;

  static Future<Box<UserProfileModel>> get userProfileBox =>
      Hive.openBox<UserProfileModel>(
        HiveConstants.userProfileBox,
      );
  static Future<Box<Uint8List>> get avatarDataBox => Hive.openBox<Uint8List>(
        HiveConstants.userAvatarBox,
      );

  Future<void> saveUserProfile(UserProfileModel userProfile) async {
    final profileBox =
        await Hive.openBox<UserProfileModel>(HiveConstants.userProfileBox);
    await profileBox.put(HiveConstants.currentUserProfile, userProfile);

    if (userProfile.profilePictureId == null) return;

    final response = await _httpClient.get(
      Uri.http(
        ApiConstants.baseUrl,
        '${ApiConstants.imageUrl}/${userProfile.profilePictureId}',
      ),
    );
    _logger.i('Avatar response: ${response.statusCode}');

    if (response.statusCode != HttpStatus.ok) return;

    final avatarBox = await Hive.openBox<Uint8List>(
      HiveConstants.userAvatarBox,
    );
    await avatarBox.put(
      HiveConstants.currentUserAvatarData,
      response.bodyBytes,
    );
  }

  Option<UserProfileModel> getCurrentUserProfile() {
    final box = Hive.box<UserProfileModel>(HiveConstants.userProfileBox);
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

  Future<void> clearUserProfile() async {
    final profileBox =
        await Hive.openBox<UserProfileModel>(HiveConstants.userProfileBox);
    await profileBox.delete(HiveConstants.currentUserProfile);

    final avatarBox =
        await Hive.openBox<Uint8List>(HiveConstants.userAvatarBox);
    await avatarBox.delete(HiveConstants.currentUserAvatarData);
  }
}