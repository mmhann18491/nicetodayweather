// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteLocationAdapter extends TypeAdapter<FavoriteLocation> {
  @override
  final int typeId = 1;

  @override
  FavoriteLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteLocation(
      name: fields[0] as String,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteLocation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
