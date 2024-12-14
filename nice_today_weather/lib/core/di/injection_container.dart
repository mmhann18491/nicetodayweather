import 'package:get_it/get_it.dart';
import 'package:nice_today_weather/core/api/weather_api_service.dart';
import 'package:nice_today_weather/core/storage/storage_service.dart';
import 'package:nice_today_weather/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nice_today_weather/features/auth/domain/repositories/auth_repository.dart';
import 'package:nice_today_weather/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nice_today_weather/features/location/data/repositories/location_repository_impl.dart';
import 'package:nice_today_weather/features/location/domain/repositories/location_repository.dart';
import 'package:nice_today_weather/features/location/presentation/bloc/location_bloc.dart';
import 'package:nice_today_weather/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:nice_today_weather/features/weather/domain/repositories/weather_repository.dart';
import 'package:nice_today_weather/features/weather/presentation/bloc/weather_bloc.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Services
  final storageService = StorageService();
  await storageService.init();
  
  getIt.registerSingleton(storageService);
  getIt.registerLazySingleton(() => WeatherApiService());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      apiService: getIt(),
      storageService: getIt(),
    ),
  );
  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(),
  );

  // BLoCs
  getIt.registerFactory(
    () => AuthBloc(authRepository: getIt()),
  );
  getIt.registerFactory(
    () => WeatherBloc(
      weatherRepository: getIt(),
      locationRepository: getIt(),
    ),
  );
  getIt.registerFactory(
    () => LocationBloc(locationRepository: getIt()),
  );
} 