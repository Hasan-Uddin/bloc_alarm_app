import 'package:logger/logger.dart';

/// Centralized logging utility
/// Provides consistent logging across the app with different log levels
class AppLogger {
  // Private constructor to prevent instantiation
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static final Logger _loggerSimple = Logger(
    printer: SimplePrinter(colors: true),
  );

  /// Log debug message
  /// Use for development and debugging purposes
  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info message
  /// Use for general information
  static void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  /// Use for non-critical issues
  static void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  /// Use for errors that need attention
  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal/critical error
  /// Use for critical errors that might crash the app
  static void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log trace message (very detailed)
  /// Use for very detailed debug information
  static void trace(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// Simple log (no formatting)
  static void simple(dynamic message) {
    _loggerSimple.i(message);
  }

  /// Log network request
  static void logRequest(String method, String url, {Map<String, dynamic>? headers, dynamic body}) {
    info('🌐 API Request: $method $url');
    if (headers != null) debug('Headers: $headers');
    if (body != null) debug('Body: $body');
  }

  /// Log network response
  static void logResponse(int statusCode, String url, {dynamic data}) {
    if (statusCode >= 200 && statusCode < 300) {
      info('✅ API Response: $statusCode $url');
    } else {
      warning('⚠️ API Response: $statusCode $url');
    }
    if (data != null) debug('Data: $data');
  }

  /// Log BLoC event
  static void logBlocEvent(String blocName, dynamic event) {
    info('📤 [$blocName] Event: ${event.runtimeType}');
    debug('Event data: $event');
  }

  /// Log BLoC state
  static void logBlocState(String blocName, dynamic state) {
    info('📥 [$blocName] State: ${state.runtimeType}');
    debug('State data: $state');
  }

  /// Log navigation
  static void logNavigation(String route, {Map<String, dynamic>? arguments}) {
    info('🧭 Navigation: $route');
    if (arguments != null) debug('Arguments: $arguments');
  }
}
