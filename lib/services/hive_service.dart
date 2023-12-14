import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/services_constants.dart';

class HiveService {
  static Future<Box<UserProfileModel>> get userProfileBox =>
      Hive.openBox<UserProfileModel>(HiveConstants.userProfileBox);

  Future<void> saveUserProfile(UserProfileModel userProfileResponse) async {
    final box =
        await Hive.openBox<UserProfileModel>(HiveConstants.userProfileBox);
    await box.put(HiveConstants.currentUserProfile, userProfileResponse);
  }

  Option<UserProfileModel> getCurrentUserProfile() {
    final box = Hive.box<UserProfileModel>(HiveConstants.userProfileBox);
    final userProfile = box.get(HiveConstants.currentUserProfile);

    return switch (userProfile) {
      final data? => some(data),
      null => none(),
    };
  }

  Future<void> clearUserProfile() async {
    final box =
        await Hive.openBox<UserProfileModel>(HiveConstants.userProfileBox);
    await box.delete(HiveConstants.currentUserProfile);
  }
}
