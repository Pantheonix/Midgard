abstract class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    "API_BASE_URL",
    defaultValue: "",
  );

  static const String loginUrl = "/api/identity/auth/login";
}
