import 'package:dartz/dartz.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/app/app.router.dart';
import 'package:midgard/models/exceptions/eval_exception.dart';
import 'package:midgard/models/submission/submission_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/submission_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:midgard/ui/views/submissions/submissions_view.form.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SubmissionsViewModel extends FutureViewModel<PaginatedSubmissions>
    with FormStateHelper {
  late SortSubmissionsBy? _sortBy = SortSubmissionsBy.createdAtDesc;
  late Option<Language> _language = none();
  late Option<SubmissionStatus> _status = none();
  late DateTime? _startDate = kMinDate;
  late DateTime? _endDate = kMaxDate;
  late int _pageValue = 1;

  final _logger = getLogger('SubmissionsViewModel');
  final _submissionService = locator<SubmissionService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();

  final _sidebarController = SidebarXController(
    selectedIndex: kiSidebarSubmissionsMenuIndex,
    extended: true,
  );

  int get pageValue => _pageValue;

  SortSubmissionsBy? get sortByValue => _sortBy;

  Option<Language> get languageValue => _language;

  Option<SubmissionStatus> get statusValue => _status;

  DateTime? get startDate => _startDate;

  DateTime? get endDate => _endDate;

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  SidebarXController get sidebarController => _sidebarController;

  set startDate(DateTime? date) {
    _startDate = date;
    rebuildUi();
  }

  set endDate(DateTime? date) {
    _endDate = date;
    rebuildUi();
  }

  set sortByValue(SortSubmissionsBy? sortBy) {
    _sortBy = sortBy;
    rebuildUi();
  }

  set languageValue(Option<Language> language) {
    _language = language;
    rebuildUi();
  }

  set statusValue(Option<SubmissionStatus> status) {
    _status = status;
    rebuildUi();
  }

  set pageValue(int page) {
    _pageValue = page;
    rebuildUi();
  }

  @override
  Future<PaginatedSubmissions> futureToRun() => _getSubmissions();

  Future<void> refresh() async {
    await initialise();
  }

  Future<PaginatedSubmissions> _getSubmissions() async {
    _logger.i(
      'Retrieving submissions',
    );

    final result = await _submissionService.getAll(
      sortBy: _sortBy?.value ?? '',
      language: _language.fold(() => null, (a) => a.value),
      status: _status.fold(() => null, (a) => a.value),
      ltScore: switch (ltScoreValue) {
        final data? => data.isEmpty ? null : int.parse(data),
        null => null,
      },
      gtScore: switch (gtScoreValue) {
        final data? => data.isEmpty ? null : int.parse(data),
        null => null,
      },
      ltExecutionTime: switch (ltExecutionTimeValue) {
        final data? => data.isEmpty ? null : double.parse(data),
        null => null,
      },
      gtExecutionTime: switch (gtExecutionTimeValue) {
        final data? => data.isEmpty ? null : double.parse(data),
        null => null,
      },
      startDate: _startDate,
      endDate: _endDate,
      page: _pageValue,
      pageSize: kiSubmissionsViewPageSize,
    );

    return result.fold(
      (EvalException error) {
        _logger.e('Error retrieving submissions: ${error.message}');
        throw Exception(
          'Error retrieving submissions: ${error.message}',
        );
      },
      (submissions) {
        _logger.i('Submissions retrieved successfully: ${submissions.count}');
        return submissions;
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
