import 'package:hive_flutter/hive_flutter.dart';
import 'package:nice_today_weather/core/storage/app_preferences.dart';
import 'package:nice_today_weather/features/weather/data/models/cached_weather.dart';
import 'package:nice_today_weather/features/weather/data/models/favorite_location.dart';

class StorageService {
  static const String weatherBox = 'weather_box';
  static const String favoritesBox = 'favorites_box';
  static const String preferencesBox = 'preferences_box';

  Future<void> init() async {
    // Register adapters
    Hive.registerAdapter(CachedWeatherAdapter());
    Hive.registerAdapter(FavoriteLocationAdapter());
    Hive.registerAdapter(AppPreferencesAdapter());

    // Open boxes
    await Future.wait([
      Hive.openBox<CachedWeather>(weatherBox),
      Hive.openBox<FavoriteLocation>(favoritesBox),
      Hive.openBox<AppPreferences>(preferencesBox),
    ]);

    // Initialize preferences if not exists
    final prefsBox = Hive.box<AppPreferences>(preferencesBox);
    if (prefsBox.isEmpty) {
      await prefsBox.put('settings', AppPreferences());
    }
  }

  // Weather cache methods
  Future<void> cacheWeather(String key, CachedWeather weather) async {
    final box = Hive.box<CachedWeather>(weatherBox);
    await box.put(key, weather);
  }

  CachedWeather? getCachedWeather(String key) {
    final box = Hive.box<CachedWeather>(weatherBox);
    final weather = box.get(key);
    
    if (weather == null) return null;
    
    // Check if cache is valid (less than 30 minutes old)
    final now = DateTime.now();
    if (now.difference(weather.timestamp) > const Duration(minutes: 30)) {
      box.delete(key);
      return null;
    }
    
    return weather;
  }

  // Favorite locations methods
  Future<void> addFavoriteLocation(FavoriteLocation location) async {
    final box = Hive.box<FavoriteLocation>(favoritesBox);
    await box.add(location);
  }

  Future<void> removeFavoriteLocation(int index) async {
    final box = Hive.box<FavoriteLocation>(favoritesBox);
    await box.deleteAt(index);
  }

  List<FavoriteLocation> getFavoriteLocations() {
    final box = Hive.box<FavoriteLocation>(favoritesBox);
    return box.values.toList();
  }

  // Preferences methods
  Future<void> updatePreferences(AppPreferences preferences) async {
    final box = Hive.box<AppPreferences>(preferencesBox);
    await box.put('settings', preferences);
  }

  AppPreferences getPreferences() {
    final box = Hive.box<AppPreferences>(preferencesBox);
    return box.get('settings') ?? AppPreferences();
  }
} 