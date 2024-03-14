import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/cs.dart';
import 'package:highlight/languages/go.dart';
import 'package:highlight/languages/haskell.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/kotlin.dart';
import 'package:highlight/languages/lua.dart';
import 'package:highlight/languages/ocaml.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/rust.dart';
import 'package:hive/hive.dart';
import 'package:midgard/ui/common/app_colors.dart';
import 'package:midgard/ui/common/app_strings.dart';

part 'submission_models.g.dart';

@HiveType(typeId: 6)
class SubmissionModel {
  SubmissionModel({
    required this.id,
    required this.problemId,
    required this.problemName,
    required this.isPublished,
    required this.userId,
    required this.language,
    required this.sourceCode,
    required this.status,
    required this.score,
    required this.createdAt,
    required this.executionTime,
    required this.memoryUsage,
    required this.testCases,
  });

  SubmissionModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        problemId = json['problem_id'] as String,
        problemName = json['problem_name'] as String,
        isPublished = json['is_published'] as bool,
        userId = json['user_id'] as String,
        language = Language.fromString(json['language'] as String),
        sourceCode = switch (json['source_code']) {
          final data? => some(data as String),
          null => none(),
        },
        status = SubmissionStatus.fromString(json['status'] as String),
        score = json['score'] as int,
        createdAt = DateTime.fromMillisecondsSinceEpoch(
          (json['created_at'] as int) * 1000,
        ),
        executionTime = json['avg_time'] as double,
        memoryUsage = (json['avg_memory'] as double) / 1000.0,
        testCases = switch (json['test_cases']) {
          final data? => some(
              (data as List<dynamic>)
                  .map(
                    (testCaseJson) => TestCaseModel.fromJson(
                      testCaseJson as Map<String, dynamic>,
                    ),
                  )
                  .toList(),
            ),
          null => none(),
        };

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String problemId;

  @HiveField(11)
  final String problemName;

  @HiveField(12)
  final bool isPublished;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final Language language;

  @HiveField(4)
  final Option<String> sourceCode;

  @HiveField(5)
  final SubmissionStatus status;

  @HiveField(6)
  final int score;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final double executionTime;

  @HiveField(9)
  final double memoryUsage;

  @HiveField(10)
  final Option<List<TestCaseModel>> testCases;

  Map<String, dynamic> toJson() => {
        'id': id,
        'problem_id': problemId,
        'problem_name': problemName,
        'user_id': userId,
        'language': language.value,
        'source_code': sourceCode.getOrElse(() => ''),
        'status': status.value,
        'score': score,
        'created_at': createdAt.toIso8601String(),
        'avg_time': executionTime,
        'avg_memory': memoryUsage,
        'test_cases': testCases
            .getOrElse(() => [])
            .map((testCase) => testCase.toJson())
            .toList(),
      };

  String get languagePretty => language.displayName;

  String get statusPretty => status.value;

  String get scorePretty => score.toString();

  String get executionTimePretty => '${executionTime.toStringAsFixed(2)}s';

  String get memoryUsagePretty => '${memoryUsage.toStringAsFixed(2)}MB';

  String get createdAtPretty => createdAt.toLocal().toString();

  Color get statusColor => switch (status) {
        SubmissionStatus.accepted => switch (score) {
            final score when 0 <= score && score <= 30 =>
              kcSubmissionScoreAcceptedLow,
            final score when 31 <= score && score <= 60 =>
              kcSubmissionScoreAcceptedMedium,
            final score when 61 <= score && score <= 90 =>
              kcSubmissionScoreAcceptedHigh,
            _ => kcSubmissionScoreAccepted,
          },
        SubmissionStatus.rejected => kcSubmissionScoreRejected,
        _ => kcSubmissionScoreEvaluating,
      };

  bool get isEvaluating => status == SubmissionStatus.evaluating;
}

typedef SourceCodeTheme = ({String name, Map<String, TextStyle> theme});
typedef LanguageTheme = ({Language language, Mode highlight});

