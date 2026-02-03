import 'package:equatable/equatable.dart';

// Base class for all location events
abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

// Event to get current location from GPS
class GetCurrentLocationEvent extends LocationEvent {
  const GetCurrentLocationEvent();

  @override
  String toString() => 'GetCurrentLocationEvent';
}

// Event to check if location is already saved
class CheckSavedLocationEvent extends LocationEvent {
  const CheckSavedLocationEvent();

  @override
  String toString() => 'CheckSavedLocationEvent';
}

// Event when user skips location
class SkipLocationEvent extends LocationEvent {
  const SkipLocationEvent();

  @override
  String toString() => 'SkipLocationEvent';
}

// Event to delete saved location
class DeleteLocationEvent extends LocationEvent {
  const DeleteLocationEvent();

  @override
  String toString() => 'DeleteLocationEvent';
}

// Event to retry fetching location after an error
class RetryLocationEvent extends LocationEvent {
  const RetryLocationEvent();

  @override
  String toString() => 'RetryLocationEvent';
}
