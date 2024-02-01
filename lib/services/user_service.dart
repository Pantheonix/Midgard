import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/browser_client.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/extensions/http_extensions.dart';
import 'package:midgard/models/auth/refresh_token_models.dart';
import 'package:midgard/models/exceptions/identity_exception.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/auth_service.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/services_constants.dart';
import 'package:sentry/sentry.dart';

class UserService {
  final _hiveService = locator<HiveService>();
  final _authService = locator<AuthService>();
  final _logger = getLogger('UserService');
  final _httpClient = BrowserClient()..withCredentials = true;

  Future<
      Either<
          IdentityException,
          ({
            List<UserProfileModel> users,
            int count,
          })>> getAll({
    String? name,
    String? sortBy,
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _httpClient.get(
        uriFromEnv(
          ApiConstants.baseUrl,
          ApiConstants.usersUrl,
          queryParams: {
            'name': name ?? '',
            'sortBy': sortBy ?? 'NameAsc',
            'page': page == null ? '1' : page.toString(),
            'pageSize': pageSize == null ? '10' : pageSize.toString(),
          },
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        final data = jsonDecode(response.body);
        final usersJson = data['users'] as List<dynamic>;
        final usersCount = data['totalCount'] as int;

        final users = usersJson
            .map((e) => UserProfileModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return right((
          users: users,
          count: usersCount,
        ));
      } else if (response.statusCode == HttpStatus.unauthorized) {
        _logger.e('Error while retrieving users: ${response.body}');
        await Sentry.captureException(
          Exception('Error while retrieving users: ${response.body}'),
        );

        final userProfileBox = await HiveService.userProfileBoxAsync;
        final currentUserId = _hiveService
            .getCurrentUserProfile(userProfileBox)
            .fold(() => '', (user) => user.userId);

        final refreshTokenRequest = RefreshTokenRequest(
          userId: currentUserId,
        );
        final refreshTokenResponse =
            await _authService.refreshToken(refreshTokenRequest);

        return refreshTokenResponse.fold(
          (l) => left(
            IdentityException(
              response.statusCode,
              'Session expired',
              Errors([]),
            ),
          ),
          (r) => getAll(
            name: name,
            sortBy: sortBy,
            page: page,
            pageSize: pageSize,
          ),
        );
      } else {
        _logger.e('Error while retrieving users: ${response.body}');
        await Sentry.captureException(
          Exception('Error while retrieving users: ${response.body}'),
        );

        return left(
          IdentityException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error while retrieving users: $e');
      await Sentry.captureException(
        Exception('Error while retrieving users: $e'),
      );

      return left(
        IdentityException(
          500,
          e.toString(),
          Errors([]),
        ),
      );
    }
  }

  Future<Either<IdentityException, UserProfileModel>> getById({
    required String id,
  }) async {
    try {
      final response = await _httpClient.get(
        uriFromEnv(
          ApiConstants.baseUrl,
          '${ApiConstants.usersUrl}/$id',
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        final data = jsonDecode(response.body);
        final user = UserProfileModel.fromJson(data as Map<String, dynamic>);

        return right(user);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        _logger.e('Error while retrieving user: ${response.body}');
        await Sentry.captureException(
          Exception('Error while retrieving user: ${response.body}'),
        );

        final userProfileBox = await HiveService.userProfileBoxAsync;
        final currentUserId = _hiveService
            .getCurrentUserProfile(userProfileBox)
            .fold(() => '', (user) => user.userId);

        final refreshTokenRequest = RefreshTokenRequest(
          userId: currentUserId,
        );
        final refreshTokenResponse =
            await _authService.refreshToken(refreshTokenRequest);

        return refreshTokenResponse.fold(
          (l) => left(
            IdentityException(
              response.statusCode,
              'Session expired',
              Errors([]),
            ),
          ),
          (r) => getById(id: id),
        );
      } else {
        _logger.e('Error while retrieving user: ${response.body}');
        await Sentry.captureException(
          Exception('Error while retrieving user: ${response.body}'),
        );

        return left(
          IdentityException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error while retrieving user: $e');
      await Sentry.captureException(
        Exception('Error while retrieving user: $e'),
      );

      return left(
        IdentityException(
          500,
          e.toString(),
          Errors([]),
        ),
      );
    }
  }
}
