import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final String description;
  final String icon;
  final double windSpeed;
  final String cityName;
  final double latitude;
  final double longitude;
  final DateTime? dateTime;

  const Weather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.cityName,
    required this.latitude,
    required this.longitude,
    this.dateTime,
  });

  @override
  List<Object?> get props => [
    temperature,
    feelsLike,
    humidity,
    description,
    icon,
    windSpeed,
    cityName,
    latitude,
    longitude,
    dateTime,
  ];
}
