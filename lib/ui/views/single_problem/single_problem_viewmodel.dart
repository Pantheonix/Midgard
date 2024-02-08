import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/models/exceptions/problem_exception.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/problem_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:sentry/sentry.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SingleProblemViewModel extends FutureViewModel<ProblemModel> {
  SingleProblemViewModel({
    required this.problemId,
  });

  final String problemId;

  final _problemService = locator<ProblemService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();
  final _logger = getLogger('SingleProblemViewModel');

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarProblemsMenuIndex,
    extended: true,
  );

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  @override
  Future<ProblemModel> futureToRun() => _getProblem(problemId);

  Future<ProblemModel> _getProblem(String problemId) async {
    final problem = await _problemService.getById(problemId: problemId);

    return problem.fold(
      (ProblemException error) async {
        _logger.e('Error getting problem: ${error.toJson()}');
        await Sentry.captureException(
          Exception('Error getting problem: ${error.toJson()}'),
          stackTrace: StackTrace.current,
        );

        throw Exception('Unable to retrieve problem data: ${error.message}');
      },
      (ProblemModel problem) async {
        _logger.i('Problem retrieved: ${problem.toJson()}');
        await Sentry.captureMessage('Problem retrieved: ${problem.toJson()}');

        return problem;
      },
    );
  }
}
