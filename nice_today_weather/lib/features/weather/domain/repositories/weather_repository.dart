import 'package:nice_today_weather/features/weather/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getWeatherByLocation(double latitude, double longitude);
  Future<Weather> getWeatherByCity(String cityName);
  Future<List<Weather>> getForecast(double latitude, double longitude);
} 