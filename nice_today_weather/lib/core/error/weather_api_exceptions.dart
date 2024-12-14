//Weather API Exceptions
class WeatherApiException implements Exception {
  final String message;
  WeatherApiException(this.message);
}

