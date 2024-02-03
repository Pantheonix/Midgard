import 'package:dartz/dartz.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/extensions/rive_bear_mixin.dart';
import 'package:midgard/models/auth/register_models.dart';
import 'package:midgard/models/exceptions/identity_exception.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/models/validators/user_validators.dart';
import 'package:midgard/services/auth_service.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/views/register/register_view.form.dart';
import 'package:sentry/sentry.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterViewModel extends FormViewModel with RiveBear {
  final _logger = getLogger('RegisterViewModel');
  final _routerService = locator<RouterService>();
  final _authService = locator<AuthService>();
  final _hiveService = locator<HiveService>();

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarRegisterMenuIndex,
    extended: true,
  );

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;

  //on click event
  Future<void> register() async {
    _logger.i('Start register...');
    await Sentry.captureMessage('Start register...');

    isChecking?.change(false);
    isHandsUp?.change(false);

    // check client validation rules
    await runBusyFuture(
      _validate(),
      busyObject: kbRegisterKey,
    );

    if (_hasAnyValidationMessage) {
      failTrigger?.fire();
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
    Either<IdentityException, UserProfileModel> response,
  ) async {
    await response.fold(
      (IdentityException error) async {
        _logger.e('Error while register: ${error.toJson()}');
        await Sentry.captureException(
          Exception('Error while register: ${error.toJson()}'),
        );

        failTrigger?.fire();
        throw Exception(
          'Unable to register new account: ${error.errors.asString}',
        );
      },
      (UserProfileModel data) async {
        _logger.i('Register success: ${data.toJson()}');
        await Sentry.captureMessage('Register success: ${data.toJson()}');

        // save user data to hive
        await _hiveService.saveCurrentUserProfile(data);

        successTrigger?.fire();

        await Future.delayed(
          const Duration(seconds: 1),
          _routerService.replaceWithHomeView,
        );
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
        UserValidators.validateConfirmPassword(
      confirmPasswordValue,
      passwordValue,
    );
    if (confirmPasswordValidationMessage != null) {
      throw Exception(confirmPasswordValidationMessage);
    }
  }

  bool get _hasAnyValidationMessage =>
      hasAnyValidationMessage ||
      UserValidators.validateConfirmPassword(
            confirmPasswordValue,
            passwordValue,
          ) !=
          null;
}
