import 'package:nice_today_weather/features/weather/domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.temperature,
    required super.feelsLike,
    required super.humidity,
    required super.description,
    required super.icon,
    required super.windSpeed,
    required super.cityName,
    required super.latitude,
    required super.longitude,
    super.dateTime,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json, {String? cityName}) {
    return WeatherModel(
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      windSpeed: json['wind']['speed'].toDouble(),
      cityName: cityName ?? json['name'] ?? 'Unknown',
      latitude: json['coord']?['lat']?.toDouble() ?? 0.0,
      longitude: json['coord']?['lon']?.toDouble() ?? 0.0,
      dateTime: json['dt'] != null ? DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000) : null,
    );
  }
} 