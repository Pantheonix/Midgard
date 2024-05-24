import 'package:dartz/dartz.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/extensions/rive_bear_mixin.dart';
import 'package:midgard/models/auth/login_models.dart';
import 'package:midgard/models/exceptions/identity_exception.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/auth_service.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/views/login/login_view.form.dart';
import 'package:sentry/sentry.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends FormViewModel with RiveBear {
  final _logger = getLogger('LoginViewModel');
  final _routerService = locator<RouterService>();
  final _authService = locator<AuthService>();
  final _hiveService = locator<HiveService>();

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarLoginMenuIndex,
    extended: true,
  );

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  bool isPasswordObscured = true;

  //on click event
  Future<void> login() async {
    _logger.i('Start login...');
    await Sentry.captureMessage('Start login...');

    isChecking?.change(false);
    isHandsUp?.change(false);

    final res = await runBusyFuture(
      _authService.login(
        request: LoginRequest(
          email: emailValue ?? '',
          password: passwordValue ?? '',
        ),
      ),
      busyObject: kbLoginKey,
    );
    // allow the animation to play
    await runBusyFuture(
      Future<void>.delayed(const Duration(milliseconds: 1500)),
      busyObject: kbLoginKey,
    );

    await runBusyFuture(
      navigateToHomeIfSuccess(res),
      busyObject: kbLoginKey,
    );
  }

  Future<void> navigateToHomeIfSuccess(
    Either<IdentityException, UserProfileModel> response,
  ) async {
    await response.fold(
      (IdentityException error) async {
        _logger.e('Error while login: ${error.toJson()}');
        await Sentry.captureException(
          Exception('Error while login: ${error.toJson()}'),
          stackTrace: StackTrace.current,
        );

        failTrigger?.fire();
        throw Exception('Invalid credentials!');
      },
      (UserProfileModel data) async {
        _logger.i('Login success: ${data.toJson()}');
        await Sentry.captureMessage('Login success: ${data.toJson()}');

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
}
