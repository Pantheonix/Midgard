import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/models/core/file_data.dart';
import 'package:midgard/models/problem/problem_models.dart';
import 'package:midgard/services/problem_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class UpdateTestTileViewModel extends FormViewModel {
  UpdateTestTileViewModel({
    required this.test,
  });

  final TestModel test;

  final _problemService = locator<ProblemService>();
  final _routerService = locator<RouterService>();
  final _logger = getLogger('UpdateTestTileViewModel');

  late Option<FileData> _testArchiveFile = none();

  ProblemService get problemService => _problemService;

  RouterService get routerService => _routerService;

  Option<FileData> get testArchiveFile => _testArchiveFile;

  set testArchiveFile(Option<FileData> file) {
    _testArchiveFile = file;
    notifyListeners();
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

    testArchiveFile = some(
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
}
