import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_editor_plus/widgets/splitted_markdown_form_field.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/models/validators/problem_validators.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/app_strings.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/update_proposal_dashboard/update_proposal_dashboard_view.form.dart';
import 'package:midgard/ui/views/update_proposal_dashboard/update_proposal_dashboard_viewmodel.dart';
import 'package:midgard/ui/widgets/app_primitives/app_error_widget.dart';
import 'package:midgard/ui/widgets/app_primitives/sidebar/app_sidebar.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

@FormView(
  fields: [
    FormTextField(
      name: 'name',
      validator: ProblemValidators.validateName,
    ),
    FormTextField(
      name: 'brief',
      validator: ProblemValidators.validateBrief,
    ),
    FormTextField(
      name: 'description',
      validator: ProblemValidators.validateDescription,
    ),
    FormTextField(
      name: 'sourceName',
      validator: ProblemValidators.validateSourceName,
    ),
    FormTextField(
      name: 'authorName',
      validator: ProblemValidators.validateAuthorName,
    ),
    FormTextField(
      name: 'timeLimit',
      validator: ProblemValidators.validateTimeLimit,
    ),
    FormTextField(
      name: 'totalMemoryLimit',
      validator: ProblemValidators.validateTotalMemoryLimit,
    ),
    FormTextField(
      name: 'stackMemoryLimit',
      validator: ProblemValidators.validateStackMemoryLimit,
    ),
  ],
)
class UpdateProposalDashboardView
    extends StackedView<UpdateProposalDashboardViewModel>
    with $UpdateProposalDashboardView {
  const UpdateProposalDashboardView({
    @PathParam('problemId') required this.problemId,
    super.key,
  });

  final String problemId;

  @override
  Widget builder(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      drawer: AppSidebar(
        controller: viewModel.sidebarController,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await viewModel.updateProblem();

          if (!context.mounted) return;

          if (viewModel.hasErrorForKey(kbUpdateProposalDashboardKey)) {
            await context.showErrorBar(
              position: FlashPosition.top,
              indicatorColor: kcRed,
              content: Text(
                viewModel.error(kbUpdateProposalDashboardKey).message as String,
              ),
              primaryActionBuilder: (context, controller) {
                return IconButton(
                  onPressed: controller.dismiss,
                  icon: const Icon(Icons.close),
                );
              },
            );
          } else {
            await context.showSuccessBar(
              position: FlashPosition.top,
              indicatorColor: kcGreen,
              content: const Text('Problem updated successfully!'),
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
        splashColor: kcGreenAccent,
        tooltip: ksAppUpdateTooltip,
        child: const Icon(Icons.save),
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
                kdUpdateProposalDashboardViewPadding,
              ),
              child: viewModel.busy(kbUpdateProposalDashboardKey)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _buildProblemForm(
                      context,
                      viewModel,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemForm(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
  ) {
    return viewModel.problem.fold(
      () => AppErrorWidget(
        message: 'No problem found with id: $problemId',
      ),
      (problem) => ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 4,
                    child: _buildNameField(
                      context,
                      viewModel,
                    ),
                  ),
                  const Flexible(child: horizontalSpaceSmall),
                  Flexible(
                    flex: 4,
                    child: _buildSourceNameField(
                      context,
                      viewModel,
                    ),
                  ),
                  const Flexible(child: horizontalSpaceSmall),
                  Flexible(
                    flex: 4,
                    child: _buildAuthorNameField(
                      context,
                      viewModel,
                    ),
                  ),
                  const Flexible(child: horizontalSpaceSmall),
                  Flexible(
                    flex: 4,
                    child: _buildDifficultyField(
                      context,
                      viewModel,
                    ),
                  ),
                ],
              ),
              verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 4,
                    child: _buildTimeLimitField(
                      context,
                      viewModel,
                    ),
                  ),
                  const Flexible(child: horizontalSpaceSmall),
                  Flexible(
                    flex: 4,
                    child: _buildTotalMemoryLimitField(
                      context,
                      viewModel,
                    ),
                  ),
                  const Flexible(child: horizontalSpaceSmall),
                  Flexible(
                    flex: 4,
                    child: _buildStackMemoryLimitField(
                      context,
                      viewModel,
                    ),
                  ),
                  const Flexible(child: horizontalSpaceSmall),
                  Flexible(
                    flex: 4,
                    child: _buildIoTypeField(
                      context,
                      viewModel,
                    ),
                  ),
                ],
              ),
              verticalSpaceMedium,
              _buildBriefField(
                context,
                viewModel,
              ),
              verticalSpaceMedium,
              _buildDescriptionField(
                context,
                viewModel,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Problem name',
            contentPadding: EdgeInsets.all(
              kdUpdateProposalDashboardViewFieldPadding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  kdUpdateProposalDashboardViewFieldBorderRadius,
                ),
              ),
            ),
          ),
          focusNode: nameFocusNode,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          controller: nameController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: kMaxProblemNameLength,
        ),
        if (viewModel.hasNameValidationMessage) ...[
          verticalSpaceTiny,
          Text(
            viewModel.nameValidationMessage!,
            style: const TextStyle(
              color: kcRed,
              fontSize: kdUpdateProposalDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBriefField(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Brief',
            contentPadding: EdgeInsets.all(
              kdUpdateProposalDashboardViewFieldPadding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  kdUpdateProposalDashboardViewFieldBorderRadius,
                ),
              ),
            ),
          ),
          focusNode: briefFocusNode,
          keyboardType: TextInputType.multiline,
          controller: briefController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: kMaxProblemBriefLength,
          maxLines: null,
        ),
        if (viewModel.hasBriefValidationMessage) ...[
          verticalSpaceTiny,
          Text(
            viewModel.briefValidationMessage!,
            style: const TextStyle(
              color: kcRed,
              fontSize: kdUpdateProposalDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSourceNameField(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Source name',
            contentPadding: EdgeInsets.all(
              kdUpdateProposalDashboardViewFieldPadding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  kdUpdateProposalDashboardViewFieldBorderRadius,
                ),
              ),
            ),
          ),
          focusNode: sourceNameFocusNode,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          controller: sourceNameController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: kMaxProblemSourceNameLength,
        ),
        if (viewModel.hasSourceNameValidationMessage) ...[
          verticalSpaceTiny,
          Text(
            viewModel.sourceNameValidationMessage!,
            style: const TextStyle(
              color: kcRed,
              fontSize: kdUpdateProposalDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAuthorNameField(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Author name',
            contentPadding: EdgeInsets.all(
              kdUpdateProposalDashboardViewFieldPadding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  kdUpdateProposalDashboardViewFieldBorderRadius,
                ),
              ),
            ),
          ),
          focusNode: authorNameFocusNode,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          controller: authorNameController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: kMaxProblemAuthorNameLength,
        ),
        if (viewModel.hasAuthorNameValidationMessage) ...[
          verticalSpaceTiny,
          Text(
            viewModel.authorNameValidationMessage!,
            style: const TextStyle(
              color: kcRed,
              fontSize: kdUpdateProposalDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimeLimitField(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Time limit (sec)',
            contentPadding: EdgeInsets.all(
              kdUpdateProposalDashboardViewFieldPadding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  kdUpdateProposalDashboardViewFieldBorderRadius,
                ),
              ),
            ),
          ),
          focusNode: timeLimitFocusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          controller: timeLimitController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(kLimitDecimalRegex)),
          ],
        ),
        if (viewModel.hasTimeLimitValidationMessage) ...[
          verticalSpaceTiny,
          Text(
            viewModel.timeLimitValidationMessage!,
            style: const TextStyle(
              color: kcRed,
              fontSize: kdUpdateProposalDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTotalMemoryLimitField(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Total memory limit (MB)',
            contentPadding: EdgeInsets.all(
              kdUpdateProposalDashboardViewFieldPadding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  kdUpdateProposalDashboardViewFieldBorderRadius,
                ),
              ),
            ),
          ),
          focusNode: totalMemoryLimitFocusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          controller: totalMemoryLimitController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(kLimitDecimalRegex)),
          ],
        ),
        if (viewModel.hasTotalMemoryLimitValidationMessage) ...[
          verticalSpaceTiny,
          Text(
            viewModel.totalMemoryLimitValidationMessage!,
            style: const TextStyle(
              color: kcRed,
              fontSize: kdUpdateProposalDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStackMemoryLimitField(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Stack memory limit (MB)',
            contentPadding: EdgeInsets.all(
              kdUpdateProposalDashboardViewFieldPadding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  kdUpdateProposalDashboardViewFieldBorderRadius,
                ),
              ),
            ),
          ),
          focusNode: stackMemoryLimitFocusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          controller: stackMemoryLimitController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(kLimitDecimalRegex)),
          ],
        ),
        if (viewModel.hasStackMemoryLimitValidationMessage) ...[
          verticalSpaceTiny,
          Text(
            viewModel.stackMemoryLimitValidationMessage!,
            style: const TextStyle(
              color: kcRed,
              fontSize: kdUpdateProposalDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDifficultyField(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
  ) {
    return DropdownButtonFormField<Difficulty>(
      decoration: const InputDecoration(
        hintText: 'Difficulty',
        contentPadding: EdgeInsets.all(
          kdUpdateProposalDashboardViewFieldPadding,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusedBorder: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kcLightGrey),
          borderRadius: BorderRadius.all(
            Radius.circular(
              kdUpdateProposalDashboardViewFieldBorderRadius,
            ),
          ),
        ),
      ),
      value: viewModel.difficultyValue,
      items: Difficulty.values
          .where(
            (difficulty) => difficulty != Difficulty.all,
          )
          .map(
            (difficulty) => DropdownMenuItem<Difficulty>(
              value: difficulty,
              child: Text(difficulty.value),
            ),
          )
          .toList(),
      onChanged: (difficulty) {
        viewModel.difficultyValue = difficulty;
      },
    );
  }

  Widget _buildIoTypeField(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
  ) {
    return DropdownButtonFormField<IoType>(
      decoration: const InputDecoration(
        hintText: 'I/O type',
        contentPadding: EdgeInsets.all(
          kdUpdateProposalDashboardViewFieldPadding,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusedBorder: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kcLightGrey),
          borderRadius: BorderRadius.all(
            Radius.circular(
              kdUpdateProposalDashboardViewFieldBorderRadius,
            ),
          ),
        ),
      ),
      value: viewModel.ioTypeValue,
      items: IoType.values
          .map(
            (ioType) => DropdownMenuItem<IoType>(
              value: ioType,
              enabled: ioType != IoType.file,
              child: Text(ioType.value),
            ),
          )
          .toList(),
      onChanged: (ioType) {
        viewModel.ioTypeValue = ioType;
      },
    );
  }

  Widget _buildDescriptionField(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: kdUpdateProposalDashboardViewDescriptionMaxHeight,
      ),
      child: Card(
        color: kcVeryLightGrey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kdUpdateProposalDashboardViewFieldPadding,
            ),
            child: SplittedMarkdownFormField(
              controller: descriptionController,
              markdownSyntax: '## Add your problem description here',
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
              emojiConvert: true,
              minLines: 5,
              validator: ProblemValidators.validateDescription,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> onViewModelReady(
    UpdateProposalDashboardViewModel viewModel,
  ) async {
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
        } else {
          syncFormWithViewModel(viewModel);
          await viewModel.init();
        }
      },
    );
  }

  @override
  UpdateProposalDashboardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      UpdateProposalDashboardViewModel(problemId: problemId);

  @override
  void onDispose(UpdateProposalDashboardViewModel viewModel) {
    super.onDispose(viewModel);

    disposeForm();
    viewModel.sidebarController.dispose();
  }
}
