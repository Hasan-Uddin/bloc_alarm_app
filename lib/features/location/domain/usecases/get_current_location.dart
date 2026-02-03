
import 'package:alarm_app/core/error/failures.dart';
import 'package:alarm_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

// This use case interacts with the LocationRepository to fetch
// the user's current GPS location and convert it to an address
class GetCurrentLocation implements UseCase<LocationEntity, NoParams> {
  final LocationRepository repository;

  GetCurrentLocation(this.repository);

  @override
  Future<Either<Failure, LocationEntity>> call(NoParams params) async {
    return await repository.getCurrentLocation();
  }
}
