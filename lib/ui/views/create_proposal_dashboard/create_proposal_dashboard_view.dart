import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/models/validators/problem_validators.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/app_strings.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/create_proposal_dashboard/create_proposal_dashboard_view.form.dart';
import 'package:midgard/ui/views/create_proposal_dashboard/create_proposal_dashboard_viewmodel.dart';
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
class CreateProposalDashboardView
    extends StackedView<CreateProposalDashboardViewModel>
    with $CreateProposalDashboardView {
  const CreateProposalDashboardView({super.key});

  @override
  Widget builder(
    BuildContext context,
    CreateProposalDashboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      drawer: AppSidebar(
        controller: viewModel.sidebarController,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await viewModel.createProblem();

          if (!context.mounted) return;

          if (viewModel.hasErrorForKey(kbCreateProposalDashboardKey)) {
            await context.showErrorBar(
              position: FlashPosition.top,
              indicatorColor: kcRed,
              content: Text(
                viewModel.error(kbCreateProposalDashboardKey).message as String,
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
        splashColor: kcGreenAccent,
        tooltip: ksAppSaveTooltip,
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
                kdCreateProposalDashboardViewPadding,
              ),
              child: _buildProblemForm(
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
    CreateProposalDashboardViewModel viewModel,
  ) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Create problem',
              style: TextStyle(
                color: kcBlack,
                fontSize: kdUpdateProposalDashboardViewTitleTextSize,
                fontWeight: FontWeight.w700,
              ),
            ),
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
    );
  }

  Widget _buildNameField(
    BuildContext context,
    CreateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Problem name',
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
              fontSize: kdCreateProposalDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBriefField(
    BuildContext context,
    CreateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Brief',
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
              fontSize: kdCreateProposalDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSourceNameField(
    BuildContext context,
    CreateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Source name',
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
              fontSize: kdCreateProposalDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAuthorNameField(
    BuildContext context,
    CreateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Author name',
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
              fontSize: kdCreateProposalDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimeLimitField(
    BuildContext context,
    CreateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Time limit (sec)',
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
              fontSize: kdCreateProposalDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTotalMemoryLimitField(
    BuildContext context,
    CreateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Total memory limit (MB)',
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
              fontSize: kdCreateProposalDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStackMemoryLimitField(
    BuildContext context,
    CreateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Stack memory limit (MB)',
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
              fontSize: kdCreateProposalDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDifficultyField(
    BuildContext context,
    CreateProposalDashboardViewModel viewModel,
  ) {
    return DropdownButtonFormField<Difficulty>(
      decoration: const InputDecoration(
        hintText: 'Difficulty',
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
    CreateProposalDashboardViewModel viewModel,
  ) {
    return DropdownButtonFormField<IoType>(
      decoration: const InputDecoration(
        hintText: 'I/O type',
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
    CreateProposalDashboardViewModel viewModel,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: kdCreateProposalDashboardViewDescriptionMaxHeight,
      ),
      child: Card(
        color: kcVeryLightGrey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kdCreateProposalDashboardViewFieldPadding,
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
    CreateProposalDashboardViewModel viewModel,
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
        }
      },
    );
  }

  @override
  CreateProposalDashboardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CreateProposalDashboardViewModel();

  @override
  void onDispose(CreateProposalDashboardViewModel viewModel) {
    super.onDispose(viewModel);

    disposeForm();
    viewModel.sidebarController.dispose();
  }
}
