import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/models/exceptions/problem_exception.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/problem_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/views/problem_proposals/problem_proposals_view.form.dart';
import 'package:sentry/sentry.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProblemProposalsViewModel extends FormViewModel {
  final _problemService = locator<ProblemService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();
  final _logger = getLogger('ProblemProposalsViewModel');

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarProblemProposalsMenuIndex,
    extended: true,
  );

  final _problems = <ProblemModel>[];
  late String _selectedProblemId = '';
  late int _count = 0;
  late int _page = 1;
  late Difficulty _difficulty = Difficulty.all;

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  List<ProblemModel> get problems => _problems;

  String get selectedProblemIdValue => _selectedProblemId;

  int get count => _count;

  int get pageValue => _page;

  Difficulty get difficultyValue => _difficulty;

  set selectedProblemIdValue(String id) {
    _selectedProblemId = id;
    rebuildUi();
  }

  set pageValue(int page) {
    _page = page;
    rebuildUi();
  }

  set difficultyValue(Difficulty difficulty) {
    _difficulty = difficulty;
    rebuildUi();
  }

  Future<List<ProblemModel>> getProblems({
    String? name,
    String? difficulty,
    int? page,
    int? pageSize,
  }) async {
    final result = await _problemService.getAllUnpublished(
      name: name,
      difficulty: difficulty,
      page: page,
      pageSize: pageSize,
    );

    return result.fold(
      (ProblemException error) async {
        _logger.e(
          'Error while retrieving unpublished problems: ${error.toJson()}',
        );
        await Sentry.captureException(
          Exception(
            'Error while retrieving unpublished problems: ${error.toJson()}',
          ),
          stackTrace: StackTrace.current,
        );
        return [];
      },
      (data) async {
        final (:problems, :count) = data;
        _logger.i(
          'Retrieved ${problems.length} unpublished problems',
        );
        await Sentry.captureMessage(
          'Retrieved ${problems.length} unpublished problems',
        );

        _count = count;
        return problems;
      },
    );
  }

  Future<void> init() async {
    _logger.i('Unpublished problems list updated');
    await Sentry.captureMessage('Unpublished problems list updated');

    _problems
      ..clear()
      ..addAll(
        await runBusyFuture(
          getProblems(
            name: nameValue,
            difficulty: difficultyValue == Difficulty.all
                ? null
                : Difficulty.toValue(difficultyValue).toString(),
            page: pageValue == 0 ? null : pageValue,
            pageSize: kiProblemsViewPageSize,
          ),
          busyObject: kbProblemsKey,
        ),
      );
  }
}
