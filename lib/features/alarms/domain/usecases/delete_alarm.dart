import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/alarm_repository.dart';

class DeleteAlarm implements UseCase<void, DeleteAlarmParams> {
  final AlarmRepository repository;

  DeleteAlarm(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAlarmParams params) async {
    return await repository.deleteAlarm(params.id);
  }
}

class DeleteAlarmParams extends Equatable {
  final int id;

  const DeleteAlarmParams({required this.id});

  @override
  List<Object?> get props => [id];
}
