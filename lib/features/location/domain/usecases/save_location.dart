import 'package:alarm_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

// Saves the provided location entity to persistent storage
// for later retrieval
class SaveLocation implements UseCase<void, SaveLocationParams> {
  final LocationRepository repository;

  SaveLocation(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveLocationParams params) async {
    return await repository.saveLocation(params.location);
  }
}

// Parameters for SaveLocation use case
class SaveLocationParams extends Equatable {
  final LocationEntity location;

  const SaveLocationParams({required this.location});

  @override
  List<Object?> get props => [location];
}
