// Generic API response wrapper
// Provides a consistent structure for handling success and error responses
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final dynamic error;

  ApiResponse({required this.success, this.data, this.message, this.error});

  // Success response
  factory ApiResponse.success({required T data, String? message}) {
    return ApiResponse<T>(success: true, data: data, message: message);
  }

  // Error response
  factory ApiResponse.error({required dynamic error, String? message}) {
    return ApiResponse<T>(success: false, error: error, message: message);
  }

  // Check if response has data
  bool get hasData => data != null;

  // Check if response has error
  bool get hasError => error != null;
}
