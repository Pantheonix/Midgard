import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/models/auth/login_models.dart';
import 'package:midgard/models/auth/register_models.dart';
import 'package:midgard/models/exceptions/auth_exception.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/services_constants.dart';

class AuthService {
  final _logger = getLogger('AuthService');
  final _httpClient = BrowserClient()..withCredentials = true;

  Future<Either<Exception, UserProfileModel>> login(
    LoginRequest request,
  ) async {
    try {
      final response = await _httpClient.post(
        Uri.http(
          ApiConstants.baseUrl,
          ApiConstants.loginUrl,
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == HttpStatus.ok) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final loginResponse = UserProfileModel.fromJson(data);
        return Right(loginResponse);
      } else {
        _logger.e('Error while login: ${response.body}');
        return Left(Exception(response.body));
      }
    } catch (e) {
      _logger.e('Error while login: $e');
      return Left(Exception(e));
    }
  }

  Future<Either<AuthException, UserProfileModel>> register(
    RegisterRequest request,
  ) async {
    try {
      final streamedResponse = await _httpClient.send(
        MultipartRequest(
          'POST',
          Uri.http(
            ApiConstants.baseUrl,
            ApiConstants.registerUrl,
          ),
        )
          ..fields['username'] = request.username
          ..fields['email'] = request.email
          ..fields['password'] = request.password,
      );
      final response = await Response.fromStream(streamedResponse);

      if (response.statusCode == HttpStatus.created) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final registerResponse = UserProfileModel.fromJson(data);
        return Right(registerResponse);
      } else {
        _logger.e('Error while register: ${response.body}');
        return Left(
          AuthException.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
          ),
        );
      }
    } catch (e) {
      _logger.e('Error while register: $e');
      return Left(
        AuthException(
          500,
          e.toString(),
          Errors([]),
        ),
      );
    }
  }
}
