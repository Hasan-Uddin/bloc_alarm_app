import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../helpers/logger.dart';
import '../../domain/entities/alarm_entity.dart';
import '../../domain/repositories/alarm_repository.dart';
import '../datasources/alarm_local_datasource.dart';
import '../models/alarm_model.dart';

class AlarmRepositoryImpl implements AlarmRepository {
  final AlarmLocalDataSource localDataSource;

  AlarmRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<AlarmEntity>>> getAlarms() async {
    try {
      AppLogger.info('Repository: Getting alarms');
      final alarms = await localDataSource.getAlarms();
      return Right(alarms);
    } catch (e) {
      AppLogger.error('Repository: Error getting alarms - $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addAlarm(AlarmEntity alarm) async {
    try {
      AppLogger.info('Repository: Adding alarm');
      final alarmModel = AlarmModel.fromEntity(alarm);
      await localDataSource.addAlarm(alarmModel);
      return const Right(null);
    } catch (e) {
      AppLogger.error('Repository: Error adding alarm - $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteAlarm(int id) async {
    try {
      AppLogger.info('Repository: Deleting alarm $id');
      await localDataSource.deleteAlarm(id);
      return const Right(null);
    } catch (e) {
      AppLogger.error('Repository: Error deleting alarm - $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> toggleAlarm(int id, bool isActive) async {
    try {
      AppLogger.info('Repository: Toggling alarm $id to $isActive');

      final alarms = await localDataSource.getAlarms();
      final alarmIndex = alarms.indexWhere((a) => a.id == id);

      if (alarmIndex != -1) {
        final updatedAlarm = alarms[alarmIndex].copyWith(isActive: isActive);
        await localDataSource.updateAlarm(updatedAlarm);
        return const Right(null);
      }

      return Left(CacheFailure());
    } catch (e) {
      AppLogger.error('Repository: Error toggling alarm - $e');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, String?>> getUserLocation() async {
    try {
      AppLogger.info('Repository: Getting user location');
      final location = await localDataSource.getUserLocation();
      return Right(location);
    } catch (e) {
      AppLogger.error('Repository: Error getting user location - $e');
      return Left(CacheFailure());
    }
  }
}
