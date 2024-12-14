import 'package:hive/hive.dart';

part 'app_preferences.g.dart';

@HiveType(typeId: 2)
class AppPreferences extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  String temperatureUnit;

  @HiveField(2)
  String windSpeedUnit;

  AppPreferences({
    this.isDarkMode = false,
    this.temperatureUnit = 'celsius',
    this.windSpeedUnit = 'kmh',
  });
} 