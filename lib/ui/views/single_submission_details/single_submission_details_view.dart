import 'package:flutter/material.dart';
import 'package:midgard/ui/views/single_submission_details/single_submission_details_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

class SingleSubmissionDetailsView
    extends StackedView<SingleSubmissionDetailsViewModel> {
  const SingleSubmissionDetailsView(
    this.problemId, {
    @PathParam('submissionId') required this.submissionId,
    super.key,
  });

  final String submissionId;
  final String problemId;

  @override
  Widget builder(
    BuildContext context,
    SingleSubmissionDetailsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Center(
          child: Text(
            '$submissionId - $problemId',
          ),
        ),
      ),
    );
  }

  @override
  SingleSubmissionDetailsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SingleSubmissionDetailsViewModel();
}
