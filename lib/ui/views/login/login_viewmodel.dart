import 'package:dartz/dartz.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/extensions/rive_bear_mixin.dart';
import 'package:midgard/models/auth/login_models.dart';
import 'package:midgard/services/auth_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/views/login/login_view.form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends FormViewModel with RiveBear {
  final _logger = getLogger('LoginViewModel');
  final _routerService = locator<RouterService>();
  final _authService = locator<AuthService>();

  var isPasswordObscured = true;

  //on click event
  Future login() async {
    _logger.i("Start login...");

    isChecking?.change(false);
    isHandsUp?.change(false);

    final res = await runBusyFuture(
      _authService.login(
        LoginRequest(
          email: emailValue ?? '',
          password: passwordValue ?? '',
        ),
      ),
      busyObject: kbLoginKey,
    );
    // allow the animation to play
    await runBusyFuture(
      Future.delayed(const Duration(milliseconds: 1500)),
      busyObject: kbLoginKey,
    );

    await runBusyFuture(
      navigateToHomeIfSuccess(res),
      busyObject: kbLoginKey,
    );
  }

  Future navigateToHomeIfSuccess(
      Either<Exception, LoginResponse> response) async {
    response.fold(
      (error) {
        _logger.e("Error while login: $error");

        failTrigger?.fire();
        throw Exception("Invalid credentials!");
      },
      (LoginResponse data) async {
        _logger.i("Login success: ${data.toJson()}");

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
}
