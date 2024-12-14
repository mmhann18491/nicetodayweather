import 'package:hive/hive.dart';

part 'favorite_location.g.dart';

@HiveType(typeId: 1)
class FavoriteLocation extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  FavoriteLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
} 