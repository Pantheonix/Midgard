abstract class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );

  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
  );
  static const String sentryEnvironment = String.fromEnvironment(
    'SENTRY_ENVIRONMENT',
  );

  static const String loginUrl = '/api/identity/auth/login';
  static const String registerUrl = '/api/identity/auth/register';
  static const String imageUrl = '/api/identity/images';
}

abstract class HiveConstants {
  static const String userProfileBox = 'userProfileBox';
  static const String userAvatarBox = 'userAvatarBox';
  static const String currentUserProfile = 'currentUserProfile';
  static const String currentUserAvatarData = 'currentUserAvatarData';
}
