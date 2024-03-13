import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/exceptions/eval_exception.dart';
import 'package:midgard/models/submission/submission_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/submission_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SingleSubmissionViewModel extends FutureViewModel<SubmissionModel> {
  SingleSubmissionViewModel({
    required this.submissionId,
  });

  final String submissionId;

  final _logger = getLogger('SingleSubmissionViewModel');
  final _submissionService = locator<SubmissionService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  @override
  Future<SubmissionModel> futureToRun() => _getSubmission();

  Future<void> refresh() async {
    await initialise();
  }

  Future<SubmissionModel> _getSubmission() async {
    _logger.i('Retrieving submission: $submissionId');

    final result = await _submissionService.getById(
      submissionId: submissionId,
    );

    return result.fold(
      (EvalException error) {
        _logger.e('Error retrieving submission: ${error.message}');
        throw Exception(
          'Error retrieving submission: ${error.message}',
        );
      },
      (SubmissionModel submission) {
        _logger.i('Submission retrieved successfully: ${submission.id}');
        return submission;
      },
    );
  }

  Future<void> navigateToProblemPage({
    required String problemId,
    required bool isPublished,
  }) async {
    if (isPublished) {
      await routerService.replaceWithSingleProblemView(
        problemId: problemId,
      );
    } else {
      await routerService.replaceWithSingleProblemProposalView(
        problemId: problemId,
      );
    }
  }

  Future<void> navigateToSubmissionPage({
    required String submissionId,
    required String problemId,
  }) async {
    await routerService.replaceWithSingleSubmissionDetailsView(
      submissionId: submissionId,
      problemId: problemId,
    );
  }
}
