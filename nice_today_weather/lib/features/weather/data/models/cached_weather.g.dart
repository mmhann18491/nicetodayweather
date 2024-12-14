// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_weather.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedWeatherAdapter extends TypeAdapter<CachedWeather> {
  @override
  final int typeId = 0;

  @override
  CachedWeather read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedWeather(
      temperature: fields[0] as double,
      feelsLike: fields[1] as double,
      humidity: fields[2] as int,
      description: fields[3] as String,
      icon: fields[4] as String,
      windSpeed: fields[5] as double,
      cityName: fields[6] as String,
      timestamp: fields[7] as DateTime,
      latitude: fields[8] as double,
      longitude: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CachedWeather obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.temperature)
      ..writeByte(1)
      ..write(obj.feelsLike)
      ..writeByte(2)
      ..write(obj.humidity)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.icon)
      ..writeByte(5)
      ..write(obj.windSpeed)
      ..writeByte(6)
      ..write(obj.cityName)
      ..writeByte(7)
      ..write(obj.timestamp)
      ..writeByte(8)
      ..write(obj.latitude)
      ..writeByte(9)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedWeatherAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
