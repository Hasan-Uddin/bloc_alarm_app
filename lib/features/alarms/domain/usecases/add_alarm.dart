import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/alarm_entity.dart';
import '../repositories/alarm_repository.dart';

class AddAlarm implements UseCase<void, AddAlarmParams> {
  final AlarmRepository repository;

  AddAlarm(this.repository);

  @override
  Future<Either<Failure, void>> call(AddAlarmParams params) async {
    return await repository.addAlarm(params.alarm);
  }
}

class AddAlarmParams extends Equatable {
  final AlarmEntity alarm;

  const AddAlarmParams({required this.alarm});

  @override
  List<Object?> get props => [alarm];
}
