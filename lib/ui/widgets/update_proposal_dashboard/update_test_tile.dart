import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/models/validators/problem_validators.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/widgets/update_proposal_dashboard/update_test_tile.form.dart';
import 'package:midgard/ui/widgets/update_proposal_dashboard/update_test_tile_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

@FormView(
  fields: [
    FormTextField(
      name: 'testScore',
      validator: ProblemValidators.validateTestScore,
    ),
  ],
)
class UpdateTestTile extends StatelessWidget with $UpdateTestTile {
  const UpdateTestTile({
    required this.test,
    super.key,
  });

  final TestModel test;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateTestTileViewModel>.nonReactive(
      builder: (context, viewModel, child) => _buildTestForm(
        context,
        viewModel,
      ),
      viewModelBuilder: () => UpdateTestTileViewModel(test: test),
    );
  }

  Widget _buildTestForm(
    BuildContext context,
    UpdateTestTileViewModel viewModel,
  ) {
    return Column(
      children: [
        const Text(
          'Update test case',
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
          ],
        ),
        verticalSpaceMedium,
      ],
    );
  }

  Widget _buildTestScoreField(
    BuildContext context,
    UpdateTestTileViewModel viewModel,
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
    UpdateTestTileViewModel viewModel,
  ) {
    return ListTile(
      title: Text(
        'Filename: ${viewModel.testArchiveFile.fold(
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
}
