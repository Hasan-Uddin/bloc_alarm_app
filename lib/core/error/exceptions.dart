// Base exception class
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

// ============== Data Source Exceptions ==============

// Location related exceptions
class LocationException extends AppException {
  const LocationException(super.message);

  factory LocationException.serviceDisabled() {
    return const LocationException('Location services are disabled');
  }

  factory LocationException.permissionDenied() {
    return const LocationException('Location permission denied');
  }

  factory LocationException.permissionDeniedForever() {
    return const LocationException(
      'Location permissions are permanently denied',
    );
  }
}

// Cache related exceptions
class CacheException extends AppException {
  const CacheException(super.message);

  factory CacheException.notFound() {
    return const CacheException('Data not found in cache');
  }

  factory CacheException.saveFailed() {
    return const CacheException('Failed to save data to cache');
  }
}

// Network related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message);

  factory NetworkException.noConnection() {
    return const NetworkException('No internet connection');
  }

  factory NetworkException.timeout() {
    return const NetworkException('Network request timeout');
  }
}

// Server related exceptions
class ServerException extends AppException {
  final int? statusCode;

  const ServerException(super.message, {this.statusCode});

  factory ServerException.internalError() {
    return const ServerException('Internal server error', statusCode: 500);
  }

  factory ServerException.notFound() {
    return const ServerException('Resource not found', statusCode: 404);
  }

  factory ServerException.unauthorized() {
    return const ServerException('Unauthorized', statusCode: 401);
  }

  factory ServerException.forbidden() {
    return const ServerException('Forbidden', statusCode: 403);
  }

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

  factory AuthenticationException.invalidCredentials() {
    return const AuthenticationException('Invalid credentials');
  }

  factory AuthenticationException.sessionExpired() {
    return const AuthenticationException('Session expired');
  }
}

// Database exceptions
class DatabaseException extends AppException {
  const DatabaseException(super.message);

  factory DatabaseException.notFound() {
    return const DatabaseException('Record not found');
  }

  factory DatabaseException.saveFailed() {
    return const DatabaseException('Failed to save to database');
  }
}

// Parsing exceptions
class ParsingException extends AppException {
  const ParsingException(super.message);

  factory ParsingException.invalidJson() {
    return const ParsingException('Invalid JSON format');
  }

  factory ParsingException.missingField(String field) {
    return ParsingException('Missing required field: $field');
  }
}

// Alarm related exceptions
class AlarmDataSourceException extends AppException {
  const AlarmDataSourceException(super.message);

  factory AlarmDataSourceException.notFound() {
    return const AlarmDataSourceException('Alarm not found');
  }

  factory AlarmDataSourceException.saveFailed() {
    return const AlarmDataSourceException('Failed to save alarm');
  }

  factory AlarmDataSourceException.deleteFailed() {
    return const AlarmDataSourceException('Failed to delete alarm');
  }

  factory AlarmDataSourceException.updateFailed() {
    return const AlarmDataSourceException('Failed to update alarm');
  }
}
