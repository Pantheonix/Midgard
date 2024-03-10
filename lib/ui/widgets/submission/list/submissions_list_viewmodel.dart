import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/models/submission/submission_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/submission_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SubmissionsListViewModel extends FutureViewModel<PaginatedSubmissions> {
  SubmissionsListViewModel({
    this.userId,
    this.problemId,
  });

  final String? userId;
  final String? problemId;

  late int _pageValue = 1;

  final _logger = getLogger('SubmissionsListViewModel');
  final _submissionService = locator<SubmissionService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();

  int get pageValue => _pageValue;

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

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
      'Retrieving submissions with userId: $userId and problemId: $problemId',
    );

    final result = await _submissionService.getAll(
      userId: userId,
      problemId: problemId,
      sortBy: SortSubmissionsBy.createdAtDesc.value,
      page: _pageValue,
      pageSize: kiSubmissionsViewPageSize,
    );

    return result.fold(
      (error) {
        _logger.e('Error retrieving submissions: $error');
        throw Exception(
          'Error retrieving submissions: $error',
        );
      },
      (submissions) {
        _logger.i('Submissions retrieved successfully: ${submissions.count}');
        return submissions;
      },
    );
  }
}
