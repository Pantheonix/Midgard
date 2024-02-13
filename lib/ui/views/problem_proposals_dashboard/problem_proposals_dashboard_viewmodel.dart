import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/problem_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/views/problem_proposals_dashboard/problem_proposals_dashboard_view.form.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProblemProposalsDashboardViewModel extends FormViewModel {
  ProblemProposalsDashboardViewModel({
    required this.problemId,
  });

  final String? problemId;

  final _problemService = locator<ProblemService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();
  final _logger = getLogger('ProblemProposalsDashboardViewModel');

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarProblemProposalsDashboardMenuIndex,
    extended: true,
  );

  late Difficulty _difficulty;
  late IoType _ioType;

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  Difficulty get difficultyValue => _difficulty;

  IoType get ioTypeValue => _ioType;

  set difficultyValue(Difficulty difficulty) {
    _difficulty = difficulty;
    rebuildUi();
  }

  set ioTypeValue(IoType ioType) {
    _ioType = ioType;
    rebuildUi();
  }

  void save() {
    _logger
      ..d(problemId)
      ..d(descriptionValue);
  }
}
