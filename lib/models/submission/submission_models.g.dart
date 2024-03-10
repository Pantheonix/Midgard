// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubmissionModelAdapter extends TypeAdapter<SubmissionModel> {
  @override
  final int typeId = 6;

  @override
  SubmissionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubmissionModel(
      id: fields[0] as String,
      problemId: fields[1] as String,
      problemName: fields[11] as String,
      userId: fields[2] as String,
      language: fields[3] as Language,
      sourceCode: fields[4] as Option<String>,
      status: fields[5] as SubmissionStatus,
      score: fields[6] as int,
      createdAt: fields[7] as DateTime,
      executionTime: fields[8] as double,
      memoryUsage: fields[9] as double,
      testCases: fields[10] as Option<List<TestCaseModel>>,
    );
  }

  @override
  void write(BinaryWriter writer, SubmissionModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.problemId)
      ..writeByte(11)
      ..write(obj.problemName)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.language)
      ..writeByte(4)
      ..write(obj.sourceCode)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.score)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.executionTime)
      ..writeByte(9)
      ..write(obj.memoryUsage)
      ..writeByte(10)
      ..write(obj.testCases);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubmissionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TestCaseModelAdapter extends TypeAdapter<TestCaseModel> {
  @override
  final int typeId = 9;

  @override
  TestCaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TestCaseModel(
      id: fields[0] as int,
      status: fields[1] as TestCaseStatus,
      executionTime: fields[2] as double,
      memoryUsage: fields[3] as double,
      expectedScore: fields[4] as int,
      evaluationMessage: fields[5] as Option<String>,
      compilationOutput: fields[6] as Option<String>,
      stdout: fields[7] as Option<String>,
      stderr: fields[8] as Option<String>,
    );
  }

  @override
  void write(BinaryWriter writer, TestCaseModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.executionTime)
      ..writeByte(3)
      ..write(obj.memoryUsage)
      ..writeByte(4)
      ..write(obj.expectedScore)
      ..writeByte(5)
      ..write(obj.evaluationMessage)
      ..writeByte(6)
      ..write(obj.compilationOutput)
      ..writeByte(7)
      ..write(obj.stdout)
      ..writeByte(8)
      ..write(obj.stderr);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestCaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LanguageAdapter extends TypeAdapter<Language> {
  @override
  final int typeId = 7;

  @override
  Language read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Language.c;
      case 1:
        return Language.cpp;
      case 2:
        return Language.java;
      case 3:
        return Language.lua;
      case 4:
        return Language.python;
      case 5:
        return Language.rust;
      case 6:
        return Language.go;
      case 7:
        return Language.csharp;
      case 8:
        return Language.ocaml;
      case 9:
        return Language.javascript;
      case 10:
        return Language.kotlin;
      case 11:
        return Language.haskell;
      case 12:
        return Language.unknown;
      default:
        return Language.c;
    }
  }

  @override
  void write(BinaryWriter writer, Language obj) {
    switch (obj) {
      case Language.c:
        writer.writeByte(0);
        break;
      case Language.cpp:
        writer.writeByte(1);
        break;
      case Language.java:
        writer.writeByte(2);
        break;
      case Language.lua:
        writer.writeByte(3);
        break;
      case Language.python:
        writer.writeByte(4);
        break;
      case Language.rust:
        writer.writeByte(5);
        break;
      case Language.go:
        writer.writeByte(6);
        break;
      case Language.csharp:
        writer.writeByte(7);
        break;
      case Language.ocaml:
        writer.writeByte(8);
        break;
      case Language.javascript:
        writer.writeByte(9);
        break;
      case Language.kotlin:
        writer.writeByte(10);
        break;
      case Language.haskell:
        writer.writeByte(11);
        break;
      case Language.unknown:
        writer.writeByte(12);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubmissionStatusAdapter extends TypeAdapter<SubmissionStatus> {
  @override
  final int typeId = 8;

  @override
  SubmissionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SubmissionStatus.evaluating;
      case 1:
        return SubmissionStatus.accepted;
      case 2:
        return SubmissionStatus.rejected;
      case 3:
        return SubmissionStatus.internalError;
      case 4:
        return SubmissionStatus.unknown;
      default:
        return SubmissionStatus.evaluating;
    }
  }

  @override
  void write(BinaryWriter writer, SubmissionStatus obj) {
    switch (obj) {
      case SubmissionStatus.evaluating:
        writer.writeByte(0);
        break;
      case SubmissionStatus.accepted:
        writer.writeByte(1);
        break;
      case SubmissionStatus.rejected:
        writer.writeByte(2);
        break;
      case SubmissionStatus.internalError:
        writer.writeByte(3);
        break;
      case SubmissionStatus.unknown:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubmissionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TestCaseStatusAdapter extends TypeAdapter<TestCaseStatus> {
  @override
  final int typeId = 10;

  @override
  TestCaseStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TestCaseStatus.pending;
      case 1:
        return TestCaseStatus.running;
      case 2:
        return TestCaseStatus.accepted;
      case 3:
        return TestCaseStatus.wrongAnswer;
      case 4:
        return TestCaseStatus.sigsegv;
      case 5:
        return TestCaseStatus.sigxfsz;
      case 6:
        return TestCaseStatus.sigfpe;
      case 7:
        return TestCaseStatus.sigabrt;
      case 8:
        return TestCaseStatus.nzec;
      case 9:
        return TestCaseStatus.internalError;
      case 10:
        return TestCaseStatus.execFormatError;
      case 11:
        return TestCaseStatus.runtimeError;
      case 12:
        return TestCaseStatus.compilationError;
      case 13:
        return TestCaseStatus.timeLimitExceeded;
      case 14:
        return TestCaseStatus.unknown;
      default:
        return TestCaseStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, TestCaseStatus obj) {
    switch (obj) {
      case TestCaseStatus.pending:
        writer.writeByte(0);
        break;
      case TestCaseStatus.running:
        writer.writeByte(1);
        break;
      case TestCaseStatus.accepted:
        writer.writeByte(2);
        break;
      case TestCaseStatus.wrongAnswer:
        writer.writeByte(3);
        break;
      case TestCaseStatus.sigsegv:
        writer.writeByte(4);
        break;
      case TestCaseStatus.sigxfsz:
        writer.writeByte(5);
        break;
      case TestCaseStatus.sigfpe:
        writer.writeByte(6);
        break;
      case TestCaseStatus.sigabrt:
        writer.writeByte(7);
        break;
      case TestCaseStatus.nzec:
        writer.writeByte(8);
        break;
      case TestCaseStatus.internalError:
        writer.writeByte(9);
        break;
      case TestCaseStatus.execFormatError:
        writer.writeByte(10);
        break;
      case TestCaseStatus.runtimeError:
        writer.writeByte(11);
        break;
      case TestCaseStatus.compilationError:
        writer.writeByte(12);
        break;
      case TestCaseStatus.timeLimitExceeded:
        writer.writeByte(13);
        break;
      case TestCaseStatus.unknown:
        writer.writeByte(14);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestCaseStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
