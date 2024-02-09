import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/app_strings.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/problem_proposals/problem_proposals_view.form.dart';
import 'package:midgard/ui/views/problem_proposals/problem_proposals_viewmodel.dart';
import 'package:midgard/ui/widgets/app_primitives/sidebar/app_sidebar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

@FormView(
  fields: [
    FormTextField(name: 'name'),
  ],
)
class ProblemProposalsView extends StackedView<ProblemProposalsViewModel>
    with $ProblemProposalsView {
  const ProblemProposalsView({
    super.key,
  });

  @override
  Widget builder(
    BuildContext context,
    ProblemProposalsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      drawer: AppSidebar(
        controller: viewModel.sidebarController,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kcBlueAccent,
        tooltip: ksProblemProposalsViewProposeTooltip,
        child: const Icon(Icons.add),
      ),
      backgroundColor: kcWhite,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSidebar(
            controller: viewModel.sidebarController,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: kdProblemsViewPadding,
                right: kdProblemsViewPadding,
                bottom: kdProblemsViewPadding,
              ),
              child: Column(
                children: [
                  _buildFormHeader(context, viewModel),
                  verticalSpaceMedium,
                  if (viewModel.busy(kbProblemsKey))
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else ...[
                    _buildProblemsListView(context, viewModel),
                    verticalSpaceMedium,
                    _buildPaginationFooter(context, viewModel),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormHeader(
    BuildContext context,
    ProblemProposalsViewModel viewModel,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildFilterProblemNameField(context, viewModel),
        horizontalSpaceMedium,
        _buildFilterDifficultyField(context, viewModel),
        horizontalSpaceSmall,
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            viewModel.init();
          },
        ),
      ],
    );
  }

  Widget _buildFilterProblemNameField(
    BuildContext context,
    ProblemProposalsViewModel viewModel,
  ) {
    return Expanded(
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Problem Name',
          contentPadding: EdgeInsets.all(kdProfilesViewNameFieldPadding),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
          ),
        ),
        focusNode: nameFocusNode,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        controller: nameController,
        onEditingComplete: () {
          viewModel.init();
        },
      ),
    );
  }

  Widget _buildFilterDifficultyField(
    BuildContext context,
    ProblemProposalsViewModel viewModel,
  ) {
    return Expanded(
      child: DropdownButtonFormField<Difficulty>(
        decoration: const InputDecoration(
          hintText: 'Difficulty',
          contentPadding: EdgeInsets.all(kdProfilesViewNameFieldPadding),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
          ),
        ),
        value: viewModel.difficultyValue,
        items: Difficulty.values
            .map(
              (difficulty) => DropdownMenuItem<Difficulty>(
                value: difficulty,
                child: Text(difficulty.value),
              ),
            )
            .toList(),
        onChanged: (difficulty) {
          viewModel
            ..difficultyValue = difficulty!
            ..init();
        },
      ),
    );
  }

  Widget _buildProblemsListView(
    BuildContext context,
    ProblemProposalsViewModel viewModel,
  ) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: HiveService.userProfileBoxListenable,
        builder: (context, Box<UserProfileModel> box, widget) =>
            ScrollConfiguration(
          behavior: ScrollConfiguration.of(context),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemExtent: kdProblemsViewProblemsListTileHeight,
            itemCount: viewModel.problems.length,
            itemBuilder: (context, index) {
              if (viewModel.problems.isEmpty) {
                return const SizedBox.shrink();
              }

              final problem = viewModel.problems[index];
              final user = viewModel.hiveService.getUserProfile(
                problem.proposerId,
                box,
              );

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: kdProblemsViewProblemsListTilePadding,
                ),
                child: InkWell(
                  onTap: () {
                    viewModel.routerService
                        .replaceWithSingleProblemProposalView(
                      problemId: problem.id,
                    );
                  },
                  onLongPress: () {
                    if (viewModel.selectedProblemIdValue == problem.id) {
                      viewModel.selectedProblemIdValue = '';
                    } else {
                      viewModel.selectedProblemIdValue = problem.id;
                    }
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(
                      seconds: 1,
                    ),
                    transitionBuilder: (child, animation) {
                      return SizeTransition(
                        sizeFactor: animation,
                        child: child,
                      );
                    },
                    child: viewModel.selectedProblemIdValue != problem.id
                        ? _buildProblemListTileForeground(
                            context,
                            viewModel,
                            problem,
                            user,
                          )
                        : _buildProblemListTileBackground(
                            context,
                            viewModel,
                            problem,
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProblemListTileForeground(
    BuildContext context,
    ProblemProposalsViewModel viewModel,
    ProblemModel problem,
    Option<UserProfileModel> user,
  ) {
    return Card(
      key: ValueKey(
        '${problem.id}-$ksProblemsViewProblemsListTileForegroundKey',
      ),
      elevation: kdProblemsViewProblemsListTileElevation,
      child: ListTile(
        leading: IconButton(
          icon: const Icon(Icons.send),
          color: kcOrange,
          tooltip: ksProblemProposalsViewPublishTooltip,
          onPressed: () {},
        ),
        title: Text(
          problem.name,
        ),
        titleTextStyle: const TextStyle(
          fontSize: kdProblemsViewProblemsListTitleFontSize,
          fontWeight: FontWeight.bold,
        ),
        subtitle: Text(
          problem.brief,
          maxLines: kiProblemsViewProblemsListSubtitleMaxLines,
        ),
        subtitleTextStyle: const TextStyle(
          fontSize: kdProblemsViewProblemsListSubtitleFontSize,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 2,
              child: Chip(
                label: Text(
                  problem.difficulty.value,
                ),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: problem.difficulty.color,
                side: BorderSide(
                  color: problem.difficulty.color,
                ),
              ),
            ),
            const Flexible(
              child: verticalSpaceTiny,
            ),
            Flexible(
              flex: 2,
              child: Chip(
                label: Text(
                  problem.ioType.value,
                ),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: problem.ioType.color,
                side: BorderSide(
                  color: problem.ioType.color,
                ),
              ),
            ),
          ],
        ),
        visualDensity: const VisualDensity(
          vertical: kdProblemsViewProblemsListTileVisualVerticalDensity,
        ),
      ),
    );
  }

  Widget _buildProblemListTileBackground(
    BuildContext context,
    ProblemProposalsViewModel viewModel,
    ProblemModel problem,
  ) {
    return Card(
      key: ValueKey(
        '${problem.id}-$ksProblemsViewProblemsListTileBackgroundKey',
      ),
      elevation: kdProblemsViewProblemsListTileElevation,
      child: ListTile(
        leading: const Icon(
          Icons.info_outline,
          size: kdProblemsViewProblemsListTileBackgroundLeadingIconSize,
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(problem.authorNamePretty),
            ),
            Flexible(
              child: Text(problem.sourceNamePretty),
            ),
            Flexible(
              child: Text(problem.timeLimitPretty),
            ),
            Flexible(
              child: Text(problem.memoryLimitPretty),
            ),
          ],
        ),
        titleTextStyle: const TextStyle(
          fontSize: kdProblemsViewProblemsListTileBackgroundTitleFontSize,
          fontWeight: FontWeight.bold,
        ),
        trailing: Text(problem.createdAtPretty),
        leadingAndTrailingTextStyle: const TextStyle(
          fontSize:
              kdProblemsViewProblemsListTileBackgroundLeadingAndTrailingFontSize,
          fontStyle: FontStyle.italic,
        ),
        visualDensity: const VisualDensity(
          vertical: kdProblemsViewProblemsListTileVisualVerticalDensity,
        ),
      ),
    );
  }

  Widget _buildPaginationFooter(
    BuildContext context,
    ProblemProposalsViewModel viewModel,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (viewModel.pageValue == 1) {
              return;
            }

            viewModel
              ..pageValue = viewModel.pageValue - 1
              ..init();
          },
        ),
        horizontalSpaceMedium,
        Text(
          '${viewModel.pageValue} / ${(viewModel.count / kiProblemsViewPageSize).ceil()}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        horizontalSpaceMedium,
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            if (viewModel.pageValue ==
                (viewModel.count / kiProblemsViewPageSize).ceil()) {
              return;
            }

            viewModel
              ..pageValue = viewModel.pageValue + 1
              ..init();
          },
        ),
      ],
    );
  }

  @override
  Future<void> onViewModelReady(ProblemProposalsViewModel viewModel) async {
    super.onViewModelReady(viewModel);

    final userProfileBox = await HiveService.userProfileBoxAsync;
    await viewModel.hiveService.getCurrentUserProfile(userProfileBox).fold(
      () async {
        await viewModel.routerService.replaceWithHomeView(
          warningMessage: ksAppNotAuthenticatedRedirectMessage,
        );
      },
      (UserProfileModel user) async {
        if (!user.isProposer) {
          await viewModel.routerService.replaceWithHomeView(
            warningMessage: ksAppNotProposerRedirectMessage,
          );
        }

        syncFormWithViewModel(viewModel);
        await viewModel.init();
      },
    );
  }

  @override
  ProblemProposalsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProblemProposalsViewModel();

  @override
  void onDispose(ProblemProposalsViewModel viewModel) {
    super.onDispose(viewModel);

    disposeForm();
    viewModel.sidebarController.dispose();
  }
}
