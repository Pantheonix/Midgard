import 'package:dartz/dartz.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/rust.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/exceptions/eval_exception.dart';
import 'package:midgard/models/exceptions/problem_exception.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/models/submission/submission_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/problem_service.dart';
import 'package:midgard/services/submission_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SingleSubmissionDetailsViewModel extends MultipleFutureViewModel {
  SingleSubmissionDetailsViewModel({
    required this.submissionId,
    required this.problemId,
    required this.isPublished,
  });

  final String submissionId;
  final String problemId;
  final bool isPublished;

  final _logger = getLogger('SingleSubmissionDetailsViewModel');
  final _problemService = locator<ProblemService>();
  final _submissionService = locator<SubmissionService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarSubmissionsMenuIndex,
    extended: true,
  );

  final _sourceCodeController = CodeController(
    text: Language.rust.placeholder,
    language: rust,
  );

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  CodeController get sourceCodeController => _sourceCodeController;

  SubmissionModel get submission =>
      dataMap![ksSubmissionDelayFuture] as SubmissionModel;

  Option<ProblemModel> get problem =>
      dataMap![ksProblemDelayFuture] as Option<ProblemModel>;

  bool get fetchingSubmission => busy(ksSubmissionDelayFuture);

  bool get fetchingProblem => busy(ksProblemDelayFuture);

  @override
  Map<String, Future Function()> get futuresMap => {
        ksSubmissionDelayFuture: _getSubmission,
        ksProblemDelayFuture: _getProblem,
      };

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
        sourceCodeController
          ..text = submission.sourceCode.getOrElse(() => '')
          ..language = submission.language.theme;

        return submission;
      },
    );
  }

  Future<Option<ProblemModel>> _getProblem() async {
    final problem = switch (isPublished) {
      true => await _problemService.getById(problemId: problemId),
      false => await _problemService.getByIdUnpublished(problemId: problemId),
    };

    return problem.fold(
      (ProblemException error) async {
        _logger.e('Error getting problem: ${error.toJson()}');

        return none();
      },
      (ProblemModel problem) async {
        _logger.i('Problem retrieved: ${problem.toJson()}');

        return some(problem);
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
    required bool isPublished,
  }) async {
    await routerService.replaceWithSingleSubmissionDetailsView(
      submissionId: submissionId,
      problemId: problemId,
      isPublished: isPublished,
    );
  }
}
