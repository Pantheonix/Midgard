import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/browser_client.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/extensions/http_extensions.dart';
import 'package:midgard/models/auth/refresh_token_models.dart';
import 'package:midgard/models/exceptions/problem_exception.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/services/auth_service.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/services_constants.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:sentry/sentry.dart';

class ProblemService {
  final _hiveService = locator<HiveService>();
  final _authService = locator<AuthService>();
  final _logger = getLogger('ProblemService');
  final _httpClient = BrowserClient()..withCredentials = true;

  Future<
      Either<
          ProblemException,
          ({
            List<ProblemModel> problems,
            int count,
          })>> getAll({
    String? name,
    String? difficulty,
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _httpClient.get(
        uriFromEnv(
          ApiConstants.baseUrl,
          ApiConstants.problemsUrl,
          queryParams: {
            'Name': name ?? '',
            'Difficulty': difficulty ?? '',
            'SkipCount': page == null
                ? '0'
                : ((page - 1) * kiProblemsViewPageSize).toString(),
            'MaxResultCount': pageSize == null
                ? kiProblemsViewPageSize.toString()
                : pageSize.toString(),
          },
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        final data = jsonDecode(response.body);
        final problemsJson = data['items'] as List<dynamic>;
        final problemsCount = data['totalCount'] as int;

        final problems = problemsJson
            .map(
              (problemJson) =>
                  ProblemModel.fromJson(problemJson as Map<String, dynamic>),
            )
            .toList();

        return right(
          (
            problems: problems,
            count: problemsCount,
          ),
        );
      } else if (response.statusCode == HttpStatus.unauthorized) {
        _logger.e('Error while retrieving problems: ${response.body}');
        await Sentry.captureException(
          Exception('Error while retrieving problems: ${response.body}'),
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
            ProblemException(
              'Session expired',
              null,
              [],
            ),
          ),
          (r) => getAll(
            name: name,
            difficulty: difficulty,
            page: page,
            pageSize: pageSize,
          ),
        );
      } else {
        _logger.e('Error while retrieving problems: ${response.body}');
        await Sentry.captureException(
          Exception('Error while retrieving problems: ${response.body}'),
        );

        return left(
          ProblemException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error getting problems: $e');
      await Sentry.captureException(
        Exception('Error getting problems: $e'),
        stackTrace: e is Error ? null : StackTrace.current,
      );

      return left(
        ProblemException(
          'Error getting problems',
          null,
          [],
        ),
      );
    }
  }
}
