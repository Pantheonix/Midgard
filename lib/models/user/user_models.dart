class UserProfileResponse {
  UserProfileResponse({
    required this.userId,
    required this.username,
    required this.email,
    this.fullname,
    this.bio,
    this.profilePictureUrl,
  });

  UserProfileResponse.fromJson(Map<String, dynamic> json)
      : userId = json['id'] as String,
        username = json['username'] as String,
        email = json['email'] as String,
        fullname = json['fullname'] as String?,
        bio = json['bio'] as String?,
        profilePictureUrl = json['profilePictureUrl'] as String?;

  final String userId;
  final String username;
  final String email;
  final String? fullname;
  final String? bio;
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
