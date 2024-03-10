import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/browser_client.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/extensions/http_extensions.dart';
import 'package:midgard/models/auth/refresh_token_models.dart';
import 'package:midgard/models/exceptions/eval_exception.dart';
import 'package:midgard/models/submission/create_submission_models.dart';
import 'package:midgard/models/submission/highest_score_submission_models.dart';
import 'package:midgard/models/submission/submission_models.dart';
import 'package:midgard/services/auth_service.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/services_constants.dart';
import 'package:sentry/sentry.dart';

typedef PaginatedSubmissions = ({
  List<SubmissionModel> submissions,
  int count,
  int totalPages,
});

class SubmissionService {
  final _hiveService = locator<HiveService>();
  final _authService = locator<AuthService>();
  final _logger = getLogger('SubmissionService');
  final _httpClient = BrowserClient()..withCredentials = true;

  Future<Either<EvalException, PaginatedSubmissions>> getAll({
    String? userId,
    String? problemId,
    String? sortBy,
    String? language,
    String? status,
    int? ltScore,
    int? gtScore,
    double? ltExecutionTime,
    double? gtExecutionTime,
    double? ltMemoryUsage,
    double? gtMemoryUsage,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? pageSize,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (userId != null) {
        queryParams['user_id'] = userId;
      }

      if (problemId != null) {
        queryParams['problem_id'] = problemId;
      }

      if (sortBy != null) {
        queryParams['sort_by'] = sortBy;
      }

      if (language != null) {
        queryParams['language'] = language;
      }

      if (status != null) {
        queryParams['status'] = status;
      }

      if (ltScore != null) {
        queryParams['lt_score'] = ltScore.toString();
      }

      if (gtScore != null) {
        queryParams['gt_score'] = gtScore.toString();
      }

      if (ltExecutionTime != null) {
        queryParams['lt_avg_time'] = ltExecutionTime.toString();
      }

      if (gtExecutionTime != null) {
        queryParams['gt_avg_time'] = gtExecutionTime.toString();
      }

      if (ltMemoryUsage != null) {
        queryParams['lt_avg_memory'] = ltMemoryUsage.toString();
      }

      if (gtMemoryUsage != null) {
        queryParams['gt_avg_memory'] = gtMemoryUsage.toString();
      }

      if (startDate != null) {
        queryParams['start_date'] =
            (startDate.millisecondsSinceEpoch / 1000).toString();
      }

      if (endDate != null) {
        queryParams['end_date'] =
            (endDate.millisecondsSinceEpoch / 1000).toString();
      }

      if (page != null) {
        queryParams['page'] = page.toString();
      }

      if (pageSize != null) {
        queryParams['per_page'] = pageSize.toString();
      }

      final response = await _httpClient.get(
        uriFromEnv(
          ApiConstants.baseUrl,
          ApiConstants.submissionsUrl,
          queryParams: queryParams,
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        final data = jsonDecode(response.body);
        final submissionsJson = data['submissions'] as List<dynamic>;
        final submissionsCount = data['items'] as int;
        final totalPages = data['total_pages'] as int;

        final submissions = submissionsJson
            .map(
              (submissionJson) => SubmissionModel.fromJson(
                submissionJson as Map<String, dynamic>,
              ),
            )
            .toList();

        return right(
          (
            submissions: submissions,
            count: submissionsCount,
            totalPages: totalPages,
          ),
        );
      } else if (response.statusCode == HttpStatus.unauthorized) {
        _logger.e('Error while getting submissions: ${response.body}');
        await Sentry.captureException(
          Exception('Error while getting submissions: ${response.body}'),
          stackTrace: StackTrace.current,
        );

        final userProfileBox = await HiveService.userProfileBoxAsync;
        final currentUserId = _hiveService
            .getCurrentUserProfile(userProfileBox)
            .fold(() => '', (user) => user.userId);

        final refreshTokenRequest = RefreshTokenRequest(
          userId: currentUserId,
        );
        final refreshTokenResponse =
            await _authService.refreshToken(request: refreshTokenRequest);

        return refreshTokenResponse.fold(
          (l) => left(
            EvalException(
              message: 'Error getting submissions',
            ),
          ),
          (r) => getAll(
            sortBy: sortBy,
            language: language,
            status: status,
            ltScore: ltScore,
            gtScore: gtScore,
            ltExecutionTime: ltExecutionTime,
            gtExecutionTime: gtExecutionTime,
            ltMemoryUsage: ltMemoryUsage,
            gtMemoryUsage: gtMemoryUsage,
            startDate: startDate,
            endDate: endDate,
            page: page,
            pageSize: pageSize,
          ),
        );
      } else {
        _logger.e('Error getting submissions: ${response.body}');
        await Sentry.captureException(
          Exception('Error getting submissions: ${response.body}'),
          stackTrace: StackTrace.current,
        );

        return left(
          EvalException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error getting submissions: $e');
      await Sentry.captureException(
        Exception('Error getting submissions: $e'),
        stackTrace: StackTrace.current,
      );

      return left(
        EvalException(
          message: 'Error getting submissions',
        ),
      );
    }
  }

  Future<Either<EvalException, SubmissionModel>> getById({
    required String submissionId,
  }) async {
    try {
      final response = await _httpClient.get(
        uriFromEnv(
          ApiConstants.baseUrl,
          '${ApiConstants.submissionsUrl}/$submissionId',
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        final submissionJson =
            jsonDecode(response.body) as Map<String, dynamic>;
        final submission = SubmissionModel.fromJson(submissionJson);

        return right(submission);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        _logger.e('Error while getting submission: ${response.body}');
        await Sentry.captureException(
          Exception('Error while getting submission: ${response.body}'),
          stackTrace: StackTrace.current,
        );

        final userProfileBox = await HiveService.userProfileBoxAsync;
        final currentUserId = _hiveService
            .getCurrentUserProfile(userProfileBox)
            .fold(() => '', (user) => user.userId);

        final refreshTokenRequest = RefreshTokenRequest(
          userId: currentUserId,
        );
        final refreshTokenResponse =
            await _authService.refreshToken(request: refreshTokenRequest);

        return refreshTokenResponse.fold(
          (l) => left(
            EvalException(
              message: 'Error getting submission',
            ),
          ),
          (r) => getById(
            submissionId: submissionId,
          ),
        );
      } else {
        _logger.e('Error getting submission: ${response.body}');
        await Sentry.captureException(
          Exception('Error getting submission: ${response.body}'),
          stackTrace: StackTrace.current,
        );

        return left(
          EvalException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error getting submission: $e');
      await Sentry.captureException(
        Exception('Error getting submission: $e'),
        stackTrace: StackTrace.current,
      );

      return left(
        EvalException(
          message: 'Error getting submission',
        ),
      );
    }
  }

  Future<Either<EvalException, ({String submissionId})>> create({
    required CreateSubmissionRequest request,
  }) async {
    try {
      final response = await _httpClient.post(
        uriFromEnv(
          ApiConstants.baseUrl,
          ApiConstants.submissionsUrl,
        ),
        body: jsonEncode(request.toJson()),
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
      );

      _logger.d(response.statusCode);

      if (response.statusCode == HttpStatus.created) {
        final submissionId = jsonDecode(response.body)['id'] as String;

        return right(
          (submissionId: submissionId),
        );
      } else if (response.statusCode == HttpStatus.unauthorized) {
        _logger.e('Error while creating submission: ${response.body}');
        await Sentry.captureException(
          Exception('Error while creating submission: ${response.body}'),
          stackTrace: StackTrace.current,
        );

        final userProfileBox = await HiveService.userProfileBoxAsync;
        final currentUserId = _hiveService
            .getCurrentUserProfile(userProfileBox)
            .fold(() => '', (user) => user.userId);

        final refreshTokenRequest = RefreshTokenRequest(
          userId: currentUserId,
        );
        final refreshTokenResponse =
            await _authService.refreshToken(request: refreshTokenRequest);

        return refreshTokenResponse.fold(
          (l) => left(
            EvalException(
              message: 'Error creating submission',
            ),
          ),
          (r) => create(
            request: request,
          ),
        );
      } else {
        _logger.e('Error creating submission: ${response.body}');
        await Sentry.captureException(
          Exception('Error creating submission: ${response.body}'),
          stackTrace: StackTrace.current,
        );

        return left(
          EvalException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error creating submission: $e');
      await Sentry.captureException(
        Exception('Error creating submission: $e'),
        stackTrace: StackTrace.current,
      );

      return left(
        EvalException(
          message: 'Error creating submission',
        ),
      );
    }
  }

  Future<Either<EvalException, List<HighestScoreSubmissionModel>>>
      getHighestScoreSubmissionsByUserId({
    required String userId,
  }) async {
    try {
      final response = await _httpClient.get(
        uriFromEnv(
          ApiConstants.baseUrl,
          '${ApiConstants.submissionsUrl}/$userId',
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        final data = jsonDecode(response.body);
        final submissionsJson = data['submissions'] as List<dynamic>;

        final submissions = submissionsJson
            .map(
              (submissionJson) => HighestScoreSubmissionModel.fromJson(
                submissionJson as Map<String, dynamic>,
              ),
            )
            .toList();

        return right(submissions);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        _logger.e(
          'Error while getting highest score submissions: ${response.body}',
        );
        await Sentry.captureException(
          Exception(
            'Error while getting highest score submissions: ${response.body}',
          ),
          stackTrace: StackTrace.current,
        );

        final userProfileBox = await HiveService.userProfileBoxAsync;
        final currentUserId = _hiveService
            .getCurrentUserProfile(userProfileBox)
            .fold(() => '', (user) => user.userId);

        final refreshTokenRequest = RefreshTokenRequest(
          userId: currentUserId,
        );
        final refreshTokenResponse =
            await _authService.refreshToken(request: refreshTokenRequest);

        return refreshTokenResponse.fold(
          (l) => left(
            EvalException(
              message: 'Error getting highest score submissions',
            ),
          ),
          (r) => getHighestScoreSubmissionsByUserId(
            userId: userId,
          ),
        );
      } else {
        _logger.e('Error getting highest score submissions: ${response.body}');
        await Sentry.captureException(
          Exception(
            'Error getting highest score submissions: ${response.body}',
          ),
          stackTrace: StackTrace.current,
        );

        return left(
          EvalException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error getting highest score submissions: $e');
      await Sentry.captureException(
        Exception('Error getting highest score submissions: $e'),
        stackTrace: StackTrace.current,
      );

      return left(
        EvalException(
          message: 'Error getting highest score submissions',
        ),
      );
    }
  }
}
