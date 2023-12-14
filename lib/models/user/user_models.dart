import 'package:hive/hive.dart';

part 'user_models.g.dart';

@HiveType(typeId: 0)
class UserProfileModel {
  UserProfileModel({
    required this.userId,
    required this.username,
    required this.email,
    this.fullname,
    this.bio,
    this.profilePictureUrl,
  });

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : userId = json['id'] as String,
        username = json['username'] as String,
        email = json['email'] as String,
        fullname = json['fullname'] as String?,
        bio = json['bio'] as String?,
        profilePictureUrl = json['profilePictureUrl'] as String?;

  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? fullname;

  @HiveField(4)
  final String? bio;

  @HiveField(5)
  final String? profilePictureUrl;

  Map<String, dynamic> toJson() => {
        'id': userId,
        'username': username,
        'email': email,
        'fullname': fullname,
        'bio': bio,
        'profilePictureUrl': profilePictureUrl,
      };
}
