import 'package:nice_today_weather/core/api/weather_api_service.dart';
import 'package:nice_today_weather/core/storage/storage_service.dart';
import 'package:nice_today_weather/features/weather/data/models/cached_weather.dart';
import 'package:nice_today_weather/features/weather/data/models/weather_model.dart';
import 'package:nice_today_weather/features/weather/domain/entities/weather.dart';
import 'package:nice_today_weather/features/weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService _apiService;
  final StorageService _storageService;

  WeatherRepositoryImpl({
    required WeatherApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  @override
  Future<Weather> getWeatherByLocation(
      double latitude, double longitude) async {
    final cacheKey =
        '${latitude.toStringAsFixed(2)},${longitude.toStringAsFixed(2)}';
    final cachedWeather = _storageService.getCachedWeather(cacheKey);

    if (cachedWeather != null) {
      return WeatherModel(
        temperature: cachedWeather.temperature,
        feelsLike: cachedWeather.feelsLike,
        humidity: cachedWeather.humidity,
        description: cachedWeather.description,
        icon: cachedWeather.icon,
        windSpeed: cachedWeather.windSpeed,
        cityName: cachedWeather.cityName,
        latitude: latitude,
        longitude: longitude,
      );
    }

    final json = await _apiService.getCurrentWeather(latitude, longitude);
    final weather = WeatherModel.fromJson(json);

    // Cache the weather data
    await _storageService.cacheWeather(
      cacheKey,
      CachedWeather(
        latitude: weather.latitude,
        longitude: weather.longitude,
        temperature: weather.temperature,
        feelsLike: weather.feelsLike,
        humidity: weather.humidity,
        description: weather.description,
        icon: weather.icon,
        windSpeed: weather.windSpeed,
        cityName: weather.cityName,
        timestamp: DateTime.now(),
      ),
    );

    return weather;
  }

  @override
  Future<Weather> getWeatherByCity(String cityName) async {
    final cacheKey = 'city:$cityName';
    final cachedWeather = _storageService.getCachedWeather(cacheKey);

    if (cachedWeather != null) {
      final weatherJson = await _apiService.getWeatherByCity(cityName);
      return WeatherModel(
        temperature: cachedWeather.temperature,
        feelsLike: cachedWeather.feelsLike,
        humidity: cachedWeather.humidity,
        description: cachedWeather.description,
        icon: cachedWeather.icon,
        windSpeed: cachedWeather.windSpeed,
        cityName: cachedWeather.cityName,
        latitude: weatherJson['coord']['lat'].toDouble(),
        longitude: weatherJson['coord']['lon'].toDouble(),
      );
    }

    final json = await _apiService.getWeatherByCity(cityName);
    final weather = WeatherModel.fromJson(json);

    // Cache the weather data
    await _storageService.cacheWeather(
      cacheKey,
      CachedWeather(
        latitude: weather.latitude,
        longitude: weather.longitude,
        temperature: weather.temperature,
        feelsLike: weather.feelsLike,
        humidity: weather.humidity,
        description: weather.description,
        icon: weather.icon,
        windSpeed: weather.windSpeed,
        cityName: weather.cityName,
        timestamp: DateTime.now(),
      ),
    );

    return weather;
  }

  @override
  Future<List<Weather>> getForecast(double latitude, double longitude) async {
    final json = await _apiService.getForecast(latitude, longitude);
    final List<dynamic> list = json['list'];
    final cityName = json['city']['name'];
    return list
        .map((item) => WeatherModel.fromJson(item, cityName: cityName))
        .toList();
  }
}
