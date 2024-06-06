import 'package:midgard/models/core/file_data.dart';
import 'package:midgard/models/problem/problem_models.dart';

class CreateProblemRequest {
  CreateProblemRequest({
    required this.name,
    required this.brief,
    required this.description,
    required this.sourceName,
    required this.authorName,
    required this.timeLimit,
    required this.totalMemoryLimit,
    required this.stackMemoryLimit,
    required this.ioType,
    required this.difficulty,
  });

  final String name;
  final String brief;
  final String description;
  final String sourceName;
  final String authorName;
  final double timeLimit;
  final double totalMemoryLimit;
  final double stackMemoryLimit;
  final IoType ioType;
  final Difficulty difficulty;

  Map<String, dynamic> toJson() => {
        'name': name,
        'brief': brief,
        'description': description,
        'sourceName': sourceName,
        'authorName': authorName,
        'time': timeLimit,
        'totalMemory': totalMemoryLimit,
        'stackMemory': stackMemoryLimit,
        'ioType': ioType.index,
        'difficulty': difficulty.index,
      };
}

class AddTestRequest {
  AddTestRequest({
    required this.score,
    required this.archiveFile,
  });

  final int score;
  final FileData archiveFile;
}
