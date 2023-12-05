abstract class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );

  static const String loginUrl = '/api/identity/auth/login';
  static const String registerUrl = '/api/identity/auth/register';
}
