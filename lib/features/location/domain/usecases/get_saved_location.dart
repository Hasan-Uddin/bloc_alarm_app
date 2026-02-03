import 'package:alarm_app/core/error/failures.dart';
import 'package:alarm_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

// Returns the previously saved location if it exists, otherwise returns null
class GetSavedLocation implements UseCase<LocationEntity?, NoParams> {
  final LocationRepository repository;

  GetSavedLocation(this.repository);

  @override
  Future<Either<Failure, LocationEntity?>> call(NoParams params) async {
    return await repository.getSavedLocation();
  }
}
