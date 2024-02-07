// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProblemModelAdapter extends TypeAdapter<ProblemModel> {
  @override
  final int typeId = 2;

  @override
  ProblemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProblemModel(
      id: fields[0] as String,
      name: fields[1] as String,
      brief: fields[2] as String,
      description: fields[3] as String,
      isPublished: fields[4] as bool,
      sourceName: fields[5] as String,
      authorName: fields[6] as String,
      timeLimit: fields[7] as double,
      totalMemoryLimit: fields[8] as double,
      stackMemoryLimit: fields[9] as double,
      proposerId: fields[10] as String,
      createdAt: fields[11] as DateTime,
      publishedAt: fields[12] as DateTime,
      ioType: fields[13] as IoType,
      difficulty: fields[14] as Difficulty,
    );
  }

  @override
  void write(BinaryWriter writer, ProblemModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.brief)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.isPublished)
      ..writeByte(5)
      ..write(obj.sourceName)
      ..writeByte(6)
      ..write(obj.authorName)
      ..writeByte(7)
      ..write(obj.timeLimit)
      ..writeByte(8)
      ..write(obj.totalMemoryLimit)
      ..writeByte(9)
      ..write(obj.stackMemoryLimit)
      ..writeByte(10)
      ..write(obj.proposerId)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.publishedAt)
      ..writeByte(13)
      ..write(obj.ioType)
      ..writeByte(14)
      ..write(obj.difficulty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProblemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IoTypeAdapter extends TypeAdapter<IoType> {
  @override
  final int typeId = 3;

  @override
  IoType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IoType.standard;
      case 1:
        return IoType.file;
      default:
        return IoType.standard;
    }
  }

  @override
  void write(BinaryWriter writer, IoType obj) {
    switch (obj) {
      case IoType.standard:
        writer.writeByte(0);
        break;
      case IoType.file:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IoTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DifficultyAdapter extends TypeAdapter<Difficulty> {
  @override
  final int typeId = 4;

  @override
  Difficulty read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Difficulty.easy;
      case 1:
        return Difficulty.medium;
      case 2:
        return Difficulty.hard;
      case 3:
        return Difficulty.olympiad;
      case 4:
        return Difficulty.all;
      default:
        return Difficulty.easy;
    }
  }

  @override
  void write(BinaryWriter writer, Difficulty obj) {
    switch (obj) {
      case Difficulty.easy:
        writer.writeByte(0);
        break;
      case Difficulty.medium:
        writer.writeByte(1);
        break;
      case Difficulty.hard:
        writer.writeByte(2);
        break;
      case Difficulty.olympiad:
        writer.writeByte(3);
        break;
      case Difficulty.all:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DifficultyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
