class RegisterRequest {
  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  RegisterRequest.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        email = json['email'] as String,
        password = json['password'] as String;

  final String username;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
      };
}
