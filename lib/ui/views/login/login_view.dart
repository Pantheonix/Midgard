import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'login_view.form.dart';
import 'login_viewmodel.dart';

@FormView(
  fields: [
    FormTextField(name: 'email'),
    FormTextField(name: 'password'),
  ],
)
class LoginView extends StackedView<LoginViewModel> with $LoginView {
  const LoginView({super.key});

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: CurvedClipper(),
                  child: Container(
                    color: kcBearBackgroundColor,
                    height: 550,
                  ),
                ),
                Column(
                  children: [
                    verticalSpaceSmall,
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Pantheonix",
                              style: TextStyle(
                                fontSize: kdDesktopTitleTextSize,
                                color: kcBlack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            verticalSpaceTiny,
                            Text(
                              "Start your journey to the world of programming myths",
                              style: TextStyle(
                                fontSize: kdDesktopSubtitleTextSize,
                                color: kcBlack,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    verticalSpaceSmall,
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: RiveAnimation.asset(
                        "assets/rive/bear.riv",
                        fit: BoxFit.contain,
                        stateMachines: const ["Login Machine"],
                        onInit: (artboard) {
                          viewModel.stateMachineController =
                              StateMachineController.fromArtboard(
                            artboard,
                            "Login Machine",
                          );

                          if (viewModel.stateMachineController == null) return;

                          artboard
                              .addController(viewModel.stateMachineController!);

                          for (var element
                              in viewModel.stateMachineController!.inputs) {
                            switch (element.name) {
                              case "isChecking":
                                viewModel.isChecking = element as SMIBool;
                              case "isHandsUp":
                                viewModel.isHandsUp = element as SMIBool;
                              case "trigSuccess":
                                viewModel.successTrigger =
                                    element as SMITrigger;
                              case "trigFail":
                                viewModel.failTrigger = element as SMITrigger;
                              case "numLook":
                                viewModel.lookNum = element as SMINumber;
                            }
                          }
                        },
                      ),
                    ),
                    verticalSpaceLarge,
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 32,
                              color: kcDarkBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          verticalSpaceSmall,
                          // Email
                          TextFormField(
                            controller: emailController,
                            onChanged: (value) => viewModel.moveEyes(value),
                            focusNode: emailFocusNode,
                            cursorColor: kcBlack,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              color: kcBlack,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(12),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: kcBlack),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: kcLightGrey),
                              ),
                              label: RichText(
                                text: const TextSpan(
                                  text: "Email",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kcMediumGrey,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                        color: kcRed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          verticalSpaceSmall,
                          // Password
                          TextFormField(
                            controller: passwordController,
                            onChanged: (value) {
                              if (viewModel.isPasswordObscured) return;
                              viewModel.moveEyes(value);
                            },
                            focusNode: passwordFocusNode,
                            obscureText: viewModel.isPasswordObscured,
                            cursorColor: kcBlack,
                            style: const TextStyle(
                              color: kcBlack,
                              fontSize: 14,
                            ),
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(12),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: kcBlack),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: kcLightGrey,
                                ),
                              ),
                              label: RichText(
                                text: const TextSpan(
                                  text: "Password",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: kcMediumGrey,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                        color: kcRed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  viewModel.togglePasswordVisibility();
                                  if (passwordFocusNode.hasFocus) {
                                    viewModel.isPasswordObscured
                                        ? viewModel.handsUpOnEyes()
                                        : viewModel.lookAround();
                                  } else {
                                    viewModel.idle();
                                  }
                                },
                                icon: Icon(
                                  viewModel.isPasswordObscured
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: kcBlack,
                                ),
                              ),
                              suffixStyle: const TextStyle(
                                fontSize: 14,
                                color: kcBlack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          verticalSpaceMedium,
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await viewModel.login();

                                if (!context.mounted) return;

                                if (viewModel.hasErrorForKey(kbLoginKey)) {
                                  showFlash(
                                    context: context,
                                    duration: const Duration(seconds: 4),
                                    builder: (context, controller) {
                                      return FlashBar(
                                        controller: controller,
                                        primaryAction: TextButton(
                                          onPressed: () {
                                            controller.dismiss();
                                          },
                                          child: const Text(
                                            "Dismiss",
                                            style: TextStyle(
                                              color: kcWhite,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                        backgroundColor: Colors.redAccent,
                                        position: FlashPosition.top,
                                        behavior: FlashBehavior.fixed,
                                        forwardAnimationCurve: Curves.easeIn,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        shadowColor: kcBlack,
                                        titleTextStyle: const TextStyle(
                                          color: kcWhite,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        contentTextStyle: const TextStyle(
                                          color: kcWhite,
                                          fontSize: 16,
                                        ),
                                        title: const Text(
                                          "Error",
                                        ),
                                        content: Text(
                                          viewModel.error(kbLoginKey).message,
                                        ),
                                        iconColor: kcWhite,
                                        icon: const Icon(
                                          Icons.error_outline,
                                          color: kcWhite,
                                        ),
                                        showProgressIndicator: true,
                                        indicatorColor: kcLightGrey,
                                      );
                                    },
                                  );
                                }
                              },
                              icon: Visibility(
                                visible: viewModel.busy(kbLoginKey),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  padding: const EdgeInsets.all(2.0),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                ),
                              ),
                              label: const Text(
                                "Log in",
                                style: TextStyle(
                                  color: kcWhite,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: kcBlack,
                              ),
                            ),
                          ),
                          verticalSpaceSmall,
                          RichText(
                            text: const TextSpan(
                              text: "Don't have account?",
                              style: TextStyle(
                                fontSize: 14,
                                color: kcMediumGrey,
                              ),
                              children: [
                                TextSpan(
                                  text: " Create now",
                                  style: TextStyle(
                                    color: kcBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onViewModelReady(LoginViewModel viewModel) {
    syncFormWithViewModel(viewModel);

    emailFocusNode.addListener(() {
      emailFocusNode.hasFocus ? viewModel.lookAround() : viewModel.idle();
    });
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        viewModel.isPasswordObscured
            ? viewModel.handsUpOnEyes()
            : viewModel.lookAround();
      } else {
        viewModel.idle();
      }
    });
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();

  @override
  void onDispose(LoginViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.75);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.5,
      0,
      size.height * 0.75,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
