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
import 'package:midgard/ui/widgets/app_primitives/expandable_fab/expandable_fab.dart';
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
    FormTextField(
      name: 'testScore',
      validator: ProblemValidators.validateTestScore,
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
      floatingActionButton: ExpandableFab(
        distance: kdFabDistance,
        children: [
          Tooltip(
            message: ksAppUpdateTooltip,
            child: ActionButton(
              onPressed: () async {
                await viewModel.updateProblem();

                if (!context.mounted) return;

                if (viewModel.hasErrorForKey(kbUpdateProposalDashboardKey)) {
                  await context.showErrorBar(
                    position: FlashPosition.top,
                    indicatorColor: kcRed,
                    content: Text(
                      viewModel.error(kbUpdateProposalDashboardKey).message
                          as String,
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
              icon: const Icon(Icons.save),
            ),
          ),
          Tooltip(
            message: ksAppPublishTooltip,
            child: ActionButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                await viewModel.publishProblem();

                if (!context.mounted) return;

                if (viewModel.hasErrorForKey(kbPublishProblemKey)) {
                  await context.showErrorBar(
                    position: FlashPosition.top,
                    indicatorColor: kcRed,
                    content: Text(
                      viewModel.error(kbPublishProblemKey).message as String,
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
            ),
          ),
        ],
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
              const Text(
                'Update problem',
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
              verticalSpaceLarge,
              ExpansionTile(
                title: const Text(
                  'Update problem test cases',
                  style: TextStyle(
                    color: kcBlack,
                    fontSize: kdUpdateProposalDashboardViewSubtitleTextSize,
                  ),
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
                  _buildTestForm(
                    context,
                    viewModel,
                  ),
                ],
              ),
              verticalSpaceMedium,
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
            label: Text('Problem name'),
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
            label: Text('Brief'),
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
            label: Text('Source name'),
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
            label: Text('Author name'),
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
            label: Text('Time limit (sec)'),
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
            label: Text('Total memory limit (MB)'),
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
            label: Text('Stack memory limit (MB)'),
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
        label: Text('Difficulty'),
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
        label: Text('I/O type'),
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

  Widget _buildTestForm(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        const Text(
          'Add new test case',
          style: TextStyle(
            color: kcBlack,
            fontSize: kdUpdateProposalDashboardViewSubtitleTextSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        verticalSpaceMedium,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 4,
              child: _buildTestScoreField(
                context,
                viewModel,
              ),
            ),
            const Flexible(child: horizontalSpaceTiny),
            Flexible(
              flex: 4,
              child: _buildTestFilePicker(
                context,
                viewModel,
              ),
            ),
            const Flexible(child: horizontalSpaceTiny),
            Flexible(
              flex: 4,
              child: IconButton(
                onPressed: () async {
                  await viewModel.addTest();

                  if (!context.mounted) return;

                  if (viewModel.hasErrorForKey(kbAddTestKey)) {
                    await context.showErrorBar(
                      position: FlashPosition.top,
                      indicatorColor: kcRed,
                      content: Text(
                        viewModel.error(kbAddTestKey).message as String,
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
                      content: const Text('Test case added successfully!'),
                      primaryActionBuilder: (context, controller) {
                        return IconButton(
                          onPressed: controller.dismiss,
                          icon: const Icon(Icons.close),
                        );
                      },
                    );
                  }
                },
                icon: const CircleAvatar(
                  backgroundColor: kcGreenAccent,
                  child: Icon(
                    Icons.add,
                  ),
                ),
                tooltip: ksAppAddTestTooltip,
                iconSize: kdUpdateProposalDashboardViewIconSize,
              ),
            ),
          ],
        ),
        verticalSpaceMedium,
        _buildTestsTableView(
          context,
          viewModel,
          viewModel.problem.fold(
            () => [],
            (problem) => problem.tests.getOrElse(() => []),
          ),
        ),
        verticalSpaceMedium,
        if (viewModel.busy(kbAddTestKey) || viewModel.busy(kbDeleteTestKey))
          const LinearProgressIndicator(),
        verticalSpaceMedium,
      ],
    );
  }

  Widget _buildTestScoreField(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
  ) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Test score',
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
            label: Text('Test score'),
          ),
          focusNode: testScoreFocusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          controller: testScoreController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(kLimitDecimalRegex)),
          ],
        ),
        if (viewModel.hasTestScoreValidationMessage) ...[
          verticalSpaceTiny,
          Text(
            viewModel.testScoreValidationMessage!,
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

  Widget _buildTestFilePicker(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
  ) {
    return ListTile(
      title: Text(
        'Filename: ${viewModel.newTestArchiveFile.fold(
          () => 'Select test archive file',
          (file) => file.filename,
        )}',
      ),
      titleTextStyle: const TextStyle(
        color: kcBlack,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w500,
      ),
      leading: const Icon(
        Icons.attach_file,
        color: kcOrangeAccent,
        size: kdUpdateProposalDashboardViewIconSize,
      ),
      onTap: () async {
        await viewModel.updateTestArchiveFile();
      },
    );
  }

  Widget _buildTestsTableView(
    BuildContext context,
    UpdateProposalDashboardViewModel viewModel,
    List<TestModel> tests,
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
                  'Test Id',
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
                  'Input',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Output',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                  ),
                ),
              ),
              // DataColumn(
              //   label: Text(
              //     'Update',
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       fontSize: kdSingleProblemViewDataColumnTitleFontSize,
              //     ),
              //   ),
              // ),
              DataColumn(
                label: Text(
                  'Delete',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: kdSingleProblemViewDataColumnTitleFontSize,
                  ),
                ),
              ),
            ],
            rows: tests
                .map(
                  (test) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          test.idPretty,
                        ),
                      ),
                      DataCell(
                        Text(
                          test.scorePretty,
                        ),
                      ),
                      DataCell(
                        IconButton(
                          onPressed: () {
                            viewModel.downloadTestDataFromUrl(
                              testId: test.idPretty,
                              filename: ksAppTestInputFilename,
                              url: test.inputUrl,
                            );
                          },
                          icon: const Icon(
                            Icons.download,
                          ),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          onPressed: () {
                            viewModel.downloadTestDataFromUrl(
                              testId: test.idPretty,
                              filename: ksAppTestOutputFilename,
                              url: test.outputUrl,
                            );
                          },
                          icon: const Icon(
                            Icons.download,
                          ),
                        ),
                      ),
                      // DataCell(
                      //   IconButton(
                      //     onPressed: () {
                      //       AwesomeDialog(
                      //         context: context,
                      //         enableEnterKey: true,
                      //         customHeader: const Center(
                      //           child: Icon(
                      //             Icons.info,
                      //             color: kcBlueAccent,
                      //             size:
                      //                 kdUpdateProposalDashboardViewDialogIconSize,
                      //           ),
                      //         ),
                      //         animType: AnimType.bottomSlide,
                      //         body: UpdateTestTile(
                      //           test: test,
                      //         ),
                      //         btnOkIcon: Icons.check,
                      //         btnOkOnPress: () {},
                      //         btnCancelIcon: Icons.cancel,
                      //         btnCancelOnPress: () {},
                      //       ).show();
                      //     },
                      //     icon: const Icon(
                      //       Icons.edit,
                      //     ),
                      //   ),
                      // ),
                      DataCell(
                        IconButton(
                          onPressed: () async {
                            await viewModel.deleteTest(
                              testId: test.id,
                            );

                            if (!context.mounted) return;

                            if (viewModel.hasErrorForKey(kbDeleteTestKey)) {
                              await context.showErrorBar(
                                position: FlashPosition.top,
                                indicatorColor: kcRed,
                                content: Text(
                                  viewModel.error(kbDeleteTestKey).message
                                      as String,
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
                                content: const Text(
                                  'Test case deleted successfully!',
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
                          icon: const Icon(
                            Icons.delete,
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
