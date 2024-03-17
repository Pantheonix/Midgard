import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/darcula.dart';
import 'package:hive/hive.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/models/submission/submission_models.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/app_strings.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/single_submission_details/single_submission_details_viewmodel.dart';
import 'package:midgard/ui/widgets/app_primitives/app_error_widget.dart';
import 'package:midgard/ui/widgets/app_primitives/sidebar/app_sidebar.dart';
import 'package:pulsator/pulsator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

class SingleSubmissionDetailsView
    extends StackedView<SingleSubmissionDetailsViewModel> {
  const SingleSubmissionDetailsView({
    @PathParam('submissionId') required this.submissionId,
    @QueryParam('problemId') this.problemId,
    @QueryParam('isPublished') this.isPublished,
    super.key,
  });

  final String submissionId;
  final String? problemId;
  final bool? isPublished;

  @override
  Widget builder(
    BuildContext context,
    SingleSubmissionDetailsViewModel viewModel,
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
            child: Padding(
              padding: const EdgeInsets.all(kdSubmissionsViewPadding),
              child: viewModel.hasError
                  ? AppErrorWidget(
                      message: viewModel.modelError.toString(),
                    )
                  : viewModel.fetchingProblem || viewModel.fetchingSubmission
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              viewModel.problem.fold(
                                () => const SizedBox.shrink(),
                                (problem) => _buildProblemDetails(
                                  context,
                                  viewModel,
                                  problem,
                                ),
                              ),
                              verticalSpaceMedium,
                              _refreshButton(viewModel),
                              verticalSpaceMedium,
                              _buildSubmissionDetails(
                                context,
                                viewModel,
                                viewModel.submission,
                              ),
                              verticalSpaceMedium,
                              _buildSubmissionSourceCode(
                                context,
                                viewModel,
                                viewModel.submission,
                              ),
                              verticalSpaceMedium,
                              _buildSubmissionTestCasesDetails(
                                context,
                                viewModel,
                                viewModel.submission,
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

  Widget _buildProblemDetails(
    BuildContext context,
    SingleSubmissionDetailsViewModel viewModel,
    ProblemModel data,
  ) {
    return Column(
      children: [
        ExpansionTile(
          title: const Text(
            ksAppProblemDescriptiveMetadataTitle,
          ),
          subtitle: Text(
            data.name,
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
            _buildProblemDescriptiveMetadata(context, viewModel, data),
            verticalSpaceSmall,
            ExpansionTile(
              title: const Text(
                ksAppProblemBriefTitle,
              ),
              initiallyExpanded: true,
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
                _buildProblemBrief(context, viewModel, data),
              ],
            ),
            verticalSpaceSmall,
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
                _buildProblemTechnicalMetadata(context, viewModel, data),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProblemBrief(
    BuildContext context,
    SingleSubmissionDetailsViewModel viewModel,
    ProblemModel problem,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kdSingleProblemViewPadding,
        ),
        child: Text(
          '" ${problem.brief} "',
          style: const TextStyle(
            fontSize: kdSingleProblemViewTitleFontSize,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildProblemDescriptiveMetadata(
    BuildContext context,
    SingleSubmissionDetailsViewModel viewModel,
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
    SingleSubmissionDetailsViewModel viewModel,
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

  Widget _refreshButton(SingleSubmissionDetailsViewModel viewModel) {
    return Tooltip(
      message: 'Refresh submission details',
      triggerMode: TooltipTriggerMode.tap,
      child: IconButton(
        color: kcBlueAccent,
        icon: const PulseIcon(
          icon: Icons.refresh,
          pulseColor: kcBlueAccent,
        ),
        onPressed: () async {
          await viewModel.refresh();
        },
      ),
    );
  }

  Widget _buildSubmissionSourceCode(
    BuildContext context,
    SingleSubmissionDetailsViewModel viewModel,
    SubmissionModel data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Source code',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: kdSubmissionProposalWidgetTitleFontSize,
          ),
        ),
        verticalSpaceSmall,
        Card(
          child: CodeTheme(
            data: CodeThemeData(
              styles: darculaTheme,
            ),
            child: SingleChildScrollView(
              child: CodeField(
                controller: viewModel.sourceCodeController,
                readOnly: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmissionDetails(
    BuildContext context,
    SingleSubmissionDetailsViewModel viewModel,
    SubmissionModel data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Submission Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: kdSubmissionProposalWidgetTitleFontSize,
          ),
        ),
        verticalSpaceSmall,
        LayoutBuilder(
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
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(
                    label: Text(
                      'ID',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'User',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Problem',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Language',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Score',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Execution Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Memory',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Created at',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                      ),
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    color: MaterialStateProperty.all(data.statusColor),
                    cells: [
                      DataCell(
                        Tooltip(
                          message: data.id,
                          child: Text(
                            '${data.id.substring(0, 4)}...',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        ValueListenableBuilder(
                          valueListenable: HiveService.userProfileBoxListenable,
                          builder:
                              (context, Box<UserProfileModel> box, widget) {
                            final user = viewModel.hiveService.getUserProfile(
                              data.userId,
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
                        InkWell(
                          onTap: () async {
                            await viewModel.navigateToProblemPage(
                              problemId: data.problemId,
                              isPublished: data.isPublished,
                            );
                          },
                          child: Text(
                            data.problemName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          data.languagePretty,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          data.statusPretty,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        data.isEvaluating
                            ? const Center(child: CircularProgressIndicator())
                            : Text(
                                data.scorePretty,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      DataCell(
                        data.isEvaluating
                            ? const Center(child: CircularProgressIndicator())
                            : Text(
                                data.executionTimePretty,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      DataCell(
                        data.isEvaluating
                            ? const Center(child: CircularProgressIndicator())
                            : Text(
                                data.memoryUsagePretty,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      DataCell(
                        Text(
                          data.createdAtPretty,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye),
                          onPressed: () async {
                            await viewModel.navigateToSubmissionPage(
                              submissionId: data.id,
                              problemId: data.problemId,
                              isPublished: data.isPublished,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmissionTestCasesDetails(
    BuildContext context,
    SingleSubmissionDetailsViewModel viewModel,
    SubmissionModel data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Test Cases',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: kdSubmissionProposalWidgetTitleFontSize,
          ),
        ),
        verticalSpaceSmall,
        LayoutBuilder(
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
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(
                    label: Text(
                      'Test Case',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Execution Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Memory',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Evaluation details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                      ),
                    ),
                  ),
                ],
                rows: data.testCases.getOrElse(() => []).map((testCase) {
                  return DataRow(
                    color: MaterialStateProperty.all(testCase.statusColor),
                    cells: [
                      DataCell(
                        Text(
                          testCase.idPretty,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          testCase.statusPretty,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        testCase.isEvaluating
                            ? const Center(child: CircularProgressIndicator())
                            : Text(
                                testCase.executionTimePretty,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      DataCell(
                        testCase.isEvaluating
                            ? const Center(child: CircularProgressIndicator())
                            : Text(
                                testCase.memoryUsagePretty,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      DataCell(
                        IconButton(
                          color: kcPrimaryColor,
                          icon: const Icon(
                            Icons.info,
                            size: kdSubmissionProposalWidgetInfoIconSize,
                          ),
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              body: _buildTestCaseEvaluationDetails(testCase),
                              btnOkOnPress: () {},
                            ).show();
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestCaseEvaluationDetails(TestCaseModel testCase) {
    return Column(
      children: [
        const Text(
          'Evaluation details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: kdSubmissionProposalWidgetTitleFontSize,
          ),
        ),
        verticalSpaceLarge,
        ListTile(
          leading: const Text(
            'Evaluation message:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: kdSubmissionProposalWidgetSubtitleFontSize,
            ),
          ),
          title: TextFormField(
            initialValue: testCase.evaluationMessage.getOrElse(() => ''),
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kcLightGrey),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    kdSubmissionProposalWidgetFieldBorderRadius,
                  ),
                ),
              ),
            ),
            readOnly: true,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: kcRed,
            ),
            maxLines: null,
          ),
        ),
        verticalSpaceMedium,
        ListTile(
          leading: const Text(
            'Compilation output:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: kdSubmissionProposalWidgetSubtitleFontSize,
            ),
          ),
          title: TextFormField(
            initialValue: testCase.compilationOutput.getOrElse(() => ''),
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kcLightGrey),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    kdSubmissionProposalWidgetFieldBorderRadius,
                  ),
                ),
              ),
            ),
            readOnly: true,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: kcRed,
            ),
            maxLines: null,
          ),
        ),
        verticalSpaceMedium,
        ListTile(
          leading: const Text(
            'Standard output:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: kdSubmissionProposalWidgetSubtitleFontSize,
            ),
          ),
          title: TextFormField(
            initialValue: testCase.stdout.getOrElse(() => ''),
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kcLightGrey),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    kdSubmissionProposalWidgetFieldBorderRadius,
                  ),
                ),
              ),
            ),
            readOnly: true,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: kcBlack,
            ),
            maxLines: null,
          ),
        ),
        verticalSpaceMedium,
        ListTile(
          leading: const Text(
            'Standard error:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: kdSubmissionProposalWidgetSubtitleFontSize,
            ),
          ),
          title: TextFormField(
            initialValue: testCase.stderr.getOrElse(() => ''),
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kcLightGrey),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    kdSubmissionProposalWidgetFieldBorderRadius,
                  ),
                ),
              ),
            ),
            readOnly: true,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: kcRed,
            ),
            maxLines: null,
          ),
        ),
      ],
    );
  }

  @override
  SingleSubmissionDetailsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SingleSubmissionDetailsViewModel(
        submissionId: submissionId,
        problemId: problemId!,
        isPublished: isPublished!,
      );
}
