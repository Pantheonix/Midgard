import 'package:dartz/dartz.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/extensions/rive_bear_mixin.dart';
import 'package:midgard/models/auth/register_models.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/auth_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/views/register/register_view.form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterViewModel extends FormViewModel with RiveBear {
  final _logger = getLogger('RegisterViewModel');
  final _routerService = locator<RouterService>();
  final _authService = locator<AuthService>();

  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;

  //on click event
  Future<void> register() async {
    _logger.i('Start login...');

    isChecking?.change(false);
    isHandsUp?.change(false);

    // check client validation rules
    await runBusyFuture(
      _validate(),
      busyObject: kbRegisterKey,
    );

    if (_hasAnyValidationMessage) {
      return;
    }

    final res = await runBusyFuture(
      _authService.register(
        RegisterRequest(
          username: usernameValue ?? '',
          email: emailValue ?? '',
          password: passwordValue ?? '',
        ),
      ),
      busyObject: kbRegisterKey,
    );
    // allow the animation to play
    await runBusyFuture(
      Future<void>.delayed(const Duration(milliseconds: 1500)),
      busyObject: kbRegisterKey,
    );

    await runBusyFuture(
      navigateToHomeIfSuccess(res),
      busyObject: kbRegisterKey,
    );
  }

  Future<void> navigateToHomeIfSuccess(
    Either<Exception, UserProfileResponse> response,
  ) async {
    await response.fold(
      (error) {
        _logger.e('Error while register: $error');

        failTrigger?.fire();
        throw Exception('Invalid credentials!');
      },
      (UserProfileResponse data) async {
        _logger.i('Register success: ${data.toJson()}');

        successTrigger?.fire();

        await Future.delayed(const Duration(seconds: 1), () {
          _routerService.replaceWith(const HomeViewRoute());
        });
      },
    );
  }

  void togglePasswordVisibility() {
    isPasswordObscured = !isPasswordObscured;
    rebuildUi();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscured = !isConfirmPasswordObscured;
    rebuildUi();
  }

  void navigateToLogin() {
    _routerService.replaceWith(const LoginViewRoute());
  }

  Future<void> _validate() async {
    if (hasUsernameValidationMessage) {
      throw Exception(usernameValidationMessage);
    }

    if (hasEmailValidationMessage) {
      throw Exception(emailValidationMessage);
    }

    if (hasPasswordValidationMessage) {
      throw Exception(passwordValidationMessage);
    }

    final confirmPasswordValidationMessage =
        RegisterValidators.validateConfirmPassword(
      confirmPasswordValue,
      passwordValue,
    );
    if (confirmPasswordValidationMessage != null) {
      throw Exception(confirmPasswordValidationMessage);
    }
  }

  bool get _hasAnyValidationMessage =>
      hasAnyValidationMessage ||
      RegisterValidators.validateConfirmPassword(
            confirmPasswordValue,
            passwordValue,
          ) !=
          null;
}

class RegisterValidators {
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required!';
    }

    if (value.length < kMinUsernameLength) {
      return 'Username must be at least 3 characters long!';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required!';
    }

    if (!RegExp(kEmailRegex).hasMatch(value)) {
      return 'Email must be a valid email address!';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required!';
    }

    if (value.length < kMinPasswordLength ||
        value.length > kMaxPasswordLength ||
        !RegExp(kPasswordRegex).hasMatch(value)) {
      return 'Password must be at least 6 characters long, contain at least one'
          ' uppercase letter, one lowercase letter, one number '
          'and one special character!';
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String? password,
  ) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required!';
    }

    if (value != password) {
      return 'Confirm password must match password!';
    }

    return null;
  }
}
