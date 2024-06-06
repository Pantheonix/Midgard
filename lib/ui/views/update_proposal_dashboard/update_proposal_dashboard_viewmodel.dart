import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/core/file_data.dart';
import 'package:midgard/models/exceptions/problem_exception.dart';
import 'package:midgard/models/problem/create_problem_models.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/models/problem/update_problem_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/problem_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/views/update_proposal_dashboard/update_proposal_dashboard_view.form.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:universal_html/html.dart';

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
  late Option<FileData> _newTestArchiveFile = none();
  late Difficulty? _difficulty;
  late IoType? _ioType;

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  Option<ProblemModel> get problem => _problem;

  Option<FileData> get newTestArchiveFile => _newTestArchiveFile;

  Difficulty? get difficultyValue => _difficulty;

  IoType? get ioTypeValue => _ioType;

  set problem(Option<ProblemModel> problem) {
    _problem = problem;
    rebuildUi();
  }

  set newTestArchiveFile(Option<FileData> file) {
    _newTestArchiveFile = file;
    rebuildUi();
  }

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

        return none();
      },
      (ProblemModel problem) async {
        _logger.i('Problem retrieved: ${problem.toJson()}');

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

        throw Exception('Error while updating problem: ${error.message}');
      },
      (ProblemModel data) async {
        _logger.i('Problem updated successfully');

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

  Future<void> _updateTestArchiveFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: kAllowedTestArchiveTypes,
    );

    if (result == null) return;

    final bytes = result.files.single.bytes;
    final mimeType = result.files.single.extension;
    final filename = result.files.single.name;
    final size = result.files.single.size;

    if (bytes == null || mimeType == null) return;

    if (size > kMaxProblemTestArchiveSize) {
      _logger.e('Test archive size is too large');
      throw Exception('Test archive size is too large');
    }

    newTestArchiveFile = some(
      (
        bytes: bytes,
        mimeType: 'application/$mimeType',
        filename: filename,
      ),
    );
  }

  Future<void> updateTestArchiveFile() async {
    await runBusyFuture(
      _updateTestArchiveFile(),
      busyObject: kbUpdateTestKey,
    );
  }

  Future<void> _addTest() async {
    if (hasTestScoreValidationMessage) {
      throw Exception(testScoreValidationMessage);
    }

    if (newTestArchiveFile.isNone()) {
      throw Exception('Please select a test archive file');
    }

    final addTestRequest = AddTestRequest(
      score: switch (testScoreValue) {
        final data? => int.parse(data),
        null => throw Exception('Please enter a test score'),
      },
      archiveFile: newTestArchiveFile.getOrElse(
        () => throw Exception('Please select a test archive file'),
      ),
    );

    final result = await _problemService.addTest(
      problemId: problemId,
      request: addTestRequest,
    );

    await result.fold(
      (ProblemException error) async {
        _logger.e('Error while adding test: ${error.toJson()}');

        throw Exception('Error while adding test: ${error.message}');
      },
      (ProblemModel data) async {
        _logger.i('Test added successfully');

        resetTestForm();
        problem = some(data);
      },
    );
  }

  Future<void> addTest() async {
    await runBusyFuture(
      _addTest(),
      busyObject: kbAddTestKey,
    );
  }

  Future<void> _deleteTest({
    required int testId,
  }) async {
    final result = await _problemService.deleteTest(
      problemId: problemId,
      testId: testId,
    );

    await result.fold(
      (ProblemException error) async {
        _logger.e('Error while deleting test: ${error.toJson()}');

        throw Exception('Error while deleting test: ${error.message}');
      },
      (ProblemModel data) async {
        _logger.i('Test deleted successfully');

        problem = some(data);
      },
    );
  }

  Future<void> deleteTest({
    required int testId,
  }) async {
    await runBusyFuture(
      _deleteTest(
        testId: testId,
      ),
      busyObject: kbDeleteTestKey,
    );
  }

  Future<void> _publishProblem() async {
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

  Future<void> publishProblem() async {
    await runBusyFuture(
      _publishProblem(),
      busyObject: kbPublishProblemKey,
    );
  }

  void resetTestForm() {
    testScoreValue = '';
    newTestArchiveFile = none();
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
