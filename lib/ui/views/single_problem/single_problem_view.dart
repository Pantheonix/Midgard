import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:markdown_editor_plus/widgets/markdown_parse.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/app_strings.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/single_problem/single_problem_viewmodel.dart';
import 'package:midgard/ui/widgets/app_primitives/app_error_widget.dart';
import 'package:midgard/ui/widgets/app_primitives/sidebar/app_sidebar.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

class SingleProblemView extends StackedView<SingleProblemViewModel> {
  const SingleProblemView({
    @PathParam('problemId') required this.problemId,
    super.key,
  });

  final String problemId;

  @override
  Widget builder(
    BuildContext context,
    SingleProblemViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      drawer: AppSidebar(
        controller: viewModel.sidebarController,
      ),
      floatingActionButton: MultiValueListenableBuilder(
        valueListenables: [
          HiveService.userProfileBoxListenable,
          HiveService.problemBoxListenable,
        ],
        builder: (context, values, child) {
          if (viewModel.isBusy) return const SizedBox.shrink();

          final userBox = values.elementAt(0) as Box<UserProfileModel>;
          final problemBox = values.elementAt(1) as Box<ProblemModel>;

          final currentUser = viewModel.hiveService.getCurrentUserProfile(
            userBox,
          );
          // final problem = viewModel.hiveService.getProblem(
          //   problemId,
          //   problemBox,
          // );
          final problem = viewModel.data!;

          final isVisible = currentUser.fold(
            () => false,
            (UserProfileModel user) => user.userId == problem.proposerId,
          );

          return Visibility(
            visible: isVisible,
            child: FloatingActionButton(
              onPressed: () async {
                await viewModel.unpublishProblem(problemId: problemId);

                if (!context.mounted) return;

                if (viewModel.hasErrorForKey(kbSingleProblemKey)) {
                  await context.showErrorBar(
                    position: FlashPosition.top,
                    indicatorColor: kcRed,
                    content: Text(
                      viewModel.error(kbSingleProblemKey).message as String,
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
              backgroundColor: kcBlueAccent,
              tooltip: ksAppUnpublishTooltip,
              child: const Icon(Icons.redo),
            ),
          );
        },
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
              padding: const EdgeInsets.all(
                kdSingleProblemViewPadding,
              ),
              child: viewModel.hasError
                  ? AppErrorWidget(
                      message: viewModel.modelError.toString(),
                    )
                  : viewModel.isBusy
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : _buildProblemWidget(
                          context,
                          viewModel,
                          viewModel.data!,
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemWidget(
    BuildContext context,
    SingleProblemViewModel viewModel,
    ProblemModel problem,
  ) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpaceTiny,
          ExpansionTile(
            title: const Text(
              ksAppProblemDescriptiveMetadataTitle,
            ),
            subtitle: Text(
              problem.name,
              style: const TextStyle(
                fontSize: kdSingleProblemViewTitleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            initiallyExpanded: true,
            backgroundColor: kcVeryLightGrey,
            collapsedBackgroundColor: kcVeryLightGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                kdSingleProblemViewDataTableBorderRadius,
              ),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                kdSingleProblemViewDataTableBorderRadius,
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            children: [
              _buildProblemDescriptiveMetadata(context, viewModel, problem),
              verticalSpaceMedium,
              ExpansionTile(
                title: const Text(
                  ksAppProblemTechnicalMetadataTitle,
                ),
                backgroundColor: kcVeryLightGrey,
                collapsedBackgroundColor: kcVeryLightGrey,
                controlAffinity: ListTileControlAffinity.leading,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    kdSingleProblemViewDataTableBorderRadius,
                  ),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    kdSingleProblemViewDataTableBorderRadius,
                  ),
                ),
                children: [
                  _buildProblemTechnicalMetadata(context, viewModel, problem),
                ],
              ),
            ],
          ),
          verticalSpaceMedium,
          _buildProblemDescription(context, viewModel, problem),
          verticalSpaceMedium,
        ],
      ),
    );
  }

  Widget _buildProblemDescriptiveMetadata(
    BuildContext context,
    SingleProblemViewModel viewModel,
    ProblemModel problem,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth,
          ),
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(kcVeryLightGrey),
            decoration: BoxDecoration(
              border: Border.all(
                width: kdSingleProblemViewDataTableBorderWidth,
                color: kcVeryLightGrey,
              ),
              borderRadius: BorderRadius.circular(
                kdSingleProblemViewDataTableBorderRadius,
              ),
            ),
            border: TableBorder.all(
              color: kcVeryLightGrey,
            ),
            showCheckboxColumn: false,
            columns: const [
              DataColumn(
                label: Text(
                  'Proposer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Author',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Source',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Creation date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                  ),
                ),
              ),
            ],
            rows: [
              DataRow(
                cells: [
                  DataCell(
                    ValueListenableBuilder(
                      valueListenable: HiveService.userProfileBoxListenable,
                      builder: (context, Box<UserProfileModel> box, widget) {
                        final user = viewModel.hiveService.getUserProfile(
                          problem.proposerId,
                          box,
                        );

                        return InkWell(
                          onTap: () {
                            viewModel.routerService
                                .replaceWithSingleProfileView(
                              userId: user.isSome()
                                  ? user.fold(
                                      () => '',
                                      (data) => data.userId,
                                    )
                                  : '',
                            );
                          },
                          child: Column(
                            children: [
                              const Flexible(
                                child: verticalSpaceTiny,
                              ),
                              Flexible(
                                flex: 4,
                                child: CachedNetworkImage(
                                  imageUrl: user.isSome()
                                      ? user.fold(
                                          () => '',
                                          (data) => data.profilePictureUrl,
                                        )
                                      : '',
                                  placeholder: (context, url) =>
                                      const FlutterLogo(
                                    size:
                                        kdSingleProblemViewProposerAvatarShapeRadius,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const FlutterLogo(
                                    size:
                                        kdSingleProblemViewProposerAvatarShapeRadius,
                                  ),
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    radius:
                                        kdSingleProblemViewProposerAvatarShapeRadius,
                                    backgroundImage: imageProvider,
                                  ),
                                ),
                              ),
                              const Flexible(
                                child: verticalSpaceTiny,
                              ),
                              Flexible(
                                flex: 2,
                                child: Text(
                                  user.isSome()
                                      ? user.fold(
                                          () => '',
                                          (data) => data.username,
                                        )
                                      : '',
                                  style: const TextStyle(
                                    fontSize:
                                        kdSingleProblemViewProposerUsernameFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  DataCell(
                    Text(
                      problem.name,
                    ),
                  ),
                  DataCell(
                    Text(
                      problem.authorName,
                    ),
                  ),
                  DataCell(
                    Text(
                      problem.sourceName,
                    ),
                  ),
                  DataCell(
                    Text(
                      problem.createdAtPrettyWithoutLabel,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProblemTechnicalMetadata(
    BuildContext context,
    SingleProblemViewModel viewModel,
    ProblemModel problem,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth,
          ),
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(kcVeryLightGrey),
            decoration: BoxDecoration(
              border: Border.all(
                width: kdSingleProblemViewDataTableBorderWidth,
                color: kcVeryLightGrey,
              ),
              borderRadius: BorderRadius.circular(
                kdSingleProblemViewDataTableBorderRadius,
              ),
            ),
            border: TableBorder.all(
              color: kcVeryLightGrey,
            ),
            showCheckboxColumn: false,
            columns: const [
              DataColumn(
                label: Text(
                  'Time limit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Total memory limit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Stack memory limit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'I/O type',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Difficulty',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                  ),
                ),
              ),
            ],
            rows: [
              DataRow(
                cells: [
                  DataCell(
                    Text(
                      problem.timeLimitPrettyWithoutLabel,
                    ),
                  ),
                  DataCell(
                    Text(
                      problem.totalMemoryLimitPretty,
                    ),
                  ),
                  DataCell(
                    Text(
                      problem.stackMemoryLimitPretty,
                    ),
                  ),
                  DataCell(
                    Text(
                      problem.ioType.value,
                    ),
                  ),
                  DataCell(
                    Text(
                      problem.difficulty.value,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProblemDescription(
    BuildContext context,
    SingleProblemViewModel viewModel,
    ProblemModel problem,
  ) {
    return Card(
      color: kcVeryLightGrey,
      child: Padding(
        padding: const EdgeInsets.all(
          kdSingleProblemViewDescriptionPadding,
        ),
        child: MarkdownParse(
          data: problem.description,
          selectable: true,
          shrinkWrap: true,
        ),
      ),
    );
  }

  @override
  Future<void> onViewModelReady(
    SingleProblemViewModel viewModel,
  ) async {
    super.onViewModelReady(viewModel);

    final userProfileBox = await HiveService.userProfileBoxAsync;
    if (viewModel.hiveService.getCurrentUserProfile(userProfileBox).isNone()) {
      await viewModel.routerService.replaceWithHomeView(
        warningMessage: ksAppNotAuthenticatedRedirectMessage,
      );
    }
  }

  @override
  SingleProblemViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SingleProblemViewModel(problemId: problemId);

  @override
  void onDispose(SingleProblemViewModel viewModel) {
    super.onDispose(viewModel);

    viewModel.sidebarController.dispose();
  }
}
