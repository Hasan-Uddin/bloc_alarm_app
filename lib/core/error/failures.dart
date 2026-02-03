import 'package:equatable/equatable.dart';

// Base class for all failures in the application
// Uses Equatable for value comparison
abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = 'An unexpected error occurred']);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

// ============== General Failures ==============

// Server/API related failures
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

// Cache/Local storage failures
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

// Network connection failures
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error']);
}

// Authentication failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([super.message = 'Authentication failed']);
}

// Authorization failures
class AuthorizationFailure extends Failure {
  const AuthorizationFailure([super.message = 'Access denied']);
}

// ============== Feature Specific Failures ==============

// Location related failures
class LocationFailure extends Failure {
  const LocationFailure([super.message = 'Location error occurred']);

  // Specific location errors
  factory LocationFailure.serviceDisabled() {
    return const LocationFailure('Location services are disabled');
  }

  factory LocationFailure.permissionDenied() {
    return const LocationFailure('Location permission denied');
  }

  factory LocationFailure.permissionDeniedForever() {
    return const LocationFailure(
      'Location permissions are permanently denied. Please enable them in settings.',
    );
  }

  factory LocationFailure.addressNotFound() {
    return const LocationFailure('Could not get address from location');
  }

  factory LocationFailure.timeout() {
    return const LocationFailure('Location request timed out');
  }
}

// Database failures
class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'Database error occurred']);
}

// File system failures
class FileFailure extends Failure {
  const FileFailure([super.message = 'File operation failed']);
}

// Parsing failures (JSON, XML, etc.)
class ParsingFailure extends Failure {
  const ParsingFailure([super.message = 'Data parsing failed']);
}

// Not found failures (404 equivalent)
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

// Timeout failures
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timeout']);
}

// Unknown failures
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unknown error occurred']);
}

// ============== Helper Functions ==============

// Map exceptions to failures
Failure mapExceptionToFailure(Exception exception) {
  if (exception is LocationException) {
    return LocationFailure(exception.message);
  } else if (exception is CacheException) {
    return CacheFailure(exception.message);
  } else if (exception is NetworkException) {
    return NetworkFailure(exception.message);
  }
  return UnknownFailure(exception.toString());
}

// ============== Custom Exceptions ==============

// Base exception class
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

// Location related exceptions
class LocationException extends AppException {
  const LocationException(super.message);
}

// Cache related exceptions
class CacheException extends AppException {
  const CacheException(super.message);
}

// Network related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message);
}

// Server related exceptions
class ServerException extends AppException {
  final int? statusCode;

  const ServerException(super.message, {this.statusCode});

  @override
  String toString() =>
      statusCode != null ? '$message (Status: $statusCode)' : message;
}

// Validation exceptions
class ValidationException extends AppException {
  const ValidationException(super.message);
}

// Authentication exceptions
class AuthenticationException extends AppException {
  const AuthenticationException(super.message);
}

// Database exceptions
class DatabaseException extends AppException {
  const DatabaseException(super.message);
}
