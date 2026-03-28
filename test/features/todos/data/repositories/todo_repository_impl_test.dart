import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_interview_app/features/todos/data/repositories/todo_repository_impl.dart';
import 'package:flutter_interview_app/features/todos/domain/entities/todo_entity.dart';
import 'package:flutter_interview_app/core/exceptions/exception_handler.dart';

import '../../helpers/test_mocks.mocks.dart';
import '../../helpers/test_data.dart';

void main() {
  late MockTodoRemoteDataSource mockDataSource;
  late TodoRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockTodoRemoteDataSource();
    repository = TodoRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('TodoRepositoryImpl', () {
    group('getTodosPaged', () {
      test('returns list of TodoEntity from data source', () async {
        when(mockDataSource.getTodosPaged(start: 0, limit: 20))
            .thenAnswer((_) async => TestData.sampleTodos);

        final result = await repository.getTodosPaged(start: 0, limit: 20);

        expect(result, isA<List<TodoEntity>>());
        expect(result.length, 3);
        expect(result, TestData.sampleTodos);
      });

      test('delegates to remote data source with correct params', () async {
        when(mockDataSource.getTodosPaged(start: 10, limit: 5))
            .thenAnswer((_) async => []);

        await repository.getTodosPaged(start: 10, limit: 5);

        verify(mockDataSource.getTodosPaged(start: 10, limit: 5)).called(1);
      });

      test('returns empty list when data source returns empty', () async {
        when(mockDataSource.getTodosPaged(start: 0, limit: 20))
            .thenAnswer((_) async => []);

        final result = await repository.getTodosPaged(start: 0, limit: 20);

        expect(result, isEmpty);
      });

      test('rethrows NetworkException from data source', () async {
        when(mockDataSource.getTodosPaged(start: 0, limit: 20))
            .thenThrow(const NetworkException());

        expect(
          () => repository.getTodosPaged(start: 0, limit: 20),
          throwsA(isA<NetworkException>()),
        );
      });

      test('rethrows ServerException from data source', () async {
        when(mockDataSource.getTodosPaged(start: 0, limit: 20))
            .thenThrow(const ServerException(statusCode: 503));

        expect(
          () => repository.getTodosPaged(start: 0, limit: 20),
          throwsA(isA<ServerException>()),
        );
      });

      test('rethrows generic exceptions from data source', () async {
        when(mockDataSource.getTodosPaged(start: 0, limit: 20))
            .thenThrow(Exception('unexpected'));

        expect(
          () => repository.getTodosPaged(start: 0, limit: 20),
          throwsA(isA<Exception>()),
        );
      });

      test('does not catch and swallow exceptions', () async {
        when(mockDataSource.getTodosPaged(start: 0, limit: 20))
            .thenThrow(const AppTimeoutException());

        expect(
          () => repository.getTodosPaged(start: 0, limit: 20),
          throwsA(isA<AppTimeoutException>()),
        );
      });
    });
  });
}
