abstract class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );

  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
  );
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
  );

  static const String loginUrl = '/api/identity/auth/login';
  static const String registerUrl = '/api/identity/auth/register';
  static const String refreshTokenUrl = '/api/identity/auth/refresh-token';
  static const String imageUrl = '/api/identity/images';
  static const String usersUrl = '/api/identity/users';
  static const String rolesUrl = '/api/identity/users/:id/role';
  static const String problemsUrl = '/api/problems';
  static const String unpublishedProblemsUrl = '/api/problems/unpublished';
  static const String unpublishedProblemUrl = '/api/problems/:id/unpublished';
}

abstract class HiveConstants {
  static const String userProfileBox = 'userProfileBox';
  static const String userAvatarBox = 'userAvatarBox';
  static const String problemBox = 'problemBox';

  static const String currentUserProfile = 'currentUserProfile';
  static const String currentUserAvatarData = 'currentUserAvatarData';
}
