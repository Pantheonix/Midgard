import 'package:midgard/models/submission/submission_models.dart';

class CreateSubmissionRequest {
  CreateSubmissionRequest({
    required this.problemId,
    required this.language,
    required this.sourceCode,
  });

  final String problemId;
  final Language language;
  final String sourceCode;

  Map<String, dynamic> toJson() => {
        'problem_id': problemId,
        'language': language.value,
        'source_code': sourceCode,
      };
}
