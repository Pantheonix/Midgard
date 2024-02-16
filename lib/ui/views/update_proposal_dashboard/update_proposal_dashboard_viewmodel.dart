import 'package:dartz/dartz.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/models/exceptions/problem_exception.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/models/problem/update_problem_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/problem_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/views/update_proposal_dashboard/update_proposal_dashboard_view.form.dart';
import 'package:sentry/sentry.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UpdateProposalDashboardViewModel extends FormViewModel {
  UpdateProposalDashboardViewModel({
    required this.problemId,
  });

  final String problemId;

  final _problemService = locator<ProblemService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();
  final _logger = getLogger('UpdateProposalDashboardViewModel');

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarProposalDashboardMenuIndex,
    extended: true,
  );

  late Option<ProblemModel> _problem = none();
  late Difficulty? _difficulty;
  late IoType? _ioType;

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  Option<ProblemModel> get problem => _problem;

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

  Future<Option<ProblemModel>> _getProblem(String problemId) async {
    final problem = await _problemService.getByIdUnpublished(
      problemId: problemId,
    );

    return await problem.fold(
      (ProblemException error) async {
        _logger.e(
          'Error getting unpublished problem: ${error.toJson()}',
        );
        await Sentry.captureException(
          Exception(
            'Error getting unpublished problem: ${error.toJson()}',
          ),
          stackTrace: StackTrace.current,
        );

        return none();
      },
      (ProblemModel problem) async {
        _logger.i('Problem retrieved: ${problem.toJson()}');
        await Sentry.captureMessage('Problem retrieved: ${problem.toJson()}');

        return some(problem);
      },
    );
  }

  Future<void> _updateProblem() async {
    // check client validation rules
    await runBusyFuture(
      _validate(),
      busyObject: kbUpdateProposalDashboardKey,
    );

    if (hasAnyValidationMessage) return;

    final updateProblemRequest = UpdateProblemRequest(
      name: switch (nameValue) {
        final data? => some(data),
        null => none(),
      },
      brief: switch (briefValue) {
        final data? => some(data),
        null => none(),
      },
      description: switch (descriptionValue) {
        final data? => some(data),
        null => none(),
      },
      sourceName: switch (sourceNameValue) {
        final data? => some(data),
        null => none(),
      },
      authorName: switch (authorNameValue) {
        final data? => some(data),
        null => none(),
      },
      timeLimit: switch (timeLimitValue) {
        final data? => some(double.parse(data)),
        null => none(),
      },
      totalMemoryLimit: switch (totalMemoryLimitValue) {
        final data? => some(double.parse(data)),
        null => none(),
      },
      stackMemoryLimit: switch (stackMemoryLimitValue) {
        final data? => some(double.parse(data)),
        null => none(),
      },
      ioType: switch (_ioType) {
        final data? => some(data),
        null => none(),
      },
      difficulty: switch (_difficulty) {
        final data? => some(data),
        null => none(),
      },
    );

    final result = await _problemService.update(
      problemId: problemId,
      request: updateProblemRequest,
    );

    await result.fold(
      (ProblemException error) async {
        _logger.e('Error while updating problem: ${error.toJson()}');
        await Sentry.captureException(
          Exception('Error while updating problem: ${error.toJson()}'),
          stackTrace: StackTrace.current,
        );

        throw Exception('Error while updating problem: ${error.message}');
      },
      (ProblemModel problem) async {
        _logger.i('Problem updated successfully');
        await Sentry.captureMessage('Problem updated successfully');

        await init();
      },
    );
  }

  Future<void> updateProblem() async {
    await runBusyFuture(
      _updateProblem(),
      busyObject: kbUpdateProposalDashboardKey,
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

  Future<void> init() async {
    _problem = await runBusyFuture(
      _getProblem(problemId),
      busyObject: kbUpdateProposalDashboardKey,
    );

    nameValue = _problem.fold(
      () => 'Problem name',
      (problem) => problem.name,
    );

    briefValue = _problem.fold(
      () => 'Brief',
      (problem) => problem.brief,
    );

    descriptionValue = _problem.fold(
      () => 'Description',
      (problem) => problem.description,
    );

    sourceNameValue = _problem.fold(
      () => 'Source name',
      (problem) => problem.sourceName,
    );

    authorNameValue = _problem.fold(
      () => 'Author name',
      (problem) => problem.authorName,
    );

    timeLimitValue = _problem.fold(
      () => '1.0',
      (problem) => problem.timeLimit.toString(),
    );

    totalMemoryLimitValue = _problem.fold(
      () => '64.0',
      (problem) => problem.totalMemoryLimit.toString(),
    );

    stackMemoryLimitValue = _problem.fold(
      () => '8.0',
      (problem) => problem.stackMemoryLimit.toString(),
    );

    _difficulty = _problem.fold(
      () => Difficulty.easy,
      (problem) => problem.difficulty,
    );

    _ioType = _problem.fold(
      () => IoType.standard,
      (problem) => problem.ioType,
    );
  }
}
