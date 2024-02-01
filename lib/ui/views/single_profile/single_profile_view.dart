import 'package:flutter/material.dart';
import 'package:midgard/ui/views/single_profile/single_profile_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SingleProfileView extends StackedView<SingleProfileViewModel> {
  const SingleProfileView({super.key});

  @override
  Widget builder(
    BuildContext context,
    SingleProfileViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      ),
    );
  }

  @override
  SingleProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SingleProfileViewModel();
}
