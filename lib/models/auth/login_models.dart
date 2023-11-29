class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  LoginRequest.fromJson(Map<String, dynamic> json)
      : email = json["email"],
        password = json["password"];

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

class LoginResponse {
  final String userId;
  final String username;
  final String email;
  final String? fullname;
  final String? bio;
  final String? profilePictureUrl;

  LoginResponse({
    required this.userId,
    required this.username,
    required this.email,
    this.fullname,
    this.bio,
    this.profilePictureUrl,
  });

  LoginResponse.fromJson(Map<String, dynamic> json)
      : userId = json["id"],
        username = json["username"],
        email = json["email"],
        fullname = json["fullname"],
        bio = json["bio"],
        profilePictureUrl = json["profilePictureUrl"];

  Map<String, dynamic> toJson() => {
        "id": userId,
        "username": username,
        "email": email,
        "fullname": fullname,
        "bio": bio,
        "profilePictureUrl": profilePictureUrl,
      };
}
