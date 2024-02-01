import 'package:flash/flash.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/app_strings.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/register/register_view.form.dart';
import 'package:midgard/ui/views/register/register_viewmodel.dart';
import 'package:midgard/ui/widgets/app_primitives/curved_clipper.dart';
import 'package:midgard/ui/widgets/app_primitives/sidebar/app_sidebar.dart';
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
      drawer: AppSidebar(
        controller: viewModel.sidebarController,
      ),
      backgroundColor: kcWhite,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSidebar(
            controller: viewModel.sidebarController,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipPath(
                        clipper: CurvedClipper(),
                        child: Container(
                          color: kcBearBackgroundColor,
                          height: kdRegisterViewClipperHeight,
                        ),
                      ),
                      Column(
                        children: [
                          verticalSpaceSmall,
                          _buildPageHeader(),
                          verticalSpaceSmall,
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height *
                                kdRegisterViewRiveAnimationHeightPercentage,
                            child: _buildRiveAnimation(viewModel),
                          ),
                          verticalSpaceMassive,
                          Container(
                            padding: const EdgeInsets.all(
                              kdRegisterViewFormContainerPadding,
                            ),
                            child: Column(
                              children: [
                                _buildFormHeader(),
                                verticalSpaceSmall,
                                Row(
                                  children: [
                                    _buildUsernameField(viewModel),
                                    horizontalSpaceMedium,
                                    _buildEmailField(viewModel),
                                  ],
                                ),
                                verticalSpaceSmall,
                                Row(
                                  children: [
                                    _buildPasswordField(viewModel),
                                    horizontalSpaceMedium,
                                    _buildConfirmPasswordField(viewModel),
                                  ],
                                ),
                                verticalSpaceMedium,
                                SizedBox(
                                  width: kdRegisterViewSendButtonWidth,
                                  height: kdRegisterViewSendButtonHeight,
                                  child: _buildRegisterButton(
                                    context,
                                    viewModel,
                                  ),
                                ),
                                verticalSpaceSmall,
                                _buildFormFooter(viewModel),
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
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return const Column(
      children: [
        Text(
          ksAppTitle,
          style: TextStyle(
            fontSize: kdDesktopTitleTextSize,
            color: kcBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        verticalSpaceTiny,
        Text(
          ksAppMotto1,
          style: TextStyle(
            fontSize: kdDesktopSubtitleTextSize,
            color: kcBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildRiveAnimation(RegisterViewModel viewModel) {
    return RiveAnimation.asset(
      ksRiveBearPath,
      fit: BoxFit.contain,
      stateMachines: const [ksRiveBearStateMachineName],
      onInit: (artboard) {
        viewModel.stateMachineController = StateMachineController.fromArtboard(
          artboard,
          ksRiveBearStateMachineName,
        );

        if (viewModel.stateMachineController == null) {
          return;
        }

        artboard.addController(viewModel.stateMachineController!);

        for (final element in viewModel.stateMachineController!.inputs) {
          switch (element.name) {
            case ksRiveBearIsCheckingInputName:
              viewModel.isChecking = element as SMIBool;
            case ksRiveBearIsHandsUpInputName:
              viewModel.isHandsUp = element as SMIBool;
            case ksRiveBearTrigSuccessInputName:
              viewModel.successTrigger = element as SMITrigger;
            case ksRiveBearTrigFailInputName:
              viewModel.failTrigger = element as SMITrigger;
            case ksRiveBearNumLookInputName:
              viewModel.lookNum = element as SMINumber;
          }
        }
      },
    );
  }

  Widget _buildFormHeader() {
    return const Text(
      ksRegisterViewFormHeaderText,
      style: TextStyle(
        fontSize: kdLoginViewFormHeaderTextSize,
        color: kcDarkBlue,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildUsernameField(RegisterViewModel viewModel) {
    return Expanded(
      child: Column(
        children: [
          TextFormField(
            controller: usernameController,
            onChanged: (value) => viewModel.moveEyes(value),
            focusNode: usernameFocusNode,
            cursorColor: kcBlack,
            style: const TextStyle(
              color: kcBlack,
              fontSize: kdRegisterViewUsernameFieldTextSize,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(
                kdRegisterViewUsernameFieldPadding,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              focusedBorder: const UnderlineInputBorder(),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kcLightGrey),
              ),
              label: RichText(
                text: const TextSpan(
                  text: ksRegisterViewUsernameFieldLabelText,
                  style: TextStyle(
                    fontSize: kdRegisterViewUsernameFieldLabelTextSize,
                    color: kcMediumGrey,
                  ),
                  children: [
                    TextSpan(
                      text: ksRegisterViewUsernameFieldExtraText,
                      style: TextStyle(
                        color: kcRed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          if (viewModel.hasUsernameValidationMessage) ...[
            verticalSpaceTiny,
            Text(
              viewModel.usernameValidationMessage!,
              style: const TextStyle(
                color: kcRed,
                fontSize: KdRegisterViewUsernameFieldValidationTextSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmailField(RegisterViewModel viewModel) {
    return Expanded(
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
              fontSize: kdRegisterViewEmailFieldTextSize,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(
                kdRegisterViewEmailFieldPadding,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              focusedBorder: const UnderlineInputBorder(),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kcLightGrey),
              ),
              label: RichText(
                text: const TextSpan(
                  text: ksRegisterViewEmailFieldLabelText,
                  style: TextStyle(
                    fontSize: kdRegisterViewEmailFieldLabelTextSize,
                    color: kcMediumGrey,
                  ),
                  children: [
                    TextSpan(
                      text: ksRegisterViewEmailFieldExtraText,
                      style: TextStyle(
                        color: kcRed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          if (viewModel.hasEmailValidationMessage) ...[
            verticalSpaceTiny,
            Text(
              viewModel.emailValidationMessage!,
              style: const TextStyle(
                color: kcRed,
                fontSize: KdRegisterViewEmailFieldValidationTextSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPasswordField(RegisterViewModel viewModel) {
    return Expanded(
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
              fontSize: kdRegisterViewPasswordFieldTextSize,
            ),
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(
                kdRegisterViewPasswordFieldPadding,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              focusedBorder: const UnderlineInputBorder(),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kcLightGrey,
                ),
              ),
              label: RichText(
                text: const TextSpan(
                  text: ksRegisterViewPasswordFieldLabelText,
                  style: TextStyle(
                    fontSize: kdRegisterViewPasswordFieldLabelTextSize,
                    color: kcMediumGrey,
                  ),
                  children: [
                    TextSpan(
                      text: ksRegisterViewPasswordFieldExtraText,
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
                fontSize: kdRegisterViewPasswordFieldSuffixIconSize,
                color: kcBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          if (viewModel.hasPasswordValidationMessage) ...[
            verticalSpaceTiny,
            Text(
              viewModel.passwordValidationMessage!,
              style: const TextStyle(
                color: kcRed,
                fontSize: KdRegisterViewPasswordFieldValidationTextSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConfirmPasswordField(RegisterViewModel viewModel) {
    return Expanded(
      child: Column(
        children: [
          TextFormField(
            controller: confirmPasswordController,
            onChanged: (value) {
              if (viewModel.isConfirmPasswordObscured) {
                return;
              }
              viewModel.moveEyes(
                value + kRiveMoveEyesPadding,
              );
            },
            focusNode: confirmPasswordFocusNode,
            obscureText: viewModel.isConfirmPasswordObscured,
            cursorColor: kcBlack,
            style: const TextStyle(
              color: kcBlack,
              fontSize: kdRegisterViewConfirmPasswordFieldTextSize,
            ),
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(
                kdRegisterViewConfirmPasswordFieldPadding,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              focusedBorder: const UnderlineInputBorder(),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kcLightGrey,
                ),
              ),
              label: RichText(
                text: const TextSpan(
                  text: ksRegisterViewConfirmPasswordFieldLabelText,
                  style: TextStyle(
                    fontSize: kdRegisterViewConfirmPasswordFieldLabelTextSize,
                    color: kcMediumGrey,
                  ),
                  children: [
                    TextSpan(
                      text: ksRegisterViewConfirmPasswordFieldExtraText,
                      style: TextStyle(
                        color: kcRed,
                      ),
                    ),
                  ],
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  viewModel.toggleConfirmPasswordVisibility();
                  if (confirmPasswordFocusNode.hasFocus) {
                    viewModel.isConfirmPasswordObscured
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
                fontSize: kdRegisterViewConfirmPasswordFieldSuffixIconSize,
                color: kcBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
            textInputAction: TextInputAction.done,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          if (viewModel.hasConfirmPasswordValidationMessage) ...[
            verticalSpaceTiny,
            Text(
              viewModel.confirmPasswordValidationMessage!,
              style: const TextStyle(
                color: kcRed,
                fontSize: KdRegisterViewPasswordFieldValidationTextSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRegisterButton(
    BuildContext context,
    RegisterViewModel viewModel,
  ) {
    return ElevatedButton.icon(
      onPressed: () async {
        await viewModel.register();

        if (!context.mounted) return;

        if (viewModel.hasErrorForKey(kbRegisterKey)) {
          await showFlash(
            context: context,
            duration: const Duration(seconds: kiRegisterViewSnackbarDuration),
            builder: (context, controller) {
              return FlashBar(
                controller: controller,
                primaryAction: TextButton(
                  onPressed: () {
                    controller.dismiss();
                  },
                  child: const Text(
                    ksRegisterViewSnackbarDismissText,
                    style: TextStyle(
                      color: kcWhite,
                      fontSize: kdRegisterViewSnackbarDismissTextSize,
                    ),
                  ),
                ),
                backgroundColor: Colors.redAccent,
                position: FlashPosition.top,
                forwardAnimationCurve: Curves.easeIn,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    kdRegisterViewSnackbarShapeRadius,
                  ),
                ),
                shadowColor: kcBlack,
                titleTextStyle: const TextStyle(
                  color: kcWhite,
                  fontSize: kdRegisterViewSnackbarTitleTextSize,
                  fontWeight: FontWeight.bold,
                ),
                contentTextStyle: const TextStyle(
                  color: kcWhite,
                  fontSize: kdRegisterViewSnackbarTitleTextSize,
                ),
                title: const Text(
                  ksRegisterViewSnackbarTitleText,
                ),
                content: Text(
                  viewModel.error(kbRegisterKey).message as String,
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
          width: kdRegisterViewSendButtonLoadingIndicatorWidth,
          height: kdRegisterViewSendButtonLoadingIndicatorHeight,
          padding: const EdgeInsets.all(
            kdRegisterViewSendButtonLoadingIndicatorPadding,
          ),
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: kdRegisterViewSendButtonLoadingIndicatorStrokeWidth,
          ),
        ),
      ),
      label: const Text(
        ksRegisterViewSendButtonText,
        style: TextStyle(
          color: kcWhite,
        ),
      ),
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: kdRegisterViewSendButtonTextSize,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            kdRegisterViewSendButtonShapeRadius,
          ),
        ),
        backgroundColor: kcBlack,
      ),
    );
  }

  Widget _buildFormFooter(RegisterViewModel viewModel) {
    return RichText(
      text: TextSpan(
        text: ksRegisterViewFormFooterText,
        style: const TextStyle(
          fontSize: kdRegisterViewFormFooterTextSize,
          color: kcMediumGrey,
        ),
        children: [
          TextSpan(
            text: ksRegisterViewFormFooterLinkText,
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
    );
  }

  @override
  Future<void> onViewModelReady(RegisterViewModel viewModel) async {
    final userProfileBox = await HiveService.userProfileBoxAsync;
    if (viewModel.hiveService.getCurrentUserProfile(userProfileBox).isSome()) {
      await viewModel.navigateToHome();
    }

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
    // Hive.close();
    disposeForm();
    viewModel.sidebarController.dispose();
  }
}
