import 'package:equatable/equatable.dart';

// Base event class for BLoC pattern
// All events should extend this class
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}
