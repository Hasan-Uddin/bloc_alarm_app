import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/alarm_entity.dart';

abstract class AlarmRepository {
  Future<Either<Failure, List<AlarmEntity>>> getAlarms();
  Future<Either<Failure, void>> addAlarm(AlarmEntity alarm);
  Future<Either<Failure, void>> deleteAlarm(int id);
  Future<Either<Failure, void>> toggleAlarm(int id, bool isActive);
}
