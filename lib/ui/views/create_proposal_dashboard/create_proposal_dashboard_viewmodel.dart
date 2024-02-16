import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/exceptions/problem_exception.dart';
import 'package:midgard/models/problem/create_problem_models.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/problem_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/views/create_proposal_dashboard/create_proposal_dashboard_view.form.dart';
import 'package:sentry/sentry.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreateProposalDashboardViewModel extends FormViewModel {
  final _problemService = locator<ProblemService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();
  final _logger = getLogger('CreateProposalDashboardViewModel');

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarProposalDashboardMenuIndex,
    extended: true,
  );

  late Difficulty? _difficulty;
  late IoType? _ioType;

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  Difficulty? get difficultyValue => _difficulty;

  IoType? get ioTypeValue => _ioType;

  set difficultyValue(Difficulty? difficulty) {
    _difficulty = difficulty;
    rebuildUi();
  }

  set ioTypeValue(IoType? ioType) {
    _ioType = ioType;
    rebuildUi();
  }

  Future<void> _createProblem() async {
    // check client validation rules
    await runBusyFuture(
      _validate(),
      busyObject: kbCreateProposalDashboardKey,
    );

    if (hasAnyValidationMessage) return;

    final createProblemRequest = CreateProblemRequest(
      name: nameValue ?? '',
      brief: briefValue ?? '',
      description: descriptionValue ?? '',
      sourceName: sourceNameValue ?? '',
      authorName: authorNameValue ?? '',
      timeLimit: switch (timeLimitValue) {
        final data? => double.parse(data),
        null => 0.0,
      },
      totalMemoryLimit: switch (totalMemoryLimitValue) {
        final data? => double.parse(data),
        null => 0.0,
      },
      stackMemoryLimit: switch (stackMemoryLimitValue) {
        final data? => double.parse(data),
        null => 0.0,
      },
      ioType: _ioType ?? IoType.standard,
      difficulty: _difficulty ?? Difficulty.easy,
    );

    final result = await _problemService.create(
      request: createProblemRequest,
    );

    await result.fold(
      (ProblemException error) async {
        _logger.e('Error while creating problem: ${error.toJson()}');
        await Sentry.captureException(
          Exception('Error while creating problem: ${error.toJson()}'),
          stackTrace: StackTrace.current,
        );

        throw Exception('Error while creating problem: ${error.toJson()}');
      },
      (ProblemModel problem) async {
        _logger.i('Problem created successfully');

        await _routerService.replaceWithProblemProposalsView();
      },
    );
  }

  Future<void> createProblem() async {
    await runBusyFuture(
      _createProblem(),
      busyObject: kbCreateProposalDashboardKey,
    );
  }

  Future<void> _validate() async {
    if (hasNameValidationMessage) {
      throw Exception(nameValidationMessage);
    }

    if (hasBriefValidationMessage) {
      throw Exception(briefValidationMessage);
    }

    if (hasDescriptionValidationMessage) {
      throw Exception(descriptionValidationMessage);
    }

    if (hasSourceNameValidationMessage) {
      throw Exception(sourceNameValidationMessage);
    }

    if (hasAuthorNameValidationMessage) {
      throw Exception(authorNameValidationMessage);
    }

    if (hasTimeLimitValidationMessage) {
      throw Exception(timeLimitValidationMessage);
    }

    if (hasTotalMemoryLimitValidationMessage) {
      throw Exception(totalMemoryLimitValidationMessage);
    }

    if (hasStackMemoryLimitValidationMessage) {
      throw Exception(stackMemoryLimitValidationMessage);
    }

    if (_difficulty == null) {
      throw Exception('Please select a difficulty');
    }

    if (_ioType == null) {
      throw Exception('Please select an I/O type');
    }
  }
}
