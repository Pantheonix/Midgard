import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:midgard/ui/common/app_colors.dart';

part 'problem_models.g.dart';

@HiveType(typeId: 2)
class ProblemModel {
  ProblemModel({
    required this.id,
    required this.name,
    required this.brief,
    required this.description,
    required this.isPublished,
    required this.sourceName,
    required this.authorName,
    required this.timeLimit,
    required this.totalMemoryLimit,
    required this.stackMemoryLimit,
    required this.proposerId,
    required this.createdAt,
    required this.publishedAt,
    required this.ioType,
    required this.difficulty,
    required this.tests,
  });

  ProblemModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        brief = json['brief'] as String,
        description = json['description'] as String,
        isPublished = json['isPublished'] as bool,
        sourceName = json['sourceName'] as String,
        authorName = json['authorName'] as String,
        timeLimit = json['time'] as double,
        totalMemoryLimit = json['totalMemory'] as double,
        stackMemoryLimit = json['stackMemory'] as double,
        proposerId = json['proposerId'] as String,
        createdAt = DateTime.parse(json['creationDate'] as String),
        publishedAt = DateTime.parse(json['publishingDate'] as String),
        ioType = IoType.fromValue(json['ioType'] as int),
        difficulty = Difficulty.fromValue(json['difficulty'] as int),
        tests = json['tests'] != null
            ? some(
                (json['tests'] as List<dynamic>)
                    .map(
                      (testJson) =>
                          TestModel.fromJson(testJson as Map<String, dynamic>),
                    )
                    .toList(),
              )
            : none();

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String brief;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final bool isPublished;

  @HiveField(5)
  final String sourceName;

  @HiveField(6)
  final String authorName;

  @HiveField(7)
  final double timeLimit;

  @HiveField(8)
  final double totalMemoryLimit;

  @HiveField(9)
  final double stackMemoryLimit;

  @HiveField(10)
  final String proposerId;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime publishedAt;

  @HiveField(13)
  final IoType ioType;

  @HiveField(14)
  final Difficulty difficulty;

  @HiveField(15)
  late Option<List<TestModel>> tests;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'brief': brief,
        'description': description,
        'isPublished': isPublished,
        'sourceName': sourceName,
        'authorName': authorName,
        'time': timeLimit,
        'totalMemory': totalMemoryLimit,
        'stackMemory': stackMemoryLimit,
        'proposerId': proposerId,
        'creationDate': createdAt.toIso8601String(),
        'publishingDate': publishedAt.toIso8601String(),
        'ioType': ioType.index,
        'difficulty': difficulty.index,
        'tests': tests.getOrElse(() => []).map((t) => t.toJson()).toList(),
      };

  bool get isPublic => isPublished;

  String get toStringPretty => 'Problem: ${toJson()}';

  String get authorNamePretty => 'Author: $authorName';

  String get sourceNamePretty => 'Source: $sourceName';

  String get timeLimitPretty => 'Time: ${timeLimit.toStringAsFixed(1)}s';

  String get timeLimitPrettyWithoutLabel => '${timeLimit.toStringAsFixed(1)}s';

  String get totalMemoryLimitPretty =>
      '${totalMemoryLimit.toStringAsFixed(1)}MB';

  String get stackMemoryLimitPretty =>
      '${stackMemoryLimit.toStringAsFixed(1)}MB';

  String get memoryLimitPretty =>
      'Memory: $totalMemoryLimitPretty / $stackMemoryLimitPretty';

  String get createdAtPretty => 'Creation date: ${createdAt.toLocal()}';

  String get createdAtPrettyWithoutLabel => '${createdAt.toLocal()}';

  void addTest(TestModel test) {
    tests = some([...(tests.getOrElse(() => [])..add(test))]);
  }

  void removeTest(TestModel test) {
    tests = some(
      tests.getOrElse(() => []).where((t) => t.id != test.id).toList(),
    );
  }
}

@HiveType(typeId: 3)
enum IoType {
  @HiveField(0)
  standard,
  @HiveField(1)
  file;

  String get value => switch (this) {
        IoType.standard => 'Standard',
        IoType.file => 'File',
      };

  Color get color => switch (this) {
        IoType.standard => kcStandardIoBadgeColor,
        IoType.file => kcFileIoBadgeColor,
      };

  static IoType fromValue(int value) => switch (value) {
        0 => IoType.standard,
        1 => IoType.file,
        _ => IoType.standard,
      };

  static int toValue(IoType ioType) => ioType.index;
}

@HiveType(typeId: 4)
enum Difficulty {
  @HiveField(0)
  easy,
  @HiveField(1)
  medium,
  @HiveField(2)
  hard,
  @HiveField(3)
  olympiad,
  @HiveField(4)
  all;

  String get value => switch (this) {
        Difficulty.easy => 'Easy',
        Difficulty.medium => 'Medium',
        Difficulty.hard => 'Hard',
        Difficulty.olympiad => 'Olympiad',
        Difficulty.all => 'All',
      };

  Color get color => switch (this) {
        Difficulty.easy => kcEasyBadgeColor,
        Difficulty.medium => kcMediumBadgeColor,
        Difficulty.hard => kcHardBadgeColor,
        Difficulty.olympiad => kcOlympiadBadgeColor,
        _ => kcEasyBadgeColor,
      };

  static Difficulty fromValue(int value) => switch (value) {
        0 => Difficulty.easy,
        1 => Difficulty.medium,
        2 => Difficulty.hard,
        3 => Difficulty.olympiad,
        _ => Difficulty.easy,
      };

  static int toValue(Difficulty difficulty) => difficulty.index;
}

@HiveType(typeId: 5)
class TestModel {
  TestModel({
    required this.id,
    required this.score,
    required this.inputUrl,
    required this.outputUrl,
  });

  TestModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        score = json['score'] as int,
        inputUrl = json['inputDownloadUrl'] as String,
        outputUrl = json['outputDownloadUrl'] as String;

  @HiveField(0)
  final int id;

  @HiveField(1)
  final int score;

  @HiveField(2)
  final String inputUrl;

  @HiveField(3)
  final String outputUrl;

  Map<String, dynamic> toJson() => {
        'id': id,
        'score': score,
        'inputDownloadUrl': inputUrl,
        'outputDownloadUrl': outputUrl,
      };

  String get idPretty => '$id';

  String get scorePretty => '$score';

  String get toStringPretty => 'Test: ${toJson()}';
}
