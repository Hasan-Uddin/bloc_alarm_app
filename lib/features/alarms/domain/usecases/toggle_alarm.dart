import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/alarm_repository.dart';

class ToggleAlarm implements UseCase<void, ToggleAlarmParams> {
  final AlarmRepository repository;

  ToggleAlarm(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleAlarmParams params) async {
    return await repository.toggleAlarm(params.id, params.isActive);
  }
}

class ToggleAlarmParams extends Equatable {
  final int id;
  final bool isActive;

  const ToggleAlarmParams({required this.id, required this.isActive});

  @override
  List<Object?> get props => [id, isActive];
}