final List<LanguageTheme> languageThemes = [
  (language: Language.rust, highlight: rust),
  (language: Language.c, highlight: cpp),
  (language: Language.cpp, highlight: cpp),
  (language: Language.java, highlight: java),
  (language: Language.csharp, highlight: cs),
  (language: Language.python, highlight: python),
  (language: Language.javascript, highlight: javascript),
  (language: Language.kotlin, highlight: kotlin),
  (language: Language.go, highlight: go),
  (language: Language.lua, highlight: lua),
  (language: Language.haskell, highlight: haskell),
  (language: Language.ocaml, highlight: ocaml),
];

@HiveType(typeId: 7)
enum Language {
  @HiveField(0)
  c,
  @HiveField(1)
  cpp,
  @HiveField(2)
  java,
  @HiveField(3)
  lua,
  @HiveField(4)
  python,
  @HiveField(5)
  rust,
  @HiveField(6)
  go,
  @HiveField(7)
  csharp,
  @HiveField(8)
  ocaml,
  @HiveField(9)
  javascript,
  @HiveField(10)
  kotlin,
  @HiveField(11)
  haskell,
  @HiveField(12)
  unknown;

  String get value => switch (this) {
        Language.c => 'C',
        Language.cpp => 'C++',
        Language.java => 'Java',
        Language.lua => 'Lua',
        Language.python => 'Python',
        Language.rust => 'Rust',
        Language.go => 'Go',
        Language.csharp => 'C#',
        Language.ocaml => 'OCaml',
        Language.javascript => 'JavaScript',
        Language.kotlin => 'Kotlin',
        Language.haskell => 'Haskell',
        _ => 'Unknown',
      };

  static Language fromString(String value) => switch (value) {
        'C' => Language.c,
        'C++' => Language.cpp,
        'Java' => Language.java,
        'Lua' => Language.lua,
        'Python' => Language.python,
        'Rust' => Language.rust,
        'Go' => Language.go,
        'C#' => Language.csharp,
        'OCaml' => Language.ocaml,
        'JavaScript' => Language.javascript,
        'Kotlin' => Language.kotlin,
        'Haskell' => Language.haskell,
        _ => Language.unknown,
      };

  String get displayName => switch (this) {
        Language.c => 'C (GCC 8.3.0)',
        Language.cpp => 'C++ (GCC 9.2.0)',
        Language.java => 'Java (OpenJDK 13.0.1)',
        Language.lua => 'Lua (5.3.5)',
        Language.python => 'Python (3.8.1)',
        Language.rust => 'Rust (1.40.0)',
        Language.go => 'Go (1.13.5)',
        Language.csharp => 'C# (Mono 6.6.0.161)',
        Language.ocaml => 'OCaml (4.09.0)',
        Language.javascript => 'JavaScript (Node.js 12.14.0)',
        Language.kotlin => 'Kotlin (1.3.70)',
        Language.haskell => 'Haskell (GHC 8.8.1)',
        _ => 'Unknown',
      };

  String get placeholder => switch (this) {
        Language.c => ksAppCPlaceholder,
        Language.cpp => ksAppCppPlaceholder,
        Language.java => ksAppJavaPlaceholder,
        Language.lua => ksAppLuaPlaceholder,
        Language.python => ksAppPythonPlaceholder,
        Language.rust => ksAppRustPlaceholder,
        Language.go => ksAppGoPlaceholder,
        Language.javascript => ksAppJavaScriptPlaceholder,
        Language.csharp => ksAppCSharpPlaceholder,
        Language.kotlin => ksAppKotlinPlaceholder,
        Language.haskell => ksAppHaskellPlaceholder,
        Language.ocaml => ksAppOCamlPlaceholder,
        _ => ksAppCPlaceholder,
      };

