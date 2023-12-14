import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/views/home/home_viewmodel.dart';
import 'package:midgard/ui/widgets/app_primitives/app_sidebar.dart';
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
        routerService: viewModel.routerService,
        hiveService: viewModel.hiveService,
      ),
      backgroundColor: kcWhite,
      body: Row(
        children: [
          AppSidebar(
            controller: viewModel.sidebarController,
            routerService: viewModel.routerService,
            hiveService: viewModel.hiveService,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final asset in viewModel.assetCardsList)
                    AssetCard(
                      assetPath: asset.path,
                      assetText: asset.text,
                    ),
                ],
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
    Hive.close();
    viewModel.sidebarController.dispose();
  }
}
