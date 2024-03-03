import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/common/ui_helpers.dart';
import 'package:midgard/ui/widgets/submission/submission_proposal_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SubmissionProposal extends StatelessWidget {
  const SubmissionProposal({
    required this.problemId,
    super.key,
  });

  final String problemId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubmissionProposalViewModel>.reactive(
      builder: (context, viewModel, child) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _selectLanguageDropdown(viewModel),
              horizontalSpaceMedium,
              _selectThemeDropdown(viewModel),
            ],
          ),
          verticalSpaceTiny,
          Card(
            child: CodeTheme(
              data: CodeThemeData(
                styles: viewModel.selectedSourceCodeTheme.theme,
              ),
              child: SingleChildScrollView(
                child: CodeField(
                  controller: viewModel.sourceCodeController,
                ),
              ),
            ),
          ),
          verticalSpaceTiny,
          if (viewModel.isLoading) const LinearProgressIndicator(),
          verticalSpaceTiny,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kcVeryLightGrey,
            ),
            onPressed: () async {
              await viewModel.submitSolution();

              if (!context.mounted) return;

              if (viewModel.hasErrorForKey(kbSendSubmissionKey)) {
                await context.showErrorBar(
                  position: FlashPosition.top,
                  indicatorColor: kcRed,
                  content: Text(
                    viewModel.error(kbSendSubmissionKey).message as String,
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
                  content: const Text('Solution submitted successfully'),
                  primaryActionBuilder: (context, controller) {
                    return IconButton(
                      onPressed: controller.dismiss,
                      icon: const Icon(Icons.close),
                    );
                  },
                );
              }
            },
            child: const Text(
              'Submit solution',
              style: TextStyle(
                color: kcBlack,
                fontWeight: FontWeight.bold,
                fontSize: kdSubmissionProposalWidgetSendButtonFontSize,
              ),
            ),
          ),
        ],
      ),
      viewModelBuilder: () => SubmissionProposalViewModel(
        problemId: problemId,
      ),
    );
  }

  Widget _selectLanguageDropdown(SubmissionProposalViewModel viewModel) {
    return DropdownButton<LanguageTheme>(
      value: viewModel.selectedLanguageTheme,
      items: viewModel.languageThemes
          .map<DropdownMenuItem<LanguageTheme>>(
            (LanguageTheme value) => DropdownMenuItem<LanguageTheme>(
              value: value,
              child: Text(value.language.displayName),
            ),
          )
          .toList(),
      onChanged: (LanguageTheme? value) {
        if (value != null) {
          viewModel.selectedLanguageTheme = value;
        }
      },
    );
  }

  Widget _selectThemeDropdown(SubmissionProposalViewModel viewModel) {
    return DropdownButton<SourceCodeTheme>(
      value: viewModel.selectedSourceCodeTheme,
      items: viewModel.sourceCodeThemes
          .map<DropdownMenuItem<SourceCodeTheme>>(
            (SourceCodeTheme value) => DropdownMenuItem<SourceCodeTheme>(
              value: value,
              child: Text(value.name),
            ),
          )
          .toList(),
      onChanged: (SourceCodeTheme? value) {
        if (value != null) {
          viewModel.selectedSourceCodeTheme = value;
        }
      },
    );
  }
}
