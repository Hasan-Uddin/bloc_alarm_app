import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/api_endpoints.dart';
import '../helpers/logger.dart';
import 'api_error.dart';

// Configured Dio HTTP client
// Provides a singleton instance with interceptors for logging and error handling
class DioClient {
  // Singleton instance
  static late Dio _dio;

  // Initialize Dio with configuration
  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: Duration(milliseconds: ApiEndpoints.connectionTimeout),
        receiveTimeout: Duration(milliseconds: ApiEndpoints.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      // Pretty Dio Logger (for development)
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),

      // Custom interceptor for token management
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authentication token if available
          // final token = await getAuthToken();
          // if (token != null) {
          //   options.headers['Authorization'] = 'Bearer $token';
          // }

          AppLogger.logRequest(
            options.method,
            options.uri.toString(),
            headers: options.headers,
            body: options.data,
          );

          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.logResponse(
            response.statusCode ?? 0,
            response.requestOptions.uri.toString(),
            data: response.data,
          );
          return handler.next(response);
        },
        onError: (error, handler) async {
          AppLogger.error(
            'API Error: ${error.requestOptions.uri}',
            error,
            error.stackTrace,
          );

          // Handle token refresh or retry logic here
          // if (error.response?.statusCode == 401) {
          //   // Token expired, try to refresh
          // }

          return handler.next(error);
        },
      ),
    ]);
  }

  // Get Dio instance
  static Dio get instance {
    return _dio;
  }

  // GET request
  static Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw ApiError.fromDioError(e);
    }
  }

  // POST request
  static Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw ApiError.fromDioError(e);
    }
  }

  // PUT request
  static Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw ApiError.fromDioError(e);
    }
  }

  // DELETE request
  static Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw ApiError.fromDioError(e);
    }
  }

  // PATCH request
  static Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      throw ApiError.fromDioError(e);
    }
  }
}
