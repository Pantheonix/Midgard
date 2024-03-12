import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/submission_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/widgets/app_primitives/app_error_widget.dart';
import 'package:midgard/ui/widgets/submission/list/submissions_list_viewmodel.dart';
import 'package:pulsator/pulsator.dart';
import 'package:stacked/stacked.dart';

class SubmissionsListWidget extends StatelessWidget {
  const SubmissionsListWidget({
    this.userId,
    this.problemId,
    super.key,
  });

  final String? userId;
  final String? problemId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubmissionsListViewModel>.reactive(
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
                    verticalSpaceSmall,
                    _buildSubmissionsList(context, viewModel, viewModel.data!),
                    verticalSpaceSmall,
                    _buildPaginationFooter(context, viewModel, viewModel.data!),
                  ],
                ),
      viewModelBuilder: () => SubmissionsListViewModel(
        userId: userId,
        problemId: problemId,
      ),
    );
  }

  Widget _refreshButton(SubmissionsListViewModel viewModel) {
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
    SubmissionsListViewModel viewModel,
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
                  'Created At',
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
    SubmissionsListViewModel viewModel,
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
}
