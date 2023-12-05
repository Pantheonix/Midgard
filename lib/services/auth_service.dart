import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/browser_client.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/models/auth/login_models.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/api_constants.dart';

class AuthService {
  final _logger = getLogger('AuthService');
  final _httpClient = BrowserClient()..withCredentials = true;

  Future<Either<Exception, UserProfileResponse>> login(
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
        final loginResponse = UserProfileResponse.fromJson(data);
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
}
