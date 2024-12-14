import 'package:nice_today_weather/features/location/domain/entities/location.dart';

abstract class LocationRepository {
  Future<bool> requestPermission();
  Future<bool> checkPermission();
  Future<LocationEntity> getCurrentLocation();
  Future<String> getAddressFromCoordinates(double latitude, double longitude);
  Future<LocationEntity> getCoordinatesFromAddress(String address);
}
