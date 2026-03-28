import 'dart:async' show TimeoutException;
import 'dart:io' show SocketException;

import 'package:http/http.dart' as http;

import '../constants/app_constants.dart' show AppConstants;
import '../logger/app_logger.dart' show AppLogger;

/// Base class for all application exceptions.
class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => 'AppException: $message (statusCode: $statusCode)';
}

/// Thrown when there is no internet connection.
class NetworkException extends AppException {
  const NetworkException({super.message = AppConstants.networkErrorMessage});
}

/// Thrown for HTTP 4xx / 5xx server errors.
class ServerException extends AppException {
  const ServerException({
    super.message = AppConstants.serverErrorMessage,
    super.statusCode,
  });
}

/// Thrown when the request exceeds the configured timeout.
class AppTimeoutException extends AppException {
  const AppTimeoutException(
      {super.message = AppConstants.timeoutErrorMessage});
}

/// Thrown when JSON parsing fails.
class ParseException extends AppException {
  const ParseException({super.message = AppConstants.parseErrorMessage});
}

/// Maps low-level exceptions to [AppException] subtypes.
class ExceptionHandler {
  ExceptionHandler._();

  /// Handles HTTP-related exceptions.
  static AppException handleHttpException(Object e, StackTrace st) {
    AppLogger.error(
      title: 'ExceptionHandler',
      message: 'HTTP exception caught',
      exception: e,
      stackTrace: st,
    );

    if (e is AppException) return e;
    if (e is SocketException) return const NetworkException();
    if (e is http.ClientException) return const NetworkException();
    if (e is FormatException) return const ParseException();
    if (e is TimeoutException) return const AppTimeoutException();

    return AppException(message: AppConstants.unknownErrorMessage);
  }

  /// Handles generic exceptions.
  static AppException handleException(
      Object exception, StackTrace stackTrace) {
    AppLogger.error(
      title: 'ExceptionHandler',
      message: 'Unhandled exception',
      exception: exception,
      stackTrace: stackTrace,
    );

    if (exception is AppException) return exception;
    if (exception is FormatException) return const ParseException();

    return AppException(message: AppConstants.unknownErrorMessage);
  }
}
