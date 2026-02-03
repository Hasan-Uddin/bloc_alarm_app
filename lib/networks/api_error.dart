import 'package:dio/dio.dart';

/// Custom API error classes
/// Provides structured error handling for network requests
abstract class ApiError implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiError({
    required this.message,
    this.statusCode,
    this.data,
  });

  /// Create ApiError from DioException
  factory ApiError.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutError(
          message: 'Request timeout. Please check your connection and try again.',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return RequestCancelledError();

      case DioExceptionType.connectionError:
        return NetworkError(
          message: 'No internet connection. Please check your network settings.',
        );

      case DioExceptionType.badCertificate:
        return BadCertificateError();

      case DioExceptionType.unknown:
      default:
        return UnknownError(
          message: error.message ?? 'An unexpected error occurred',
        );
    }
  }

  /// Handle bad response errors
  static ApiError _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode ?? 0;
    final dynamic data = response?.data;
    
    String message = 'An error occurred';
    
    // Try to extract error message from response
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? message;
    }

    switch (statusCode) {
      case 400:
        return BadRequestError(
          message: message,
          statusCode: statusCode,
          data: data,
        );
      case 401:
        return UnauthorizedError(
          message: 'Unauthorized. Please login again.',
          statusCode: statusCode,
          data: data,
        );
      case 403:
        return ForbiddenError(
          message: 'Access forbidden.',
          statusCode: statusCode,
          data: data,
        );
      case 404:
        return NotFoundError(
          message: 'Resource not found.',
          statusCode: statusCode,
          data: data,
        );
      case 409:
        return ConflictError(
          message: message,
          statusCode: statusCode,
          data: data,
        );
      case 422:
        return ValidationError(
          message: message,
          statusCode: statusCode,
          data: data,
        );
      case 500:
      case 502:
      case 503:
        return ServerError(
          message: 'Server error. Please try again later.',
          statusCode: statusCode,
          data: data,
        );
      default:
        return UnknownError(
          message: message,
          statusCode: statusCode,
          data: data,
        );
    }
  }

  @override
  String toString() => message;
}

// ============== Specific Error Types ==============

/// Network connection error
class NetworkError extends ApiError {
  NetworkError({required super.message});
}

/// Request timeout error
class TimeoutError extends ApiError {
  TimeoutError({required super.message});
}

/// Request cancelled error
class RequestCancelledError extends ApiError {
  RequestCancelledError() : super(message: 'Request was cancelled');
}

/// Bad certificate error
class BadCertificateError extends ApiError {
  BadCertificateError()
      : super(message: 'Certificate verification failed');
}

/// 400 Bad Request
class BadRequestError extends ApiError {
  BadRequestError({
    required super.message,
    super.statusCode,
    super.data,
  });
}

/// 401 Unauthorized
class UnauthorizedError extends ApiError {
  UnauthorizedError({
    required super.message,
    super.statusCode,
    super.data,
  });
}

/// 403 Forbidden
class ForbiddenError extends ApiError {
  ForbiddenError({
    required super.message,
    super.statusCode,
    super.data,
  });
}

/// 404 Not Found
class NotFoundError extends ApiError {
  NotFoundError({
    required super.message,
    super.statusCode,
    super.data,
  });
}

/// 409 Conflict
class ConflictError extends ApiError {
  ConflictError({
    required super.message,
    super.statusCode,
    super.data,
  });
}

/// 422 Validation Error
class ValidationError extends ApiError {
  ValidationError({
    required super.message,
    super.statusCode,
    super.data,
  });
}

/// 500+ Server Error
class ServerError extends ApiError {
  ServerError({
    required super.message,
    super.statusCode,
    super.data,
  });
}

/// Unknown Error
class UnknownError extends ApiError {
  UnknownError({
    required super.message,
    super.statusCode,
    super.data,
  });
}
