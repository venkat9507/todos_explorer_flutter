import 'dart:async' show TimeoutException;
import 'dart:io' show SocketException;

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_interview_app/core/constants/app_constants.dart';
import 'package:flutter_interview_app/core/exceptions/exception_handler.dart';

void main() {
  // ─── Exception Model Tests ───────────────────────────────────────────────

  group('AppException', () {
    test('stores message and optional statusCode', () {
      const e = AppException(message: 'test', statusCode: 404);
      expect(e.message, 'test');
      expect(e.statusCode, 404);
    });

    test('toString includes message and statusCode', () {
      const e = AppException(message: 'fail', statusCode: 500);
      expect(e.toString(), contains('fail'));
      expect(e.toString(), contains('500'));
    });

    test('statusCode defaults to null', () {
      const e = AppException(message: 'test');
      expect(e.statusCode, isNull);
    });
  });

  group('NetworkException', () {
    test('uses default network error message', () {
      const e = NetworkException();
      expect(e.message, AppConstants.networkErrorMessage);
    });

    test('accepts custom message', () {
      const e = NetworkException(message: 'custom');
      expect(e.message, 'custom');
    });
  });

  group('ServerException', () {
    test('uses default server error message', () {
      const e = ServerException();
      expect(e.message, AppConstants.serverErrorMessage);
    });

    test('stores statusCode', () {
      const e = ServerException(statusCode: 503);
      expect(e.statusCode, 503);
    });
  });

  group('AppTimeoutException', () {
    test('uses default timeout error message', () {
      const e = AppTimeoutException();
      expect(e.message, AppConstants.timeoutErrorMessage);
    });
  });

  group('ParseException', () {
    test('uses default parse error message', () {
      const e = ParseException();
      expect(e.message, AppConstants.parseErrorMessage);
    });
  });

  // ─── Exception Handler Tests ──────────────────────────────────────────────

  group('ExceptionHandler.handleHttpException', () {
    test('returns AppException as-is', () {
      const original = AppException(message: 'original');
      final result = ExceptionHandler.handleHttpException(
          original, StackTrace.current);
      expect(result, same(original));
    });

    test('converts SocketException to NetworkException', () {
      final result = ExceptionHandler.handleHttpException(
        const SocketException('no net'),
        StackTrace.current,
      );
      expect(result, isA<NetworkException>());
    });

    test('converts http.ClientException to NetworkException', () {
      final result = ExceptionHandler.handleHttpException(
        http.ClientException('fail'),
        StackTrace.current,
      );
      expect(result, isA<NetworkException>());
    });

    test('converts FormatException to ParseException', () {
      final result = ExceptionHandler.handleHttpException(
        const FormatException('bad json'),
        StackTrace.current,
      );
      expect(result, isA<ParseException>());
    });

    test('converts TimeoutException to AppTimeoutException', () {
      final result = ExceptionHandler.handleHttpException(
        TimeoutException('took too long'),
        StackTrace.current,
      );
      expect(result, isA<AppTimeoutException>());
    });

    test('converts unknown exceptions to AppException with unknown message',
        () {
      final result = ExceptionHandler.handleHttpException(
        Exception('weird'),
        StackTrace.current,
      );
      expect(result, isA<AppException>());
      expect(result.message, AppConstants.unknownErrorMessage);
    });
  });

  group('ExceptionHandler.handleException', () {
    test('returns AppException as-is', () {
      const original = ServerException(statusCode: 500);
      final result =
          ExceptionHandler.handleException(original, StackTrace.current);
      expect(result, same(original));
    });

    test('converts FormatException to ParseException', () {
      final result = ExceptionHandler.handleException(
        const FormatException('bad'),
        StackTrace.current,
      );
      expect(result, isA<ParseException>());
    });

    test('converts unknown exceptions to AppException with unknown message',
        () {
      final result = ExceptionHandler.handleException(
        StateError('broken'),
        StackTrace.current,
      );
      expect(result, isA<AppException>());
      expect(result.message, AppConstants.unknownErrorMessage);
    });
  });
}