  Mode get theme => switch (this) {
        Language.rust => languageThemes[0].highlight,
        Language.c => languageThemes[1].highlight,
        Language.cpp => languageThemes[2].highlight,
        Language.java => languageThemes[3].highlight,
        Language.csharp => languageThemes[4].highlight,
        Language.python => languageThemes[5].highlight,
        Language.javascript => languageThemes[6].highlight,
        Language.kotlin => languageThemes[7].highlight,
        Language.go => languageThemes[8].highlight,
        Language.lua => languageThemes[9].highlight,
        Language.haskell => languageThemes[10].highlight,
        Language.ocaml => languageThemes[11].highlight,
        _ => languageThemes[0].highlight,
      };
}

@HiveType(typeId: 8)
enum SubmissionStatus {
  @HiveField(0)
  evaluating,
  @HiveField(1)
  accepted,
  @HiveField(2)
  rejected,
  @HiveField(3)
  internalError,
  @HiveField(4)
  unknown;

  String get value => switch (this) {
        SubmissionStatus.evaluating => 'Evaluating',
        SubmissionStatus.accepted => 'Accepted',
        SubmissionStatus.rejected => 'Rejected',
        SubmissionStatus.internalError => 'Internal Error',
        _ => 'Unknown',
      };

  static SubmissionStatus fromString(String value) => switch (value) {
        'Evaluating' => SubmissionStatus.evaluating,
        'Accepted' => SubmissionStatus.accepted,
        'Rejected' => SubmissionStatus.rejected,
        'Internal Error' => SubmissionStatus.internalError,
        _ => SubmissionStatus.unknown,
      };
}

@HiveType(typeId: 9)
class TestCaseModel {
  TestCaseModel({
    required this.id,
    required this.status,
    required this.executionTime,
    required this.memoryUsage,
    required this.expectedScore,
    required this.evaluationMessage,
    required this.compilationOutput,
    required this.stdout,
    required this.stderr,
  });

  TestCaseModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        status = TestCaseStatus.fromString(json['status'] as String),
        executionTime = json['time'] as double,
        memoryUsage = (json['memory'] as double) / 1000.0,
        expectedScore = json['expected_score'] as int,
        evaluationMessage = switch (json['eval_message']) {
          final data? => some(data as String),
          null => none(),
        },
        compilationOutput = switch (json['compile_output']) {
          final data? => some(data as String),
          null => none(),
        },
        stdout = switch (json['stdout']) {
          final data? => some(data as String),
          null => none(),
        },
        stderr = switch (json['stderr']) {
          final data? => some(data as String),
          null => none(),
        };

  @HiveField(0)
  final int id;

  @HiveField(1)
  final TestCaseStatus status;

  @HiveField(2)
  final double executionTime;

  @HiveField(3)
  final double memoryUsage;

  @HiveField(4)
  final int expectedScore;

  @HiveField(5)
  final Option<String> evaluationMessage;

  @HiveField(6)
  final Option<String> compilationOutput;

  @HiveField(7)
  final Option<String> stdout;

  @HiveField(8)
  final Option<String> stderr;

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status.value,
        'time': executionTime,
        'memory': memoryUsage,
        'expected_score': expectedScore,
        'eval_message': evaluationMessage.getOrElse(() => ''),
        'compile_output': compilationOutput.getOrElse(() => ''),
        'stdout': stdout.getOrElse(() => ''),
        'stderr': stderr.getOrElse(() => ''),
      };

  String get idPretty => id.toString();

  String get statusPretty => status.value;

  String get executionTimePretty => '${executionTime.toStringAsFixed(2)}s';

  String get memoryUsagePretty => '${memoryUsage.toStringAsFixed(2)}MB';

  Color get statusColor => switch (status) {
        TestCaseStatus.accepted => kcSubmissionScoreAccepted,
        TestCaseStatus.wrongAnswer => kcSubmissionScoreRejected,
        TestCaseStatus.sigsegv => kcSubmissionScoreRejected,
        TestCaseStatus.sigxfsz => kcSubmissionScoreRejected,
        TestCaseStatus.sigfpe => kcSubmissionScoreRejected,
        TestCaseStatus.sigabrt => kcSubmissionScoreRejected,
        TestCaseStatus.nzec => kcSubmissionScoreRejected,
        TestCaseStatus.internalError => kcSubmissionScoreRejected,
        TestCaseStatus.execFormatError => kcSubmissionScoreRejected,
        TestCaseStatus.runtimeError => kcSubmissionScoreRejected,
        TestCaseStatus.compilationError => kcSubmissionScoreRejected,
        TestCaseStatus.timeLimitExceeded => kcSubmissionScoreRejected,
        _ => kcSubmissionScoreEvaluating,
      };

  bool get isEvaluating =>
      status == TestCaseStatus.pending || status == TestCaseStatus.running;
}

