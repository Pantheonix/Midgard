import 'package:dartz/dartz.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/exceptions/problem_exception.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/models/user/user_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/problem_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:universal_html/html.dart';

class SingleProblemProposalViewModel extends FutureViewModel<ProblemModel> {
  SingleProblemProposalViewModel({
    required this.problemId,
  });

  final String problemId;

  final _problemService = locator<ProblemService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();
  final _logger = getLogger('SingleProblemProposalViewModel');

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarProblemProposalsMenuIndex,
    extended: true,
  );

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  Option<UserProfileModel> get currentUser =>
      _hiveService.getCurrentUserProfile();

  @override
  Future<ProblemModel> futureToRun() => _getProblem(problemId);

  Future<ProblemModel> _getProblem(String problemId) async {
    final problem = await _problemService.getByIdUnpublished(
      problemId: problemId,
    );

    return problem.fold(
      (ProblemException error) async {
        _logger.e(
          'Error getting unpublished problem: ${error.toJson()}',
        );

        throw Exception(
          'Unable to retrieve unpublished problem data: ${error.message}',
        );
      },
      (ProblemModel problem) async {
        _logger.i('Problem retrieved: ${problem.toJson()}');

        return problem;
      },
    );
  }

  Future<void> _publishProblem({
    required String problemId,
  }) async {
    final result = await _problemService.publish(
      problemId: problemId,
    );

    await result.fold(
      (ProblemException error) async {
        _logger.e(
          'Error while publishing problem: ${error.toJson()}',
        );

        throw Exception(error.message);
      },
      (_) async {
        _logger.i('Problem published successfully');
        await _routerService.replaceWithSingleProblemView(
          problemId: problemId,
        );
      },
    );
  }

  Future<void> publishProblem({
    required String problemId,
  }) async {
    await runBusyFuture(
      _publishProblem(
        problemId: problemId,
      ),
      busyObject: kbSingleProblemProposalKey,
    );
  }

  Future<void> downloadTestDataFromUrl({
    required String testId,
    required String filename,
    required String url,
  }) async {
    AnchorElement(href: url)
      ..download = '$testId-$filename'
      ..click();
  }
}
