import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/extensions/rive_bear_mixin.dart';
import 'package:midgard/ui/views/login/login_view.form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends FormViewModel with RiveBear {
  final _logger = getLogger('LoginViewModel');
  final _routerService = locator<RouterService>();

  var isPasswordObscured = true;

  //on click event
  void login() async {
    _logger.i("Start login...");

    isChecking?.change(false);
    isHandsUp?.change(false);

    setBusy(true);
    await Future.delayed(const Duration(seconds: 2), () {
      setBusy(false);
    });

    if (emailValue == 'admin@gmail.com' && passwordValue == "admin") {
      //happy face
      successTrigger?.fire();

      await Future.delayed(const Duration(seconds: 1), () {
        _routerService.replaceWith(const HomeViewRoute());
      });
    } else {
      //sad face
      failTrigger?.fire();
    }
  }

  void togglePasswordVisibility() {
    isPasswordObscured = !isPasswordObscured;
    rebuildUi();
  }
}
