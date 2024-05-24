import 'package:flutter/material.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/unknown/unknown_viewmodel.dart';
import 'package:stacked/stacked.dart';

class UnknownViewTablet extends ViewModelWidget<UnknownViewModel> {
  const UnknownViewTablet({super.key});

  @override
  Widget build(BuildContext context, UnknownViewModel viewModel) {
    return const Scaffold(
      backgroundColor: kcBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '404',
              style: TextStyle(
                color: Colors.white,
                fontSize: 80,
                fontWeight: FontWeight.w800,
                height: 0.95,
                letterSpacing: 20,
              ),
            ),
            verticalSpaceSmall,
            Text(
              'PAGE NOT FOUND',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 20,
                wordSpacing: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
