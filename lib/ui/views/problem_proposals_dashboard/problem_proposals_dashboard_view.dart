import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/models/validators/problem_validators.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/views/problem_proposals_dashboard/problem_proposals_dashboard_view.form.dart';
import 'package:midgard/ui/views/problem_proposals_dashboard/problem_proposals_dashboard_viewmodel.dart';
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
class ProblemProposalsDashboardView
    extends StackedView<ProblemProposalsDashboardViewModel>
    with $ProblemProposalsDashboardView {
  ProblemProposalsDashboardView({
    this.problemId,
    super.key,
  });

  late String? problemId;

  @override
  Widget builder(
    BuildContext context,
    ProblemProposalsDashboardViewModel viewModel,
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
              padding: const EdgeInsets.all(
                kdProblemProposalsDashboardViewPadding,
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
    ProblemProposalsDashboardViewModel viewModel,
  ) {
    return ScrollConfiguration(
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
    );
  }

  Widget _buildNameField(
    BuildContext context,
    ProblemProposalsDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Problem name',
            contentPadding: EdgeInsets.all(
              kdProblemProposalsDashboardViewFieldPadding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  kdProblemProposalsDashboardViewFieldBorderRadius,
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
              fontSize: kdProblemProposalsDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBriefField(
    BuildContext context,
    ProblemProposalsDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Brief',
            contentPadding: EdgeInsets.all(
              kdProblemProposalsDashboardViewFieldPadding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  kdProblemProposalsDashboardViewFieldBorderRadius,
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
              fontSize: kdProblemProposalsDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSourceNameField(
    BuildContext context,
    ProblemProposalsDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Source name',
            contentPadding: EdgeInsets.all(
              kdProblemProposalsDashboardViewFieldPadding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  kdProblemProposalsDashboardViewFieldBorderRadius,
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
              fontSize: kdProblemProposalsDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAuthorNameField(
    BuildContext context,
    ProblemProposalsDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Author name',
            contentPadding: EdgeInsets.all(
              kdProblemProposalsDashboardViewFieldPadding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  kdProblemProposalsDashboardViewFieldBorderRadius,
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
              fontSize: kdProblemProposalsDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimeLimitField(
    BuildContext context,
    ProblemProposalsDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Time limit (sec)',
            contentPadding: EdgeInsets.all(
              kdProblemProposalsDashboardViewFieldPadding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  kdProblemProposalsDashboardViewFieldBorderRadius,
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
              fontSize: kdProblemProposalsDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTotalMemoryLimitField(
    BuildContext context,
    ProblemProposalsDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Total memory limit (MB)',
            contentPadding: EdgeInsets.all(
              kdProblemProposalsDashboardViewFieldPadding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  kdProblemProposalsDashboardViewFieldBorderRadius,
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
              fontSize: kdProblemProposalsDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStackMemoryLimitField(
    BuildContext context,
    ProblemProposalsDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Stack memory limit (MB)',
            contentPadding: EdgeInsets.all(
              kdProblemProposalsDashboardViewFieldPadding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kcLightGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  kdProblemProposalsDashboardViewFieldBorderRadius,
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
              fontSize: kdProblemProposalsDashboardViewFieldValidationTextSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDifficultyField(
    BuildContext context,
    ProblemProposalsDashboardViewModel viewModel,
  ) {
    return DropdownButtonFormField<Difficulty>(
      decoration: const InputDecoration(
        hintText: 'Difficulty',
        contentPadding: EdgeInsets.all(
          kdProblemProposalsDashboardViewFieldPadding,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusedBorder: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kcLightGrey),
          borderRadius: BorderRadius.all(
            Radius.circular(
              kdProblemProposalsDashboardViewFieldBorderRadius,
            ),
          ),
        ),
      ),
      // value: viewModel.difficultyValue,
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
        viewModel.difficultyValue = difficulty!;
      },
    );
  }

  Widget _buildIoTypeField(
    BuildContext context,
    ProblemProposalsDashboardViewModel viewModel,
  ) {
    return DropdownButtonFormField<IoType>(
      decoration: const InputDecoration(
        hintText: 'I/O type',
        contentPadding: EdgeInsets.all(
          kdProblemProposalsDashboardViewFieldPadding,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusedBorder: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kcLightGrey),
          borderRadius: BorderRadius.all(
            Radius.circular(
              kdProblemProposalsDashboardViewFieldBorderRadius,
            ),
          ),
        ),
      ),
      // value: viewModel.ioTypeValue,
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
        viewModel.ioTypeValue = ioType!;
      },
    );
  }

  Widget _buildDescriptionField(
    BuildContext context,
    ProblemProposalsDashboardViewModel viewModel,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: kdProblemProposalsDashboardViewDescriptionMaxHeight,
      ),
      child: Card(
        color: kcVeryLightGrey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kdProblemProposalsDashboardViewFieldPadding,
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
  void onViewModelReady(
    ProblemProposalsDashboardViewModel viewModel,
  ) {
    super.onViewModelReady(viewModel);

    syncFormWithViewModel(viewModel);
  }

  @override
  ProblemProposalsDashboardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProblemProposalsDashboardViewModel(
        problemId: problemId,
      );

  @override
  void onDispose(ProblemProposalsDashboardViewModel viewModel) {
    super.onDispose(viewModel);

    disposeForm();
    viewModel.sidebarController.dispose();
  }
}
