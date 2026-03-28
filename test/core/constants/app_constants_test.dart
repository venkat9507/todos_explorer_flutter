import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_app/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    test('appName is a non-empty string', () {
      expect(AppConstants.appName, isNotEmpty);
    });

    test('todosBaseUrl is a valid HTTPS URL', () {
      final uri = Uri.tryParse(AppConstants.todosBaseUrl);
      expect(uri, isNotNull);
      expect(uri!.scheme, 'https');
    });

    test('todosPageSize is a positive integer', () {
      expect(AppConstants.todosPageSize, greaterThan(0));
    });

    test('error messages are non-empty strings', () {
      expect(AppConstants.networkErrorMessage, isNotEmpty);
      expect(AppConstants.serverErrorMessage, isNotEmpty);
      expect(AppConstants.timeoutErrorMessage, isNotEmpty);
      expect(AppConstants.parseErrorMessage, isNotEmpty);
      expect(AppConstants.unknownErrorMessage, isNotEmpty);
      expect(AppConstants.defaultErrorTitle, isNotEmpty);
    });

    test('UI messages are non-empty strings', () {
      expect(AppConstants.retryButtonLabel, isNotEmpty);
      expect(AppConstants.noSearchResultsMessage, isNotEmpty);
      expect(AppConstants.emptyListMessage, isNotEmpty);
      expect(AppConstants.scrollLoadMoreMessage, isNotEmpty);
      expect(AppConstants.noInternetTitle, isNotEmpty);
      expect(AppConstants.noInternetMessage, isNotEmpty);
    });
  });
}
