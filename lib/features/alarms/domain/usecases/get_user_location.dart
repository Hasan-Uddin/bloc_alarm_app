import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/alarm_repository.dart';

class GetUserLocation implements UseCase<String?, NoParams> {
  final AlarmRepository repository;

  GetUserLocation(this.repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) async {
    return await repository.getUserLocation();
  }
}
