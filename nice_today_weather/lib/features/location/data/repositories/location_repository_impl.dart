import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nice_today_weather/features/location/domain/entities/location.dart';
import 'package:nice_today_weather/features/location/domain/repositories/location_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<bool> checkPermission() async {
    try {
      // Check location service status
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      // Check location permission status
      final status = await Permission.location.status;
      return status.isGranted;
    } catch (e) {
      throw Exception('Failed to check location permission: $e');
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Try to enable location services first
        final locationOpened = await Geolocator.openLocationSettings();
        if (!locationOpened) {
          return false;
        }
        return false;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      throw Exception('Failed to request location permission: $e');
      // return false;
    }
  }

  @override
  Future<LocationEntity> getCurrentLocation() async {
    try {
      // Check permission first
      final hasPermission = await checkPermission();
      if (!hasPermission) {
        throw Exception('Location permission not granted');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      final address = await getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      return LocationEntity(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
    } on TimeoutException {
      throw Exception('Location request timed out. Please try again.');
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  @override
  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
        localeIdentifier: 'en',
      ).timeout(
        const Duration(seconds: 5),
      );

      if (placemarks.isEmpty) {
        return 'Unknown location';
      }

      final place = placemarks.first;
      final List<String> addressParts = [];

      if (place.locality?.isNotEmpty ?? false) {
        addressParts.add(place.locality!);
      }
      if (place.subAdministrativeArea?.isNotEmpty ?? false) {
        addressParts.add(place.subAdministrativeArea!);
      }
      if (place.country?.isNotEmpty ?? false) {
        addressParts.add(place.country!);
      }

      return addressParts.isNotEmpty
          ? addressParts.join(', ')
          : 'Unknown location';
    } catch (e) {
      return 'Unknown location';
    }
  }

  @override
  Future<LocationEntity> getCoordinatesFromAddress(String address) async {
    try {
      final trimmedAddress = address.trim();
      if (trimmedAddress.isEmpty) {
        throw Exception('Please enter a location');
      }

      final locations = await locationFromAddress(
        trimmedAddress,
        localeIdentifier: 'en',
      ).timeout(
        const Duration(seconds: 5),
      );

      if (locations.isEmpty) {
        throw Exception('Location not found. Please try a different search.');
      }

      final location = locations.first;
      return LocationEntity(
        latitude: location.latitude,
        longitude: location.longitude,
        address: trimmedAddress,
      );
    } on TimeoutException {
      throw Exception('Search timed out. Please try again.');
    } catch (e) {
      if (e is Exception) {
        throw e;
      }
      throw Exception('Failed to find location. Please try again.');
    }
  }
}
