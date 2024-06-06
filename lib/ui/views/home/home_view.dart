import 'package:badges/badges.dart' as badges;
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/app_strings.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/home/home_viewmodel.dart';
import 'package:midgard/ui/widgets/app_primitives/sidebar/app_sidebar.dart';
import 'package:midgard/ui/widgets/home/asset_card.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StackedView<HomeViewModel> {
  HomeView({
    this.warningMessage,
    super.key,
  });

  late String? warningMessage;

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      drawer: AppSidebar(
        controller: viewModel.sidebarController,
      ),
      backgroundColor: kcWhite,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(kdHomeViewPadding),
        child: badges.Badge(
          showBadge: warningMessage != null,
          badgeContent: const Icon(
            Icons.circle,
            size: kdHomeViewWarningBadgeIconSize,
            color: kcRed,
          ),
          badgeAnimation: const badges.BadgeAnimation.scale(
            animationDuration: Duration(
              seconds: kiHomeViewWarningBadgeAnimationDurationSec,
            ),
            colorChangeAnimationDuration: Duration(
              seconds: kiHomeViewWarningBadgeColorChangeAnimationDurationSec,
            ),
            colorChangeAnimationCurve: Curves.easeInOut,
          ),
          badgeStyle: const badges.BadgeStyle(
            badgeColor: kcRed,
          ),
          child: FloatingActionButton(
            onPressed: () async {
              if (warningMessage != null) {
                await context.showInfoBar(
                  position: FlashPosition.top,
                  indicatorColor: kcRed,
                  content: Text(warningMessage!),
                  primaryActionBuilder: (context, controller) {
                    return IconButton(
                      onPressed: () {
                        warningMessage = null;
                        viewModel.rebuildUi();
                        controller.dismiss();
                      },
                      icon: const Icon(Icons.close),
                    );
                  },
                );
              }
            },
            child: const Icon(
              Icons.notification_important,
              size: kdHomeViewWarningIconSize,
              color: kcOrange,
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          AppSidebar(
            controller: viewModel.sidebarController,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kdHomeViewPadding,
                ),
                child: Column(
                  children: [
                    verticalSpaceSmall,
                    const Text(
                      ksAppTitle,
                      style: TextStyle(
                        color: kcBlack,
                        fontSize: kdHomeViewTitleTextSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    verticalSpaceTiny,
                    const Text(
                      ksAppMotto2,
                      style: TextStyle(
                        color: kcBlack,
                        fontSize: kdHomeViewSubtitleTextSize,
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: kiHomeViewGridCrossAxisCount,
                        crossAxisSpacing: kdHomeViewGridCrossAxisSpacing,
                        mainAxisSpacing: kdHomeViewGridMainAxisSpacing,
                        childAspectRatio: kdHomeViewGridChildAspectRatio,
                      ),
                      itemCount: viewModel.assetCardsList.length,
                      itemBuilder: (context, index) {
                        final asset = viewModel.assetCardsList[index];
                        return AssetCard(
                          assetPath: asset.path,
                          assetText: asset.text,
                        );
                      },
                    ),
                    // Enable this code snippet to allow the parallax effect
                    // for (final asset in viewModel.assetCardsList)
                    //   AssetCard(
                    //     assetPath: asset.path,
                    //     assetText: asset.text,
                    //   ),
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
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();

  @override
  void onDispose(HomeViewModel viewModel) {
    super.onDispose(viewModel);

    viewModel.sidebarController.dispose();
  }
}