@HiveType(typeId: 10)
enum TestCaseStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  running,
  @HiveField(2)
  accepted,
  @HiveField(3)
  wrongAnswer,
  @HiveField(4)
  sigsegv,
  @HiveField(5)
  sigxfsz,
  @HiveField(6)
  sigfpe,
  @HiveField(7)
  sigabrt,
  @HiveField(8)
  nzec,
  @HiveField(9)
  internalError,
  @HiveField(10)
  execFormatError,
  @HiveField(11)
  runtimeError,
  @HiveField(12)
  compilationError,
  @HiveField(13)
  timeLimitExceeded,
  @HiveField(14)
  unknown;

  String get value => switch (this) {
        TestCaseStatus.pending => 'Pending',
        TestCaseStatus.running => 'Running',
        TestCaseStatus.accepted => 'Accepted',
        TestCaseStatus.wrongAnswer => 'Wrong Answer',
        TestCaseStatus.sigsegv => 'SIGSEGV',
        TestCaseStatus.sigxfsz => 'SIGXFSZ',
        TestCaseStatus.sigfpe => 'SIGFPE',
        TestCaseStatus.sigabrt => 'SIGABRT',
        TestCaseStatus.nzec => 'NZEC',
        TestCaseStatus.internalError => 'Internal Error',
        TestCaseStatus.execFormatError => 'Exec Format Error',
        TestCaseStatus.runtimeError => 'Runtime Error',
        TestCaseStatus.compilationError => 'Compilation Error',
        TestCaseStatus.timeLimitExceeded => 'Time Limit Exceeded',
        _ => 'Unknown',
      };

  static TestCaseStatus fromString(String value) => switch (value) {
        'Pending' => TestCaseStatus.pending,
        'Running' => TestCaseStatus.running,
        'Accepted' => TestCaseStatus.accepted,
        'Wrong Answer' => TestCaseStatus.wrongAnswer,
        'SIGSEGV' => TestCaseStatus.sigsegv,
        'SIGXFSZ' => TestCaseStatus.sigxfsz,
        'SIGFPE' => TestCaseStatus.sigfpe,
        'SIGABRT' => TestCaseStatus.sigabrt,
        'NZEC' => TestCaseStatus.nzec,
        'Internal Error' => TestCaseStatus.internalError,
        'Exec Format Error' => TestCaseStatus.execFormatError,
        'Runtime Error' => TestCaseStatus.runtimeError,
        'Compilation Error' => TestCaseStatus.compilationError,
        'Time Limit Exceeded' => TestCaseStatus.timeLimitExceeded,
        _ => TestCaseStatus.unknown,
      };
}

enum SortSubmissionsBy {
  scoreAsc,
  scoreDesc,
  createdAtAsc,
  createdAtDesc,
  executionTimeAsc,
  executionTimeDesc,
  memoryUsageAsc,
  memoryUsageDesc;

  String get value => switch (this) {
        SortSubmissionsBy.scoreAsc => 'score_asc',
        SortSubmissionsBy.scoreDesc => 'score_desc',
        SortSubmissionsBy.createdAtAsc => 'created_at_asc',
        SortSubmissionsBy.createdAtDesc => 'created_at_desc',
        SortSubmissionsBy.executionTimeAsc => 'avg_time_asc',
        SortSubmissionsBy.executionTimeDesc => 'avg_time_desc',
        SortSubmissionsBy.memoryUsageAsc => 'avg_memory_asc',
        SortSubmissionsBy.memoryUsageDesc => 'avg_memory_desc',
      };
}
