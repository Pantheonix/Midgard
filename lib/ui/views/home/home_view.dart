import 'package:flutter/material.dart';
import 'package:midgard/ui/views/home/home_view.desktop.dart';
import 'package:midgard/ui/views/home/home_view.mobile.dart';
import 'package:midgard/ui/views/home/home_view.tablet.dart';
import 'package:midgard/ui/views/home/home_viewmodel.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return ScreenTypeLayout.builder(
      mobile: (_) => const HomeViewMobile(),
      tablet: (_) => const HomeViewTablet(),
      desktop: (_) => const HomeViewDesktop(),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
