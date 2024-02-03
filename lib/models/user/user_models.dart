import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:midgard/extensions/http_extensions.dart';
import 'package:midgard/services/services_constants.dart';
import 'package:midgard/ui/common/app_colors.dart';

part 'user_models.g.dart';

@HiveType(typeId: 0)
class UserProfileModel {
  UserProfileModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.roles,
    this.fullname,
    this.bio,
    this.profilePictureId,
  });

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : userId = json['id'] as String,
        username = json['username'] as String,
        email = json['email'] as String,
        fullname = json['fullname'] as String?,
        bio = json['bio'] as String?,
        profilePictureId = json['profilePictureId'] as String?,
        roles = (json['roles'] as List<dynamic>)
            .map((e) => UserRole.values.firstWhere((role) => role.value == e))
            .toList()
          ..add(UserRole.user)
          ..sort((a, b) => a.compareTo(b));

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
  final String? profilePictureId;

  @HiveField(6)
  final List<UserRole> roles;

  Map<String, dynamic> toJson() => {
        'id': userId,
        'username': username,
        'email': email,
        'fullname': fullname,
        'bio': bio,
        'profilePictureId': profilePictureId,
        'roles': roles.map((e) => e.value).toList(),
      };

  String get profilePictureUrl {
    final imageUrl = uriFromEnv(ApiConstants.baseUrl, ApiConstants.imageUrl);
    return '$imageUrl/$profilePictureId';
  }

  bool get isAdmin => roles.contains(UserRole.admin);

  bool get isProposer => roles.contains(UserRole.proposer);
}

@HiveType(typeId: 1)
enum UserRole {
  @HiveField(0)
  admin,
  @HiveField(1)
  proposer,
  @HiveField(2)
  user;

  String get value => switch (this) {
        UserRole.admin => 'Admin',
        UserRole.proposer => 'Proposer',
        UserRole.user => 'User',
      };

  Color get color => switch (this) {
        UserRole.admin => kcAdminBadgeColor,
        UserRole.proposer => kcProposerBadgeColor,
        UserRole.user => kcUserBadgeColor,
      };

  Map<String, dynamic> toJson() => {
        'role': value,
      };
}

extension UserRoleExtensions on UserRole {
  int compareTo(UserRole other) => index.compareTo(other.index);
}

extension UserRoleListExtensions on List<UserRole> {
  String get value => map((e) => e.value).join(', ');
}

enum SortUsersBy {
  nameAsc,
  nameDesc;

  String get value => switch (this) {
        SortUsersBy.nameAsc => 'NameAsc',
        SortUsersBy.nameDesc => 'NameDesc',
      };
}
