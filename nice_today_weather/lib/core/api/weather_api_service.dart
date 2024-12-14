import 'package:dio/dio.dart';
import 'package:nice_today_weather/core/error/weather_api_exceptions.dart';

class WeatherApiService {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String apiKey = '7f5cb3deb228f2f9f4c1f4cf9402034c';

  final Dio _dio;

  WeatherApiService() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    queryParameters: {'appid': apiKey, 'units': 'metric'},
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Please check your internet connection.';
        case DioExceptionType.connectionError:
          return 'No internet connection. Please check your network settings.';
        case DioExceptionType.badResponse:
          switch (error.response?.statusCode) {
            case 401:
              return 'API key is invalid or expired.';
            case 404:
              return 'Weather information not found for this location.';
            case 429:
              return 'Too many requests. Please try again later.';
            case 500:
            case 502:
            case 503:
            case 504:
              return 'Weather service is temporarily unavailable. Please try again later.';
            default:
              return 'Failed to fetch weather data. Please try again.';
          }
        default:
          return 'An unexpected error occurred. Please try again.';
      }
    }
    return 'Failed to fetch weather data: $error';
  }

  Future<Map<String, dynamic>> getCurrentWeather(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
        },
      );
      return response.data;
    } catch (e) {
      throw WeatherApiException(_handleError(e));
    }
  }

  Future<Map<String, dynamic>> getWeatherByCity(String cityName) async {
    try {
      final response = await _dio.get(
        '/weather',
        queryParameters: {
          'q': cityName,
        },
      );
      return response.data;
    } catch (e) {
      throw WeatherApiException(_handleError(e));
    }
  }

  Future<Map<String, dynamic>> getForecast(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '/forecast',
        queryParameters: {
          'lat': lat,
          'lon': lon,
        },
      );
      return response.data;
    } catch (e) {
      throw WeatherApiException(_handleError(e));
    }
  }
} 