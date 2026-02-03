import 'package:alarm_app/core/storage/local_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../helpers/logger.dart';
import '../models/location_model.dart';

abstract class LocationLocalDataSource {
  Future<LocationModel> getCurrentLocation();
  Future<LocationModel?> getSavedLocation();
  Future<void> saveLocation(LocationModel location);
  Future<void> deleteLocation();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  static const String LOCATION_BOX = 'location_box';
  static const String CURRENT_LOCATION_KEY = 'current_location';

  LocationLocalDataSourceImpl();

  @override
  Future<LocationModel> getCurrentLocation() async {
    try {
      AppLogger.info('Getting current location...');

      // Check location permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppLogger.error('Location services are disabled');
        throw LocationException('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppLogger.error('Location permissions are denied');
          throw LocationException('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AppLogger.error('Location permissions are permanently denied');
        throw LocationException(
          'Location permissions are permanently denied. Please enable them in settings.',
        );
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      AppLogger.debug(
        'Position obtained: ${position.latitude}, ${position.longitude}',
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        AppLogger.error('Could not get address from location');
        throw LocationException('Could not get address from location');
      }

      final placemark = placemarks.first;
      final address = _formatAddress(placemark);

      AppLogger.info('Location obtained successfully: $address');

      return LocationModel(
        addressField: address,
        latitudeField: position.latitude,
        longitudeField: position.longitude,
        cityField: placemark.locality ?? placemark.subAdministrativeArea,
        countryField: placemark.country,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      AppLogger.error('Error getting current location: $e');
      rethrow;
    }
  }

  @override
  Future<LocationModel?> getSavedLocation() async {
    try {
      AppLogger.info('Retrieving saved location from Hive...');

      final location = await LocalStorage.get<LocationModel>(
        LOCATION_BOX,
        CURRENT_LOCATION_KEY,
      );

      if (location != null) {
        AppLogger.info('Saved location found: ${location.addressField}');
      } else {
        AppLogger.info('No saved location found');
      }

      return location;
    } catch (e) {
      AppLogger.error('Error getting saved location: $e');
      return null;
    }
  }

  @override
  Future<void> saveLocation(LocationModel location) async {
    try {
      AppLogger.info('Saving location to Hive: ${location.addressField}');

      await LocalStorage.put<LocationModel>(
        LOCATION_BOX,
        CURRENT_LOCATION_KEY,
        location,
      );

      AppLogger.info('Location saved successfully');
    } catch (e) {
      AppLogger.error('Error saving location: $e');
      throw CacheException('Failed to save location');
    }
  }

  @override
  Future<void> deleteLocation() async {
    try {
      AppLogger.info('Deleting saved location...');

      await LocalStorage.delete(LOCATION_BOX, CURRENT_LOCATION_KEY);

      AppLogger.info('Location deleted successfully');
    } catch (e) {
      AppLogger.error('Error deleting location: $e');
      throw CacheException('Failed to delete location');
    }
  }

  String _formatAddress(Placemark placemark) {
    final parts = <String>[];

    if (placemark.street?.isNotEmpty ?? false) parts.add(placemark.street!);
    if (placemark.locality?.isNotEmpty ?? false) parts.add(placemark.locality!);
    if (placemark.subAdministrativeArea?.isNotEmpty ?? false) {
      parts.add(placemark.subAdministrativeArea!);
    }
    if (placemark.country?.isNotEmpty ?? false) parts.add(placemark.country!);

    return parts.isEmpty ? 'Unknown Location' : parts.join(', ');
  }
}

// Custom exceptions
class LocationException implements Exception {
  final String message;
  LocationException(this.message);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);

  @override
  String toString() => message;
}
