import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/app_strings.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/login/login_view.form.dart';
import 'package:midgard/ui/views/login/login_viewmodel.dart';
import 'package:midgard/ui/widgets/app_primitives/curved_clipper.dart';
import 'package:midgard/ui/widgets/app_primitives/sidebar/app_sidebar.dart';
import 'package:rive/rive.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

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
                          height: kdLoginViewClipperHeight,
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
                                kdLoginViewRiveAnimationHeightPercentage,
                            child: _buildRiveAnimation(viewModel),
                          ),
                          verticalSpaceMassive,
                          Container(
                            padding: const EdgeInsets.all(
                              kdLoginViewFormContainerPadding,
                            ),
                            child: Column(
                              children: [
                                _buildFormHeader(),
                                verticalSpaceSmall,
                                _buildEmailField(viewModel),
                                verticalSpaceSmall,
                                _buildPasswordField(viewModel),
                                verticalSpaceMedium,
                                SizedBox(
                                  width: kdLoginViewSendButtonWidth,
                                  height: kdLoginViewSendButtonHeight,
                                  child: _buildLoginButton(context, viewModel),
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

  Widget _buildRiveAnimation(LoginViewModel viewModel) {
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
      ksLoginViewFormHeaderText,
      style: TextStyle(
        fontSize: kdLoginViewFormHeaderTextSize,
        color: kcDarkBlue,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildEmailField(LoginViewModel viewModel) {
    return TextFormField(
      controller: emailController,
      onChanged: (value) => viewModel.moveEyes(value),
      focusNode: emailFocusNode,
      cursorColor: kcBlack,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        color: kcBlack,
        fontSize: kdLoginViewEmailFieldTextSize,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(kdLoginViewEmailFieldPadding),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusedBorder: const UnderlineInputBorder(),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: kcLightGrey),
        ),
        label: RichText(
          text: const TextSpan(
            text: ksLoginViewEmailFieldLabelText,
            style: TextStyle(
              fontSize: kdLoginViewEmailFieldLabelTextSize,
              color: kcMediumGrey,
            ),
            children: [
              TextSpan(
                text: ksLoginViewEmailFieldExtraText,
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
    );
  }

  Widget _buildPasswordField(LoginViewModel viewModel) {
    return TextFormField(
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
        fontSize: kdLoginViewPasswordFieldTextSize,
      ),
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(kdLoginViewPasswordFieldPadding),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusedBorder: const UnderlineInputBorder(),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: kcLightGrey,
          ),
        ),
        label: RichText(
          text: const TextSpan(
            text: ksLoginViewPasswordFieldLabelText,
            style: TextStyle(
              fontSize: kdLoginViewPasswordFieldLabelTextSize,
              color: kcMediumGrey,
            ),
            children: [
              TextSpan(
                text: ksLoginViewPasswordFieldExtraText,
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
          fontSize: kdLoginViewPasswordFieldSuffixIconSize,
          color: kcBlack,
          fontWeight: FontWeight.bold,
        ),
      ),
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    LoginViewModel viewModel,
  ) {
    return ElevatedButton.icon(
      onPressed: () async {
        await viewModel.login();

        if (!context.mounted) return;

        if (viewModel.hasErrorForKey(kbLoginKey)) {
          await context.showErrorBar(
            position: FlashPosition.top,
            indicatorColor: kcRed,
            content: Text(
              viewModel.error(kbLoginKey).message as String,
            ),
            primaryActionBuilder: (context, controller) {
              return IconButton(
                onPressed: controller.dismiss,
                icon: const Icon(Icons.close),
              );
            },
          );
        }
      },
      icon: Visibility(
        visible: viewModel.busy(kbLoginKey),
        child: Container(
          width: kdLoginViewSendButtonLoadingIndicatorWidth,
          height: kdLoginViewSendButtonLoadingIndicatorHeight,
          padding: const EdgeInsets.all(
            kdLoginViewSendButtonLoadingIndicatorPadding,
          ),
          child: const CircularProgressIndicator(
            color: kcWhite,
            strokeWidth: kdLoginViewSendButtonLoadingIndicatorStrokeWidth,
          ),
        ),
      ),
      label: const Text(
        ksLoginViewSendButtonText,
        style: TextStyle(
          color: kcWhite,
        ),
      ),
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: kdLoginViewSendButtonTextSize,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            kdLoginViewSendButtonShapeRadius,
          ),
        ),
        backgroundColor: kcBlack,
      ),
    );
  }

  Widget _buildFormFooter(LoginViewModel viewModel) {
    return RichText(
      text: TextSpan(
        text: ksLoginViewFormFooterText,
        style: const TextStyle(
          fontSize: kdLoginViewFormFooterTextSize,
          color: kcMediumGrey,
        ),
        children: [
          TextSpan(
            text: ksLoginViewFormFooterLinkText,
            style: const TextStyle(
              color: kcBlack,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await viewModel.routerService.replaceWithRegisterView();
              },
          ),
        ],
      ),
    );
  }

  @override
  Future<void> onViewModelReady(LoginViewModel viewModel) async {
    super.onViewModelReady(viewModel);

    final userProfileBox = await HiveService.userProfileBoxAsync;
    if (viewModel.hiveService.getCurrentUserProfile(userProfileBox).isSome()) {
      await viewModel.routerService.replaceWithHomeView(
        warningMessage: ksAppAlreadyAuthenticatedRedirectMessage,
      );
    }

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
    // Hive.close();
    disposeForm();
    viewModel.sidebarController.dispose();
  }
}
