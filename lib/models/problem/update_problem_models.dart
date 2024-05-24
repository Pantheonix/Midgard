import 'package:dartz/dartz.dart';
import 'package:midgard/models/core/file_data.dart';
import 'package:midgard/models/problem/problem_models.dart';

class UpdateProblemRequest {
  UpdateProblemRequest({
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

  final Option<String> name;
  final Option<String> brief;
  final Option<String> description;
  final Option<String> sourceName;
  final Option<String> authorName;
  final Option<double> timeLimit;
  final Option<double> totalMemoryLimit;
  final Option<double> stackMemoryLimit;
  final Option<IoType> ioType;
  final Option<Difficulty> difficulty;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    name.fold(
      () {},
      (value) => json['name'] = value,
    );
    brief.fold(
      () {},
      (value) => json['brief'] = value,
    );
    description.fold(
      () {},
      (value) => json['description'] = value,
    );
    sourceName.fold(
      () {},
      (value) => json['sourceName'] = value,
    );
    authorName.fold(
      () {},
      (value) => json['authorName'] = value,
    );
    timeLimit.fold(
      () {},
      (value) => json['time'] = value,
    );
    totalMemoryLimit.fold(
      () {},
      (value) => json['totalMemory'] = value,
    );
    stackMemoryLimit.fold(
      () {},
      (value) => json['stackMemory'] = value,
    );
    ioType.fold(
      () {},
      (value) => json['ioType'] = value.index,
    );
    difficulty.fold(
      () {},
      (value) => json['difficulty'] = value.index,
    );

    return json;
  }
}

class UpdateTestRequest {
  UpdateTestRequest({
    required this.score,
    required this.archiveFile,
  });

  final Option<int> score;
  final Option<FileData> archiveFile;
}
