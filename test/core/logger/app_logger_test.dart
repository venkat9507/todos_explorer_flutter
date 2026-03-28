import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_app/core/logger/app_logger.dart';

void main() {
  group('AppLogger', () {
    // These tests verify that calling each log method does NOT throw.
    // AppLogger wraps the `logger` package, so we test the public API contract.

    test('debug does not throw', () {
      expect(
        () => AppLogger.debug(title: 'Test', message: 'debug msg'),
        returnsNormally,
      );
    });

    test('info does not throw', () {
      expect(
        () => AppLogger.info(title: 'Test', message: 'info msg'),
        returnsNormally,
      );
    });

    test('warning does not throw', () {
      expect(
        () => AppLogger.warning(title: 'Test', message: 'warning msg'),
        returnsNormally,
      );
    });

    test('error without exception does not throw', () {
      expect(
        () => AppLogger.error(title: 'Test', message: 'error msg'),
        returnsNormally,
      );
    });

    test('error with exception and stackTrace does not throw', () {
      expect(
        () => AppLogger.error(
          title: 'Test',
          message: 'error msg',
          exception: Exception('test'),
          stackTrace: StackTrace.current,
        ),
        returnsNormally,
      );
    });
  });
}
