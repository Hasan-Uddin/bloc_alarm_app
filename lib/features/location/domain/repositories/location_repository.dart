import 'package:alarm_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/location_entity.dart';

abstract class LocationRepository {
  /// Get current location from GPS
  Future<Either<Failure, LocationEntity>> getCurrentLocation();

  /// Get saved location from local storage
  Future<Either<Failure, LocationEntity?>> getSavedLocation();

  /// Save location to local storage
  Future<Either<Failure, void>> saveLocation(LocationEntity location);

  /// Delete saved location from local storage
  Future<Either<Failure, void>> deleteLocation();
}
