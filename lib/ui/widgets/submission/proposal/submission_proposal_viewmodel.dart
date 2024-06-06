import 'package:dartz/dartz.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/darcula.dart';
import 'package:flutter_highlight/themes/dark.dart';
import 'package:flutter_highlight/themes/mono-blue.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:flutter_highlight/themes/obsidian.dart';
import 'package:flutter_highlight/themes/ocean.dart';
import 'package:flutter_highlight/themes/solarized-dark.dart';
import 'package:flutter_highlight/themes/solarized-light.dart';
import 'package:flutter_highlight/themes/xcode.dart';
import 'package:highlight/languages/rust.dart';
import 'package:midgard/app/app.locator.dart';
import 'package:midgard/app/app.logger.dart';
import 'package:midgard/models/exceptions/eval_exception.dart';
import 'package:midgard/models/submission/create_submission_models.dart';
import 'package:midgard/models/submission/submission_models.dart';
import 'package:midgard/services/hive_service.dart';
import 'package:midgard/services/submission_service.dart';
import 'package:midgard/ui/common/app_constants.dart';
import 'package:sentry/sentry.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SubmissionProposalViewModel extends BaseViewModel {
  SubmissionProposalViewModel({
    required this.problemId,
  });

  final String problemId;

  late Option<String> _submissionId = none();

  final _submissionService = locator<SubmissionService>();
  final _hiveService = locator<HiveService>();
  final _routerService = locator<RouterService>();
  final _logger = getLogger('SubmissionProposalViewModel');

  late bool _isLoading = false;

  final List<SourceCodeTheme> sourceCodeThemes = [
    (name: 'Darcula', theme: darculaTheme),
    (name: 'Dark', theme: darkTheme),
    (name: 'Mono Blue', theme: monoBlueTheme),
    (name: 'Monokai Sublime', theme: monokaiSublimeTheme),
    (name: 'Monokai', theme: monokaiTheme),
    (name: 'Ocean', theme: oceanTheme),
    (name: 'Solarized Dark', theme: solarizedDarkTheme),
    (name: 'Solarized Light', theme: solarizedLightTheme),
    (name: 'Obsidian', theme: obsidianTheme),
    (name: 'XCode', theme: xcodeTheme),
  ];

  late LanguageTheme _selectedLanguageTheme =
      (language: Language.rust, highlight: rust);
  late SourceCodeTheme _selectedSourceCodeTheme =
      (name: 'Darcula', theme: darculaTheme);

  final _sourceCodeController = CodeController(
    text: Language.rust.placeholder,
    language: rust,
  );

  Option<String> get submissionId => _submissionId;

  HiveService get hiveService => _hiveService;

  RouterService get routerService => _routerService;

  bool get isLoading => _isLoading;

  LanguageTheme get selectedLanguageTheme => _selectedLanguageTheme;

  SourceCodeTheme get selectedSourceCodeTheme => _selectedSourceCodeTheme;

  CodeController get sourceCodeController => _sourceCodeController;

  set submissionId(Option<String> value) {
    _submissionId = value;
    rebuildUi();
  }

  set isLoading(bool value) {
    _isLoading = value;
    rebuildUi();
  }

  set selectedLanguageTheme(LanguageTheme languageTheme) {
    _sourceCodeController
      ..language = languageTheme.highlight
      ..clear()
      ..text = languageTheme.language.placeholder;
    _selectedLanguageTheme = languageTheme;
    rebuildUi();
  }

  set selectedSourceCodeTheme(SourceCodeTheme sourceCodeTheme) {
    _selectedSourceCodeTheme = sourceCodeTheme;
    rebuildUi();
  }

  void clearCurrentSubmission() {
    submissionId = none();
  }

  Future<void> _submitSolution() async {
    await runBusyFuture(
      _validate(),
      busyObject: kbSendSubmissionKey,
    );

    _logger
      ..i('Submitting solution for problem: $problemId')
      ..d('Source code: ${_sourceCodeController.text}');

    final createSubmissionRequest = CreateSubmissionRequest(
      problemId: problemId,
      language: _selectedLanguageTheme.language,
      sourceCode: _sourceCodeController.text,
    );

    final result = await _submissionService.create(
      request: createSubmissionRequest,
    );

    await result.fold(
      (EvalException error) async {
        _logger.e('Error while submitting solution: ${error.toJson()}');
        await Sentry.captureException(
          Exception(
            'Error while submitting solution: ${error.toJson()}',
          ),
          stackTrace: StackTrace.current,
        );

        throw Exception(
          'Error while submitting solution: ${error.message}',
        );
      },
      (({String submissionId}) result) async {
        _logger
          ..i('Solution submitted successfully')
          ..d('Submission ID: ${result.submissionId}');

        submissionId = some(result.submissionId);
      },
    );
  }

  Future<void> submitSolution() async {
    isLoading = true;
    await runBusyFuture(
      _submitSolution(),
      busyObject: kbSendSubmissionKey,
    );
    isLoading = false;
  }

  Future<void> _validate() async {
    if (_sourceCodeController.text.length > kMaxSubmissionSourceCodeSize) {
      throw Exception(
        'Source code size exceeds maximum allowed size of $kMaxSubmissionSourceCodeSize',
      );
    }
  }
}
