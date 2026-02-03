import 'package:equatable/equatable.dart';
import '../../domain/entities/location_entity.dart';

/// Base class for all location states
abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the screen first loads
class LocationInitial extends LocationState {
  const LocationInitial();

  @override
  String toString() => 'LocationInitial';
}

/// State when location is being fetched or saved
class LocationLoading extends LocationState {
  final String? message;

  const LocationLoading([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'LocationLoading(message: $message)';
}

/// State when location has been successfully loaded/saved
class LocationLoaded extends LocationState {
  final LocationEntity location;
  final bool isFromCache;

  const LocationLoaded(this.location, {this.isFromCache = false});

  @override
  List<Object?> get props => [location, isFromCache];

  @override
  String toString() =>
      'LocationLoaded(location: ${location.address}, fromCache: $isFromCache)';
}

/// State when user skips location selection
class LocationSkipped extends LocationState {
  const LocationSkipped();

  @override
  String toString() => 'LocationSkipped';
}

/// State when an error occurs
class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'LocationError(message: $message)';
}

/// State when location is being deleted
class LocationDeleting extends LocationState {
  const LocationDeleting();

  @override
  String toString() => 'LocationDeleting';
}

/// State when location has been successfully deleted
class LocationDeleted extends LocationState {
  const LocationDeleted();

  @override
  String toString() => 'LocationDeleted';
}
