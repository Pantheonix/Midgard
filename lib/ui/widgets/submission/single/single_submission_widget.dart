import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/submission/submission_models.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/widgets/app_primitives/app_error_widget.dart';
import 'package:midgard/ui/widgets/submission/single/single_submission_viewmodel.dart';
import 'package:pulsator/pulsator.dart';
import 'package:stacked/stacked.dart';

class SingleSubmissionWidget extends StatelessWidget {
  const SingleSubmissionWidget({
    required this.submissionId,
    super.key,
  });

  final String submissionId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleSubmissionViewModel>.reactive(
      builder: (context, viewModel, child) => viewModel.hasError
          ? AppErrorWidget(
              message: viewModel.modelError.toString(),
            )
          : viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _refreshButton(viewModel),
                    verticalSpaceMedium,
                    _buildSubmissionDetails(
                      context,
                      viewModel,
                      viewModel.data!,
                    ),
                    verticalSpaceMedium,
                    _buildSubmissionTestCasesDetails(
                      context,
                      viewModel,
                      viewModel.data!,
                    ),
                  ],
                ),
      viewModelBuilder: () => SingleSubmissionViewModel(
        submissionId: submissionId,
      ),
    );
  }

  Widget _refreshButton(SingleSubmissionViewModel viewModel) {
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

  Widget _buildSubmissionDetails(
    BuildContext context,
    SingleSubmissionViewModel viewModel,
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
    SingleSubmissionViewModel viewModel,
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
}
