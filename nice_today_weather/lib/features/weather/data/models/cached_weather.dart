import 'package:hive/hive.dart';

part 'cached_weather.g.dart';

@HiveType(typeId: 0)
class CachedWeather extends HiveObject {
  @HiveField(0)
  final double temperature;

  @HiveField(1)
  final double feelsLike;

  @HiveField(2)
  final int humidity;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String icon;

  @HiveField(5)
  final double windSpeed;

  @HiveField(6)
  final String cityName;

  @HiveField(7)
  final DateTime timestamp;

  @HiveField(8)
  final double latitude;

  @HiveField(9)
  final double longitude;

  CachedWeather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.cityName,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
  });
} 