class RegisterRequest {
  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  final String username;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
      };
}
