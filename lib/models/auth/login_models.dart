class LoginRequest {
  LoginRequest({
    required this.email,
    required this.password,
  });

  LoginRequest.fromJson(Map<String, dynamic> json)
      : email = json['email'] as String,
        password = json['password'] as String;

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
