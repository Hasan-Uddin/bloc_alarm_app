import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base class for all use cases
///
/// [Type] - The return type of the use case
/// [Params] - The parameters required by the use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Used when a use case doesn't require any parameters
class NoParams {
  const NoParams();
}
