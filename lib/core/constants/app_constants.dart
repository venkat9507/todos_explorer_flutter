/// Application-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'Todos Explorer';

  static const String todosBaseUrl =
      'https://jsonplaceholder.typicode.com/todos';

  static const int todosPageSize = 20;

  static const String networkErrorMessage =
      'No internet connection. Please check your network.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String timeoutErrorMessage =
      'Request timed out. Please try again.';
  static const String parseErrorMessage = 'Failed to parse server response.';
  static const String unknownErrorMessage =
      'An unexpected error occurred.';
  static const String defaultErrorTitle = 'Something went wrong';
  static const String retryButtonLabel = 'Retry';

  static const String noSearchResultsMessage = 'No results match your search.';
  static const String emptyListMessage = 'Nothing here yet.';
  static const String scrollLoadMoreMessage = 'Scroll to load more items and retry.';
  static const String noInternetTitle = 'No Internet Connection';
  static const String noInternetMessage = 'Please check your network and try again';
}
