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
  const HomeView({super.key});

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
                    for (final asset in viewModel.assetCardsList)
                      AssetCard(
                        assetPath: asset.path,
                        assetText: asset.text,
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
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();

  @override
  void onDispose(HomeViewModel viewModel) {
    super.onDispose(viewModel);
    // Hive.close();
    viewModel.sidebarController.dispose();
  }
}
