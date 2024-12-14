import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nice_today_weather/core/error/weather_api_exceptions.dart';
import 'package:nice_today_weather/features/location/domain/repositories/location_repository.dart';
import 'package:nice_today_weather/features/weather/domain/entities/weather.dart';
import 'package:nice_today_weather/features/weather/domain/repositories/weather_repository.dart';

// Events
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class GetWeatherByLocation extends WeatherEvent {
  final double latitude;
  final double longitude;

  const GetWeatherByLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

class GetWeatherByCity extends WeatherEvent {
  final String cityName;

  const GetWeatherByCity(this.cityName);

  @override
  List<Object?> get props => [cityName];
}

// States
abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  final List<Weather> forecast;

  const WeatherLoaded({required this.weather, required this.forecast});

  @override
  List<Object?> get props => [weather, forecast];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;
  final LocationRepository _locationRepository;

  WeatherBloc({
    required WeatherRepository weatherRepository,
    required LocationRepository locationRepository,
  })  : _weatherRepository = weatherRepository,
        _locationRepository = locationRepository,
        super(WeatherInitial()) {
    on<GetWeatherByLocation>(_onGetWeatherByLocation);
    on<GetWeatherByCity>(_onGetWeatherByCity);
  }

  Future<void> _onGetWeatherByLocation(
    GetWeatherByLocation event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    try {
      final weather = await _weatherRepository.getWeatherByLocation(
        event.latitude,
        event.longitude,
      );
      final forecast = await _weatherRepository.getForecast(
        event.latitude,
        event.longitude,
      );
      emit(WeatherLoaded(weather: weather, forecast: forecast));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }

  Future<void> _onGetWeatherByCity(
    GetWeatherByCity event,
    Emitter<WeatherState> emit,
  ) async {
    try {
      emit(WeatherLoading());
      print('Fetching weather for city: ${event.cityName}');
      final weather = await _weatherRepository.getWeatherByCity(event.cityName);
      final forecast = await _weatherRepository.getForecast(
        weather.latitude,
        weather.longitude,
      );
      print('Weather data received: $weather');
      print('Forecast data received: $forecast');
      emit(WeatherLoaded(weather: weather, forecast: forecast));
    } catch (e) {
      if (e is WeatherApiException) {
        emit(WeatherError(e.message));
      } else {
        emit(WeatherError(e.toString()));
      }
    }
  }
}
