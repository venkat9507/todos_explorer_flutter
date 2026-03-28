import 'package:logger/logger.dart';

/// Centralized logger for the application.
///
/// Uses the `logger` package under the hood so output is colour-coded and
/// contains file/line information in debug builds.
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  /// Log a debug message (only visible in debug mode).
  static void debug({required String title, required String message}) {
    _logger.d('[$title] $message');
  }

  /// Log informational message.
  static void info({required String title, required String message}) {
    _logger.i('[$title] $message');
  }

  /// Log a warning.
  static void warning({required String title, required String message}) {
    _logger.w('[$title] $message');
  }

  /// Log an error with optional exception and stack trace.
  static void error({
    required String title,
    required String message,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    _logger.e('[$title] $message', error: exception, stackTrace: stackTrace);
  }
}
