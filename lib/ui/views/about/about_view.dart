import 'package:flutter/material.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/app_strings.dart';
import 'package:midgard/ui/views/about/about_viewmodel.dart';
import 'package:midgard/ui/widgets/app_primitives/sidebar/app_sidebar.dart';
import 'package:pulsator/pulsator.dart';
import 'package:stacked/stacked.dart';

class AboutView extends StackedView<AboutViewModel> {
  const AboutView({super.key});

  @override
  Widget builder(
    BuildContext context,
    AboutViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      drawer: AppSidebar(
        controller: viewModel.sidebarController,
      ),
      backgroundColor: kcWhite,
      body: Row(
        children: [
          AppSidebar(
            controller: viewModel.sidebarController,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kdAboutViewPadding,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: kcWhite,
                          borderRadius:
                              BorderRadius.circular(kdAboutViewBorderRadius),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  kcBlack.withOpacity(kdAboutViewShadowOpacity),
                              offset: const Offset(
                                kdAboutViewShadowOffset,
                                kdAboutViewShadowOffset,
                              ),
                              blurRadius: kdAboutViewShadowBlurRadius,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          ksAssetAboutBackgroundImage,
                          fit: BoxFit.cover,
                          frameBuilder: (
                            BuildContext context,
                            Widget child,
                            int? frame,
                            bool wasSynchronouslyLoaded,
                          ) {
                            if (wasSynchronouslyLoaded) {
                              return child;
                            }
                            return AnimatedOpacity(
                              opacity: frame == null ? 0 : 1,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeOut,
                              child: child,
                            );
                          },
                        ),
                      ),
                    ),
                    const AnimatedDefaultTextStyle(
                      style: TextStyle(
                        color: kcWhite,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        letterSpacing: kdAboutViewTextLetterSpacing,
                        fontSize: kdAboutViewTextSize,
                      ),
                      curve: Curves.easeInOut,
                      duration: Duration(seconds: 3),
                      child: Padding(
                        padding: EdgeInsets.all(kdAboutViewTextPadding),
                        child: Center(
                          child: Text(ksAppAboutPoetry),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  AboutViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AboutViewModel();

  @override
  void onDispose(AboutViewModel viewModel) {
    super.onDispose(viewModel);
    // Hive.close();
    viewModel.sidebarController.dispose();
  }
}
