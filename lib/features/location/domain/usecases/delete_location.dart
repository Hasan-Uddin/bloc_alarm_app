import 'package:alarm_app/core/usecases/usecase.dart';
import 'package:alarm_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../repositories/location_repository.dart';

class DeleteLocation implements UseCase<void, NoParams> {
  final LocationRepository repository;

  DeleteLocation(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.deleteLocation();
  }
}
