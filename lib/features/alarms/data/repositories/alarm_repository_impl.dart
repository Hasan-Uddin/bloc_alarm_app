import 'package:alarm_app/core/error/exceptions.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../helpers/logger.dart';
import '../../domain/entities/alarm_entity.dart';
import '../../domain/repositories/alarm_repository.dart';
import '../datasources/alarm_local_datasource.dart'
    hide AlarmDataSourceException;
import '../models/alarm_model.dart';

class AlarmRepositoryImpl implements AlarmRepository {
  final AlarmLocalDataSource localDataSource;

  AlarmRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<AlarmEntity>>> getAlarms() async {
    try {
      AppLogger.info('Repository: Getting alarms...');
      final alarms = await localDataSource.getAlarms();
      AppLogger.info('Repository: Got ${alarms.length} alarms');
      return Right(alarms);
    } on AlarmDataSourceException catch (e) {
      AppLogger.error('Repository: DataSource exception - ${e.message}');
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error('Repository: Unexpected error - $e');
      AppLogger.error('StackTrace: $stackTrace');
      return Left(CacheFailure('Failed to load alarms'));
    }
  }

  @override
  Future<Either<Failure, void>> addAlarm(AlarmEntity alarm) async {
    try {
      AppLogger.info('Repository: Adding alarm at ${alarm.time}');
      final alarmModel = AlarmModel.fromEntity(alarm);
      await localDataSource.addAlarm(alarmModel);
      AppLogger.info('Repository: Alarm added');
      return const Right(null);
    } on AlarmDataSourceException catch (e) {
      AppLogger.error('Repository: DataSource exception - ${e.message}');
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error('Repository: Unexpected error - $e');
      AppLogger.error('StackTrace: $stackTrace');
      return Left(CacheFailure('Failed to add alarm'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAlarm(int id) async {
    try {
      AppLogger.info('Repository: Deleting alarm $id');
      await localDataSource.deleteAlarm(id);
      AppLogger.info('Repository: Alarm deleted successfully');
      return const Right(null);
    } on AlarmDataSourceException catch (e) {
      AppLogger.error('Repository: DataSource exception - ${e.message}');
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error('Repository: Unexpected error - $e');
      AppLogger.error('StackTrace: $stackTrace');
      return Left(CacheFailure('Failed to delete alarm'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleAlarm(int id, bool isActive) async {
    try {
      AppLogger.info('Repository: Toggling alarm $id to $isActive');

      final alarms = await localDataSource.getAlarms();
      AppLogger.info('Repository: Found ${alarms.length} alarms in storage');

      final alarmIndex = alarms.indexWhere((a) => a.id == id);

      if (alarmIndex == -1) {
        AppLogger.error('Repository: Alarm $id not found');
        AppLogger.info(
          'Repository: Available IDs: ${alarms.map((a) => a.id).toList()}',
        );
        return Left(CacheFailure('Alarm not found'));
      }

      AppLogger.info('Repository: Found alarm at index $alarmIndex');

      final updatedAlarm = alarms[alarmIndex].copyWith(isActive: isActive);
      await localDataSource.updateAlarm(updatedAlarm);

      AppLogger.info('Repository: Alarm toggled successfully');
      return const Right(null);
    } on AlarmDataSourceException catch (e) {
      AppLogger.error('Repository: DataSource exception - ${e.message}');
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      AppLogger.error('Repository: Unexpected error - $e');
      AppLogger.error('StackTrace: $stackTrace');
      return Left(CacheFailure('Failed to toggle alarm'));
    }
  }
}
