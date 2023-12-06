import 'package:flash/flash.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/login/login_view.dart';
import 'package:midgard/ui/views/register/register_view.form.dart';
import 'package:midgard/ui/views/register/register_viewmodel.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

@FormView(
  fields: [
    FormTextField(
      name: 'username',
      validator: RegisterValidators.validateUsername,
    ),
    FormTextField(
      name: 'email',
      validator: RegisterValidators.validateEmail,
    ),
    FormTextField(
      name: 'password',
      validator: RegisterValidators.validatePassword,
    ),
    FormTextField(
      name: 'confirmPassword',
    ),
  ],
)
class RegisterView extends StackedView<RegisterViewModel> with $RegisterView {
  const RegisterView({super.key});

  @override
  Widget builder(
    BuildContext context,
    RegisterViewModel viewModel,
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
                      children: [
                        Column(
                          children: [
                            Text(
                              'Pantheonix',
                              style: TextStyle(
                                fontSize: kdDesktopTitleTextSize,
                                color: kcBlack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            verticalSpaceTiny,
                            Text(
                              'Start your journey to the world of programming myths',
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
                        'assets/rive/bear.riv',
                        fit: BoxFit.contain,
                        stateMachines: const ['Login Machine'],
                        onInit: (artboard) {
                          viewModel.stateMachineController =
                              StateMachineController.fromArtboard(
                            artboard,
                            'Login Machine',
                          );

                          if (viewModel.stateMachineController == null) return;

                          artboard
                              .addController(viewModel.stateMachineController!);

                          for (final element
                              in viewModel.stateMachineController!.inputs) {
                            switch (element.name) {
                              case 'isChecking':
                                viewModel.isChecking = element as SMIBool;
                              case 'isHandsUp':
                                viewModel.isHandsUp = element as SMIBool;
                              case 'trigSuccess':
                                viewModel.successTrigger =
                                    element as SMITrigger;
                              case 'trigFail':
                                viewModel.failTrigger = element as SMITrigger;
                              case 'numLook':
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
                            'Register',
                            style: TextStyle(
                              fontSize: 32,
                              color: kcDarkBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          verticalSpaceSmall,
                          Row(
                            children: [
                              // Username
                              Expanded(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: usernameController,
                                      onChanged: (value) =>
                                          viewModel.moveEyes(value),
                                      focusNode: usernameFocusNode,
                                      cursorColor: kcBlack,
                                      style: const TextStyle(
                                        color: kcBlack,
                                        fontSize: 14,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(12),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                        focusedBorder:
                                            const UnderlineInputBorder(),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: kcLightGrey),
                                        ),
                                        label: RichText(
                                          text: const TextSpan(
                                            text: 'Username',
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
                                    if (viewModel
                                        .hasUsernameValidationMessage) ...[
                                      verticalSpaceTiny,
                                      Text(
                                        viewModel.usernameValidationMessage!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              horizontalSpaceMedium,
                              // Email
                              Expanded(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: emailController,
                                      onChanged: (value) => viewModel.moveEyes(
                                        value + kRiveMoveEyesPadding,
                                      ),
                                      focusNode: emailFocusNode,
                                      cursorColor: kcBlack,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(
                                        color: kcBlack,
                                        fontSize: 14,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(12),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                        focusedBorder:
                                            const UnderlineInputBorder(),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: kcLightGrey),
                                        ),
                                        label: RichText(
                                          text: const TextSpan(
                                            text: 'Email',
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
                                    if (viewModel
                                        .hasEmailValidationMessage) ...[
                                      verticalSpaceTiny,
                                      Text(
                                        viewModel.emailValidationMessage!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          verticalSpaceSmall,
                          Row(
                            children: [
                              // Password
                              Expanded(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: passwordController,
                                      onChanged: (value) {
                                        if (viewModel.isPasswordObscured) {
                                          return;
                                        }
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
                                        contentPadding:
                                            const EdgeInsets.all(12),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                        focusedBorder:
                                            const UnderlineInputBorder(),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: kcLightGrey,
                                          ),
                                        ),
                                        label: RichText(
                                          text: const TextSpan(
                                            text: 'Password',
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
                                            viewModel
                                                .togglePasswordVisibility();
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
                                    if (viewModel
                                        .hasPasswordValidationMessage) ...[
                                      verticalSpaceTiny,
                                      Text(
                                        viewModel.passwordValidationMessage!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              horizontalSpaceMedium,
                              // Confirm Password
                              Expanded(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: confirmPasswordController,
                                      onChanged: (value) {
                                        if (viewModel
                                            .isConfirmPasswordObscured) {
                                          return;
                                        }
                                        viewModel.moveEyes(
                                          value + kRiveMoveEyesPadding,
                                        );
                                      },
                                      focusNode: confirmPasswordFocusNode,
                                      obscureText:
                                          viewModel.isConfirmPasswordObscured,
                                      cursorColor: kcBlack,
                                      style: const TextStyle(
                                        color: kcBlack,
                                        fontSize: 14,
                                      ),
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(12),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                        focusedBorder:
                                            const UnderlineInputBorder(),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: kcLightGrey,
                                          ),
                                        ),
                                        label: RichText(
                                          text: const TextSpan(
                                            text: 'Confirm Password',
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
                                            viewModel
                                                .toggleConfirmPasswordVisibility();
                                            if (confirmPasswordFocusNode
                                                .hasFocus) {
                                              viewModel
                                                      .isConfirmPasswordObscured
                                                  ? viewModel.handsUpOnEyes()
                                                  : viewModel.lookAround();
                                            } else {
                                              viewModel.idle();
                                            }
                                          },
                                          icon: Icon(
                                            viewModel.isConfirmPasswordObscured
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
                                      textInputAction: TextInputAction.done,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                    ),
                                    if (viewModel
                                        .hasConfirmPasswordValidationMessage) ...[
                                      verticalSpaceTiny,
                                      Text(
                                        viewModel
                                            .confirmPasswordValidationMessage!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          verticalSpaceMedium,
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await viewModel.register();

                                if (!context.mounted) return;

                                if (viewModel.hasErrorForKey(kbRegisterKey)) {
                                  await showFlash(
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
                                            'Dismiss',
                                            style: TextStyle(
                                              color: kcWhite,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                        backgroundColor: Colors.redAccent,
                                        position: FlashPosition.top,
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
                                          'Error',
                                        ),
                                        content: Text(
                                          viewModel.error(kbRegisterKey).message
                                              as String,
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
                                visible: viewModel.busy(kbRegisterKey),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  padding: const EdgeInsets.all(2),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                ),
                              ),
                              label: const Text(
                                'Register',
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
                            text: TextSpan(
                              text: 'Already have an account?',
                              style: const TextStyle(
                                fontSize: 14,
                                color: kcMediumGrey,
                              ),
                              children: [
                                TextSpan(
                                  text: ' Login now',
                                  style: const TextStyle(
                                    color: kcBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      viewModel.navigateToLogin();
                                    },
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
  void onViewModelReady(RegisterViewModel viewModel) {
    syncFormWithViewModel(viewModel);

    usernameFocusNode.addListener(() {
      usernameFocusNode.hasFocus ? viewModel.lookAround() : viewModel.idle();
    });
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
    confirmPasswordFocusNode.addListener(() {
      if (confirmPasswordFocusNode.hasFocus) {
        viewModel.isConfirmPasswordObscured
            ? viewModel.handsUpOnEyes()
            : viewModel.lookAround();
      } else {
        viewModel.idle();
      }
    });
  }

  @override
  RegisterViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RegisterViewModel();

  @override
  void onDispose(RegisterViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }
}
