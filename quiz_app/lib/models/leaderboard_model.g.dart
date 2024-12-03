// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LeaderboardEntryAdapter extends TypeAdapter<LeaderboardEntry> {
  @override
  final int typeId = 0;

  @override
  LeaderboardEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LeaderboardEntry(
      playerName: fields[0] as String,
      score: fields[1] as int,
      category: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LeaderboardEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.playerName)
      ..writeByte(1)
      ..write(obj.score)
      ..writeByte(2)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeaderboardEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
