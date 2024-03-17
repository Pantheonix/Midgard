import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/submission/submission_models.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/submission_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/app_strings.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/submissions/submissions_view.form.dart';
import 'package:midgard/ui/views/submissions/submissions_viewmodel.dart';
import 'package:midgard/ui/widgets/app_primitives/app_error_widget.dart';
import 'package:midgard/ui/widgets/app_primitives/sidebar/app_sidebar.dart';
import 'package:pulsator/pulsator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

@FormView(
  fields: [
    FormTextField(name: 'ltScore'),
    FormTextField(name: 'gtScore'),
    FormTextField(name: 'ltExecutionTime'),
    FormTextField(name: 'gtExecutionTime'),
    FormTextField(name: 'ltMemoryUsage'),
    FormTextField(name: 'gtMemoryUsage'),
  ],
)
class SubmissionsView extends StackedView<SubmissionsViewModel>
    with $SubmissionsView {
  const SubmissionsView({super.key});

  @override
  Widget builder(
    BuildContext context,
    SubmissionsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      drawer: AppSidebar(
        controller: viewModel.sidebarController,
      ),
      floatingActionButton: _refreshButton(viewModel),
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
                kdSubmissionsViewPadding,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenu(context, viewModel),
                    verticalSpaceMedium,
                    if (viewModel.hasError)
                      AppErrorWidget(
                        message: viewModel.modelError.toString(),
                      )
                    else
                      ...viewModel.isBusy
                          ? [
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ]
                          : [
                              _buildSubmissionsList(
                                context,
                                viewModel,
                                viewModel.data!,
                              ),
                              verticalSpaceMedium,
                              _buildPaginationFooter(
                                context,
                                viewModel,
                                viewModel.data!,
                              ),
                            ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(
    BuildContext context,
    SubmissionsViewModel viewModel,
  ) {
    return ExpansionTile(
      subtitle: const Text(
        'Filter submissions',
      ),
      title: const Text(
        'Submissions',
        style: TextStyle(
          fontSize: kdSingleProblemViewTitleFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      initiallyExpanded: true,
      childrenPadding: const EdgeInsets.symmetric(
        horizontal: kdSubmissionsViewPadding,
      ),
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
        verticalSpaceMedium,
        Row(
          children: [
            _buildSortByDropdown(viewModel),
            horizontalSpaceMedium,
            _buildLanguageDropdown(viewModel),
            horizontalSpaceMedium,
            _buildStatusDropdown(viewModel),
          ],
        ),
        verticalSpaceMedium,
        Row(
          children: [
            _buildGtScoreTextField(viewModel),
            horizontalSpaceMedium,
            _buildLtScoreTextField(viewModel),
          ],
        ),
        verticalSpaceMedium,
        Row(
          children: [
            _buildGtExecutionTimeTextField(viewModel),
            horizontalSpaceMedium,
            _buildLtExecutionTimeTextField(viewModel),
          ],
        ),
        verticalSpaceMedium,
        Row(
          children: [
            _buildGtMemoryUsageTextField(viewModel),
            horizontalSpaceMedium,
            _buildLtMemoryUsageTextField(viewModel),
          ],
        ),
        verticalSpaceMedium,
        Row(
          children: [
            _buildStartDateTextField(viewModel),
            horizontalSpaceMedium,
            _buildEndDateTextField(viewModel),
          ],
        ),
      ],
    );
  }

  Widget _buildSortByDropdown(SubmissionsViewModel viewModel) {
    return Expanded(
      child: DropdownButtonFormField<SortSubmissionsBy>(
        onChanged: (value) {
          if (value != null) {
            viewModel.sortByValue = some(value);
          }
        },
        items: SortSubmissionsBy.values
            .map(
              (sortBy) => DropdownMenuItem(
                value: sortBy,
                child: Text(sortBy.pretty),
              ),
            )
            .toList(),
        decoration: const InputDecoration(
          labelText: 'Sort by',
          contentPadding: EdgeInsets.all(
            kdCreateProposalDashboardViewFieldPadding,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
            borderRadius: BorderRadius.all(
              Radius.circular(
                kdCreateProposalDashboardViewFieldBorderRadius,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(SubmissionsViewModel viewModel) {
    return Expanded(
      child: DropdownButtonFormField<Language>(
        onChanged: (value) {
          if (value != null) {
            viewModel.languageValue = some(value);
          }
        },
        items: Language.values
            .where((language) => language != Language.unknown)
            .map(
              (language) => DropdownMenuItem(
                value: language,
                child: Text(language.displayName),
              ),
            )
            .toList(),
        decoration: const InputDecoration(
          labelText: 'Language',
          contentPadding: EdgeInsets.all(
            kdCreateProposalDashboardViewFieldPadding,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
            borderRadius: BorderRadius.all(
              Radius.circular(
                kdCreateProposalDashboardViewFieldBorderRadius,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown(SubmissionsViewModel viewModel) {
    return Expanded(
      child: DropdownButtonFormField<SubmissionStatus>(
        onChanged: (value) {
          if (value != null) {
            viewModel.statusValue = some(value);
          }
        },
        items: SubmissionStatus.values
            .where((status) => status != SubmissionStatus.unknown)
            .map(
              (status) => DropdownMenuItem(
                value: status,
                child: Text(status.displayName),
              ),
            )
            .toList(),
        decoration: const InputDecoration(
          labelText: 'Status',
          contentPadding: EdgeInsets.all(
            kdCreateProposalDashboardViewFieldPadding,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
            borderRadius: BorderRadius.all(
              Radius.circular(
                kdCreateProposalDashboardViewFieldBorderRadius,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLtScoreTextField(SubmissionsViewModel viewModel) {
    return Expanded(
      child: TextFormField(
        controller: ltScoreController,
        focusNode: ltScoreFocusNode,
        decoration: const InputDecoration(
          labelText: 'Ending score',
          contentPadding: EdgeInsets.all(
            kdCreateProposalDashboardViewFieldPadding,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
            borderRadius: BorderRadius.all(
              Radius.circular(
                kdCreateProposalDashboardViewFieldBorderRadius,
              ),
            ),
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(kLimitDecimalRegex)),
        ],
      ),
    );
  }

  Widget _buildGtScoreTextField(SubmissionsViewModel viewModel) {
    return Expanded(
      child: TextFormField(
        controller: gtScoreController,
        focusNode: gtScoreFocusNode,
        decoration: const InputDecoration(
          labelText: 'Starting score',
          contentPadding: EdgeInsets.all(
            kdCreateProposalDashboardViewFieldPadding,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
            borderRadius: BorderRadius.all(
              Radius.circular(
                kdCreateProposalDashboardViewFieldBorderRadius,
              ),
            ),
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(kLimitDecimalRegex)),
        ],
      ),
    );
  }

  Widget _buildLtExecutionTimeTextField(SubmissionsViewModel viewModel) {
    return Expanded(
      child: TextFormField(
        controller: ltExecutionTimeController,
        focusNode: ltExecutionTimeFocusNode,
        decoration: const InputDecoration(
          labelText: 'Ending execution time',
          contentPadding: EdgeInsets.all(
            kdCreateProposalDashboardViewFieldPadding,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
            borderRadius: BorderRadius.all(
              Radius.circular(
                kdCreateProposalDashboardViewFieldBorderRadius,
              ),
            ),
          ),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(kLimitDecimalRegex)),
        ],
      ),
    );
  }

  Widget _buildGtExecutionTimeTextField(SubmissionsViewModel viewModel) {
    return Expanded(
      child: TextFormField(
        controller: gtExecutionTimeController,
        focusNode: gtExecutionTimeFocusNode,
        decoration: const InputDecoration(
          labelText: 'Starting execution time',
          contentPadding: EdgeInsets.all(
            kdCreateProposalDashboardViewFieldPadding,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
            borderRadius: BorderRadius.all(
              Radius.circular(
                kdCreateProposalDashboardViewFieldBorderRadius,
              ),
            ),
          ),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(kLimitDecimalRegex)),
        ],
      ),
    );
  }

  Widget _buildLtMemoryUsageTextField(SubmissionsViewModel viewModel) {
    return Expanded(
      child: TextFormField(
        controller: ltMemoryUsageController,
        focusNode: ltMemoryUsageFocusNode,
        decoration: const InputDecoration(
          labelText: 'Ending memory usage',
          contentPadding: EdgeInsets.all(
            kdCreateProposalDashboardViewFieldPadding,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
            borderRadius: BorderRadius.all(
              Radius.circular(
                kdCreateProposalDashboardViewFieldBorderRadius,
              ),
            ),
          ),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(kLimitDecimalRegex)),
        ],
      ),
    );
  }

  Widget _buildGtMemoryUsageTextField(SubmissionsViewModel viewModel) {
    return Expanded(
      child: TextFormField(
        controller: gtMemoryUsageController,
        focusNode: gtMemoryUsageFocusNode,
        decoration: const InputDecoration(
          labelText: 'Starting memory usage',
          contentPadding: EdgeInsets.all(
            kdCreateProposalDashboardViewFieldPadding,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kcLightGrey),
            borderRadius: BorderRadius.all(
              Radius.circular(
                kdCreateProposalDashboardViewFieldBorderRadius,
              ),
            ),
          ),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(kLimitDecimalRegex)),
        ],
      ),
    );
  }

  Widget _buildStartDateTextField(SubmissionsViewModel viewModel) {
    return Expanded(
      child: Column(
        children: [
          const Text(
            'Start date',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: kdSubmissionProposalWidgetTitleFontSize,
            ),
          ),
          DatePicker(
            minDate: kMinDate,
            maxDate: kMaxDate,
            selectedDate: viewModel.startDate.getOrElse(DateTime.now),
            onDateSelected: (value) {
              viewModel.startDate = some(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEndDateTextField(SubmissionsViewModel viewModel) {
    return Expanded(
      child: Column(
        children: [
          const Text(
            'End date',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: kdSubmissionProposalWidgetTitleFontSize,
            ),
          ),
          DatePicker(
            minDate: kMinDate,
            maxDate: kMaxDate,
            selectedDate: viewModel.endDate.getOrElse(DateTime.now),
            onDateSelected: (value) {
              viewModel.endDate = some(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _refreshButton(SubmissionsViewModel viewModel) {
    return Tooltip(
      message: 'Refresh submissions list',
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

  Widget _buildSubmissionsList(
    BuildContext context,
    SubmissionsViewModel viewModel,
    PaginatedSubmissions data,
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
            rows: data.submissions
                .map(
                  (submission) => DataRow(
                    color: MaterialStateProperty.all(submission.statusColor),
                    cells: [
                      DataCell(
                        Tooltip(
                          message: submission.id,
                          child: Text(
                            '${submission.id.substring(0, 4)}...',
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
                              submission.userId,
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
                              problemId: submission.problemId,
                              isPublished: submission.isPublished,
                            );
                          },
                          child: Text(
                            submission.problemName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          submission.languagePretty,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          submission.statusPretty,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        submission.isEvaluating
                            ? const Center(child: CircularProgressIndicator())
                            : Text(
                                submission.scorePretty,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      DataCell(
                        submission.isEvaluating
                            ? const Center(child: CircularProgressIndicator())
                            : Text(
                                submission.executionTimePretty,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      DataCell(
                        submission.isEvaluating
                            ? const Center(child: CircularProgressIndicator())
                            : Text(
                                submission.memoryUsagePretty,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      DataCell(
                        Text(
                          submission.createdAtPretty,
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
                              submissionId: submission.id,
                              problemId: submission.problemId,
                              isPublished: submission.isPublished,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationFooter(
    BuildContext context,
    SubmissionsViewModel viewModel,
    PaginatedSubmissions data,
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
              ..refresh();
          },
        ),
        horizontalSpaceMedium,
        Text(
          '${viewModel.pageValue} / ${data.totalPages}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        horizontalSpaceMedium,
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            if (viewModel.pageValue == data.totalPages) {
              return;
            }

            viewModel
              ..pageValue = viewModel.pageValue + 1
              ..refresh();
          },
        ),
      ],
    );
  }

  @override
  Future<void> onViewModelReady(
    SubmissionsViewModel viewModel,
  ) async {
    super.onViewModelReady(viewModel);

    final userProfileBox = await HiveService.userProfileBoxAsync;
    if (viewModel.hiveService.getCurrentUserProfile(userProfileBox).isNone()) {
      await viewModel.routerService.replaceWithHomeView(
        warningMessage: ksAppNotAuthenticatedRedirectMessage,
      );
    }

    syncFormWithViewModel(viewModel);
  }

  @override
  SubmissionsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SubmissionsViewModel();
}
