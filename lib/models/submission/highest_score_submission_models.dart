import 'package:flutter/material.dart';
import 'package:midgard/ui/common/app_colors.dart';

class HighestScoreSubmissionModel {
  HighestScoreSubmissionModel({
    required this.id,
    required this.problemId,
    required this.problemName,
    required this.score,
  });

  HighestScoreSubmissionModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        problemId = json['problem_id'] as String,
        problemName = json['problem_name'] as String,
        score = json['score'] as int;

  final String id;
  final String problemId;
  final String problemName;
  final int score;

  Color get scoreColor => switch (score) {
        final score when 0 <= score && score <= 30 =>
          kcSubmissionScoreAcceptedLow,
        final score when 31 <= score && score <= 60 =>
          kcSubmissionScoreAcceptedMedium,
        final score when 61 <= score && score <= 90 =>
          kcSubmissionScoreAcceptedHigh,
        _ => kcSubmissionScoreAccepted,
      };

  String get thumbnailPretty => '$problemName - $score pts';

  Map<String, dynamic> toJson() => {
        'id': id,
        'problem_id': problemId,
        'problem_name': problemName,
        'score': score,
      };
}
