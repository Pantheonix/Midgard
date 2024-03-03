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

  Map<String, dynamic> toJson() => {
        'id': id,
        'problem_id': problemId,
        'problem_name': problemName,
        'score': score,
      };
}
