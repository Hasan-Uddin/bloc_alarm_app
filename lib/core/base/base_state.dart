import 'package:equatable/equatable.dart';

// Base states for BLoC pattern
// Provides common state types: Initial, Loading, Success, Error

// Base state class
abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

// Initial state - when BLoC is first created
class InitialState extends BaseState {
  const InitialState();
}

// Loading state - when an operation is in progress
class LoadingState extends BaseState {
  final String? message;

  const LoadingState({this.message});

  @override
  List<Object?> get props => [message];
}

// Success state with data
class SuccessState<T> extends BaseState {
  final T data;
  final String? message;

  const SuccessState({required this.data, this.message});

  @override
  List<Object?> get props => [data, message];
}

// Error state
class ErrorState extends BaseState {
  final String message;
  final dynamic error;

  const ErrorState({required this.message, this.error});

  @override
  List<Object?> get props => [message, error];
}

// Empty state - when there's no data
class EmptyState extends BaseState {
  final String? message;

  const EmptyState({this.message});

  @override
  List<Object?> get props => [message];
}
