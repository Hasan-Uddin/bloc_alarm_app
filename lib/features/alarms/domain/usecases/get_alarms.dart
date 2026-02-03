import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/alarm_entity.dart';
import '../repositories/alarm_repository.dart';

class GetAlarms implements UseCase<List<AlarmEntity>, NoParams> {
  final AlarmRepository repository;

  GetAlarms(this.repository);

  @override
  Future<Either<Failure, List<AlarmEntity>>> call(NoParams params) async {
    return await repository.getAlarms();
  }
}
