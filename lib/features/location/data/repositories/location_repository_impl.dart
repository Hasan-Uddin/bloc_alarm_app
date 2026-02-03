import 'package:alarm_app/core/error/failures.dart' hide LocationException;
import 'package:dartz/dartz.dart';
import '../../../../helpers/logger.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_local_datasource.dart';
import '../models/location_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource localDataSource;

  LocationRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    try {
      AppLogger.info('Repository: Getting current location');
      final location = await localDataSource.getCurrentLocation();
      return Right(location);
    } on LocationException catch (e) {
      AppLogger.error('Repository: Location exception - ${e.message}');
      return Left(LocationFailure(e.message));
    } catch (e) {
      AppLogger.error('Repository: Unexpected error - $e');
      return Left(LocationFailure('Failed to get current location: $e'));
    }
  }

  @override
  Future<Either<Failure, LocationEntity?>> getSavedLocation() async {
    try {
      AppLogger.info('Repository: Getting saved location');
      final location = await localDataSource.getSavedLocation();
      return Right(location);
    } catch (e) {
      AppLogger.error('Repository: Error getting saved location - $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveLocation(LocationEntity location) async {
    try {
      AppLogger.info('Repository: Saving location');
      final locationModel = LocationModel.fromEntity(location);
      await localDataSource.saveLocation(locationModel);
      return const Right(null);
    } catch (e) {
      AppLogger.error('Repository: Error saving location - $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteLocation() async {
    try {
      AppLogger.info('Repository: Deleting location');
      await localDataSource.deleteLocation();
      return const Right(null);
    } catch (e) {
      AppLogger.error('Repository: Error deleting location - $e');
      return Left(CacheFailure());
    }
  }
}
