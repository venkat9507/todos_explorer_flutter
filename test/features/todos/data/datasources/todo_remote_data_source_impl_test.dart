import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_interview_app/features/todos/data/datasources/todo_remote_data_source_impl.dart';
import 'package:flutter_interview_app/features/todos/domain/entities/todo_entity.dart';
import 'package:flutter_interview_app/core/exceptions/exception_handler.dart';
import 'package:flutter_interview_app/core/constants/app_constants.dart';

import '../../helpers/test_mocks.mocks.dart';
import '../../helpers/test_data.dart';

void main() {
  late MockAppHttpClient mockHttpClient;
  late TodoRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockAppHttpClient();
    dataSource = TodoRemoteDataSourceImpl(httpClient: mockHttpClient);
  });

  group('TodoRemoteDataSourceImpl', () {
    group('getTodosPaged', () {
      test('returns list of TodoEntity on success', () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => TestData.sampleJsonList,
        );

        final result = await dataSource.getTodosPaged(start: 0, limit: 20);

        expect(result, isA<List<TodoEntity>>());
        expect(result.length, 3);
        expect(result[0], TestData.todoEntity1);
        expect(result[1], TestData.todoEntity2);
        expect(result[2], TestData.todoEntity3);
      });

      test('calls httpClient with correct URL', () async {
        when(mockHttpClient.get(any)).thenAnswer((_) async => []);

        await dataSource.getTodosPaged(start: 0, limit: 20);

        verify(mockHttpClient.get(
          '${AppConstants.todosBaseUrl}?_start=0&_limit=20',
        )).called(1);
      });

      test('builds URL with correct start and limit params', () async {
        when(mockHttpClient.get(any)).thenAnswer((_) async => []);

        await dataSource.getTodosPaged(start: 40, limit: 10);

        verify(mockHttpClient.get(
          '${AppConstants.todosBaseUrl}?_start=40&_limit=10',
        )).called(1);
      });

      test('returns empty list when API returns empty array', () async {
        when(mockHttpClient.get(any)).thenAnswer((_) async => []);

        final result = await dataSource.getTodosPaged(start: 0, limit: 20);

        expect(result, isEmpty);
      });

      test('rethrows AppException from httpClient', () async {
        when(mockHttpClient.get(any)).thenThrow(
          const NetworkException(),
        );

        expect(
          () => dataSource.getTodosPaged(start: 0, limit: 20),
          throwsA(isA<NetworkException>()),
        );
      });

      test('rethrows ServerException from httpClient', () async {
        when(mockHttpClient.get(any)).thenThrow(
          const ServerException(statusCode: 500),
        );

        expect(
          () => dataSource.getTodosPaged(start: 0, limit: 20),
          throwsA(isA<ServerException>()),
        );
      });

      test('wraps non-AppException in AppException via ExceptionHandler', () async {
        when(mockHttpClient.get(any)).thenThrow(FormatException('bad json'));

        expect(
          () => dataSource.getTodosPaged(start: 0, limit: 20),
          throwsA(isA<AppException>()),
        );
      });

      test('maps each JSON item to TodoEntity via TodoModel', () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => [
            {'userId': 5, 'id': 99, 'title': 'Custom todo', 'completed': true},
          ],
        );

        final result = await dataSource.getTodosPaged(start: 0, limit: 20);

        expect(result.length, 1);
        expect(result[0].userId, 5);
        expect(result[0].id, 99);
        expect(result[0].title, 'Custom todo');
        expect(result[0].completed, true);
      });
    });
  });
}
