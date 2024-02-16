import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/extensions/http_extensions.dart';
import 'package:midgard/models/auth/refresh_token_models.dart';
import 'package:midgard/models/exceptions/problem_exception.dart';
import 'package:midgard/models/problem/create_problem_models.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/models/problem/update_problem_models.dart';
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
            .toList()
          ..forEach(_hiveService.saveProblem);

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
          stackTrace: StackTrace.current,
        );

        return left(
          ProblemException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error while retrieving problems: $e');
      await Sentry.captureException(
        Exception('Error while retrieving problems: $e'),
        stackTrace: e is Error ? null : StackTrace.current,
      );

      return left(
        ProblemException(
          'Error while retrieving problems',
          null,
          [],
        ),
      );
    }
  }

  Future<Either<ProblemException, ProblemModel>> getById({
    required String problemId,
  }) async {
    try {
      final response = await _httpClient.get(
        uriFromEnv(
          ApiConstants.baseUrl,
          '${ApiConstants.problemsUrl}/$problemId',
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        final problemJson = jsonDecode(response.body) as Map<String, dynamic>;
        final problem = ProblemModel.fromJson(problemJson);

        return right(problem);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        _logger.e('Error while retrieving problem: ${response.body}');
        await Sentry.captureException(
          Exception('Error while retrieving problem: ${response.body}'),
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
            ProblemException(
              'Session expired',
              null,
              [],
            ),
          ),
          (r) => getById(problemId: problemId),
        );
      } else {
        _logger.e('Error while retrieving problem: ${response.body}');
        await Sentry.captureException(
          Exception('Error while retrieving problem: ${response.body}'),
          stackTrace: StackTrace.current,
        );

        return left(
          ProblemException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error while retrieving problem: $e');
      await Sentry.captureException(
        Exception('Error while retrieving problem: $e'),
        stackTrace: e is Error ? null : StackTrace.current,
      );

      return left(
        ProblemException(
          'Error while retrieving problem',
          null,
          [],
        ),
      );
    }
  }

  Future<
      Either<
          ProblemException,
          ({
            List<ProblemModel> problems,
            int count,
          })>> getAllUnpublished({
    String? name,
    String? difficulty,
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _httpClient.get(
        uriFromEnv(
          ApiConstants.baseUrl,
          ApiConstants.unpublishedProblemsUrl,
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
            .toList()
          ..forEach(_hiveService.saveProblem);

        return right(
          (
            problems: problems,
            count: problemsCount,
          ),
        );
      } else if (response.statusCode == HttpStatus.unauthorized) {
        _logger.e(
          'Error while retrieving unpublished problems: ${response.body}',
        );
        await Sentry.captureException(
          Exception(
            'Error while retrieving unpublished problems: ${response.body}',
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
            ProblemException(
              'Session expired',
              null,
              [],
            ),
          ),
          (r) => getAllUnpublished(
            name: name,
            difficulty: difficulty,
            page: page,
            pageSize: pageSize,
          ),
        );
      } else {
        _logger.e(
          'Error while retrieving unpublished problems: ${response.body}',
        );
        await Sentry.captureException(
          Exception(
            'Error while retrieving unpublished problems: ${response.body}',
          ),
          stackTrace: StackTrace.current,
        );

        return left(
          ProblemException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error while retrieving unpublished problems: $e');
      await Sentry.captureException(
        Exception('Error while retrieving unpublished problems: $e'),
        stackTrace: e is Error ? null : StackTrace.current,
      );

      return left(
        ProblemException(
          'Error while retrieving unpublished problems',
          null,
          [],
        ),
      );
    }
  }

  Future<Either<ProblemException, ProblemModel>> getByIdUnpublished({
    required String problemId,
  }) async {
    try {
      final response = await _httpClient.get(
        uriFromEnv(
          ApiConstants.baseUrl,
          ApiConstants.unpublishedProblemUrl.replaceFirst(
            ':id',
            problemId,
          ),
        ),
      );

      if (response.statusCode == HttpStatus.ok) {
        final problemJson = jsonDecode(response.body) as Map<String, dynamic>;
        final problem = ProblemModel.fromJson(problemJson);

        return right(problem);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        _logger.e(
          'Error while retrieving unpublished problem: ${response.body}',
        );
        await Sentry.captureException(
          Exception(
            'Error while retrieving unpublished problem: ${response.body}',
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
            ProblemException(
              'Session expired',
              null,
              [],
            ),
          ),
          (r) => getByIdUnpublished(problemId: problemId),
        );
      } else {
        _logger.e(
          'Error while retrieving unpublished problem: ${response.body}',
        );
        await Sentry.captureException(
          Exception(
            'Error while retrieving unpublished problem: ${response.body}',
          ),
          stackTrace: StackTrace.current,
        );

        return left(
          ProblemException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e(
        'Error while retrieving unpublished problem: $e',
      );
      await Sentry.captureException(
        Exception(
          'Error while retrieving unpublished problem: $e',
        ),
        stackTrace: e is Error ? null : StackTrace.current,
      );

      return left(
        ProblemException(
          'Error while retrieving unpublished problem',
          null,
          [],
        ),
      );
    }
  }

  Future<Either<ProblemException, ProblemModel>> create({
    required CreateProblemRequest request,
  }) async {
    try {
      final response = await _httpClient.post(
        uriFromEnv(
          ApiConstants.baseUrl,
          ApiConstants.problemsUrl,
        ),
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == HttpStatus.ok) {
        final problemJson = jsonDecode(response.body) as Map<String, dynamic>;
        final problem = ProblemModel.fromJson(problemJson);

        return right(problem);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        _logger.e('Error while creating problem: ${response.body}');
        await Sentry.captureException(
          Exception('Error while creating problem: ${response.body}'),
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
            ProblemException(
              'Session expired',
              null,
              [],
            ),
          ),
          (r) => create(request: request),
        );
      } else {
        _logger.e('Error while creating problem: ${response.body}');
        await Sentry.captureException(
          Exception('Error while creating problem: ${response.body}'),
          stackTrace: StackTrace.current,
        );

        return left(
          ProblemException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error while creating problem: $e');
      await Sentry.captureException(
        Exception('Error while creating problem: $e'),
        stackTrace: e is Error ? null : StackTrace.current,
      );

      return left(
        ProblemException(
          'Error while creating problem',
          null,
          [],
        ),
      );
    }
  }

  Future<Either<ProblemException, ProblemModel>> addTest({
    required String problemId,
    required AddTestRequest request,
  }) async {
    try {
      final (:bytes, :mimeType, :filename) = request.archiveFile;
      final multipartFile = MultipartFile.fromBytes(
        'archiveFile',
        bytes,
        filename: filename,
        contentType: MediaType.parse(mimeType),
      );

      final multipartRequest = MultipartRequest(
        'POST',
        uriFromEnv(
          ApiConstants.baseUrl,
          ApiConstants.testsUrl.replaceFirst(':id', problemId),
        ),
      )
        ..fields['score'] = request.score.toString()
        ..files.add(multipartFile);

      final streamedResponse = await _httpClient.send(multipartRequest);
      final response = await Response.fromStream(streamedResponse);

      if (response.statusCode == HttpStatus.ok) {
        final problemJson = jsonDecode(response.body) as Map<String, dynamic>;
        final problem = ProblemModel.fromJson(problemJson);

        return right(problem);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        _logger.e('Error while adding test: ${response.body}');
        await Sentry.captureException(
          Exception('Error while adding test: ${response.body}'),
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
            ProblemException(
              'Session expired',
              null,
              [],
            ),
          ),
          (r) => addTest(
            problemId: problemId,
            request: request,
          ),
        );
      } else {
        _logger.e('Error while adding test: ${response.body}');
        await Sentry.captureException(
          Exception('Error while adding test: ${response.body}'),
          stackTrace: StackTrace.current,
        );

        return left(
          ProblemException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error while adding test: $e');
      await Sentry.captureException(
        Exception('Error while adding test: $e'),
        stackTrace: e is Error ? null : StackTrace.current,
      );

      return left(
        ProblemException(
          'Error while adding test',
          null,
          [],
        ),
      );
    }
  }

  Future<Either<ProblemException, ProblemModel>> update({
    required String problemId,
    required UpdateProblemRequest request,
  }) async {
    try {
      final response = await _httpClient.put(
        uriFromEnv(
          ApiConstants.baseUrl,
          '${ApiConstants.problemsUrl}/$problemId',
        ),
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == HttpStatus.ok) {
        final problemJson = jsonDecode(response.body) as Map<String, dynamic>;
        final problem = ProblemModel.fromJson(problemJson);

        return right(problem);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        _logger.e('Error while updating problem: ${response.body}');
        await Sentry.captureException(
          Exception('Error while updating problem: ${response.body}'),
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
            ProblemException(
              'Session expired',
              null,
              [],
            ),
          ),
          (r) => update(
            problemId: problemId,
            request: request,
          ),
        );
      } else {
        _logger.e('Error while updating problem: ${response.body}');
        await Sentry.captureException(
          Exception('Error while updating problem: ${response.body}'),
          stackTrace: StackTrace.current,
        );

        return left(
          ProblemException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error while updating problem: $e');
      await Sentry.captureException(
        Exception('Error while updating problem: $e'),
        stackTrace: e is Error ? null : StackTrace.current,
      );

      return left(
        ProblemException(
          'Error while updating problem',
          null,
          [],
        ),
      );
    }
  }

  Future<Either<ProblemException, ProblemModel>> updateTest({
    required String problemId,
    required int testId,
    required UpdateTestRequest request,
  }) async {
    try {
      final multipartRequest = MultipartRequest(
        'PUT',
        uriFromEnv(
          ApiConstants.baseUrl,
          '${ApiConstants.testsUrl.replaceFirst(':id', problemId)}/$testId',
        ),
      );

      if (request.score.isSome()) {
        multipartRequest.fields['score'] = request.score
            .getOrElse(
              () => 0,
            )
            .toString();
      }

      if (request.archiveFile.isSome()) {
        final (:bytes, :mimeType, :filename) = request.archiveFile.getOrElse(
          () => (
            bytes: Uint8List(0),
            mimeType: '',
            filename: '',
          ),
        );
        final multipartFile = MultipartFile.fromBytes(
          'archiveFile',
          bytes,
          contentType: MediaType.parse(mimeType),
          filename: filename,
        );
        multipartRequest.files.add(multipartFile);
      }

      final streamedResponse = await _httpClient.send(multipartRequest);
      final response = await Response.fromStream(streamedResponse);

      if (response.statusCode == HttpStatus.ok) {
        final data = jsonDecode(response.body);
        final problem = ProblemModel.fromJson(data as Map<String, dynamic>);

        return right(problem);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        _logger.e('Error while updating test: ${response.body}');
        await Sentry.captureException(
          Exception('Error while updating test: ${response.body}'),
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
            ProblemException(
              'Session expired',
              null,
              [],
            ),
          ),
          (r) => updateTest(
            problemId: problemId,
            testId: testId,
            request: request,
          ),
        );
      } else {
        _logger.e('Error while updating test: ${response.body}');
        await Sentry.captureException(
          Exception('Error while updating test: ${response.body}'),
          stackTrace: StackTrace.current,
        );

        return left(
          ProblemException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error while updating test: $e');
      await Sentry.captureException(
        Exception('Error while updating test: $e'),
        stackTrace: e is Error ? null : StackTrace.current,
      );

      return left(
        ProblemException(
          'Error while updating test',
          null,
          [],
        ),
      );
    }
  }

  Future<Either<ProblemException, Unit>> publish({
    required String problemId,
  }) async =>
      _updatePublishingStatus(
        problemId: problemId,
        publishingStatus: true,
      );

  Future<Either<ProblemException, Unit>> unpublish({
    required String problemId,
  }) async =>
      _updatePublishingStatus(
        problemId: problemId,
        publishingStatus: false,
      );

  Future<Either<ProblemException, Unit>> _updatePublishingStatus({
    required String problemId,
    required bool publishingStatus,
  }) async {
    try {
      final response = await _httpClient.put(
        uriFromEnv(
          ApiConstants.baseUrl,
          '${ApiConstants.problemsUrl}/$problemId',
        ),
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
        body: jsonEncode({
          'isPublished': publishingStatus,
        }),
      );

      if (response.statusCode == HttpStatus.ok) {
        return right(unit);
      } else if (response.statusCode == HttpStatus.unauthorized) {
        _logger.e('Error while updating problem: ${response.body}');
        await Sentry.captureException(
          Exception('Error while updating problem: ${response.body}'),
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
            ProblemException(
              'Session expired',
              null,
              [],
            ),
          ),
          (r) => _updatePublishingStatus(
            problemId: problemId,
            publishingStatus: publishingStatus,
          ),
        );
      } else {
        _logger.e('Error while updating problem: ${response.body}');
        await Sentry.captureException(
          Exception('Error while updating problem: ${response.body}'),
          stackTrace: StackTrace.current,
        );

        return left(
          ProblemException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error while updating problem: $e');
      await Sentry.captureException(
        Exception('Error while updating problem: $e'),
        stackTrace: e is Error ? null : StackTrace.current,
      );

      return left(
        ProblemException(
          'Error while updating problem',
          null,
          [],
        ),
      );
    }
  }
}
