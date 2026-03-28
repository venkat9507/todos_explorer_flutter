import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_interview_app/core/constants/app_constants.dart';
import 'package:flutter_interview_app/core/constants/enums.dart';
import 'package:flutter_interview_app/core/di/providers.dart';
import 'package:flutter_interview_app/core/exceptions/exception_handler.dart';
import 'package:flutter_interview_app/features/todos/domain/entities/todo_entity.dart';
import 'package:flutter_interview_app/features/todos/presentation/providers/todos_provider.dart';

import '../../helpers/test_mocks.mocks.dart';
import '../../helpers/test_data.dart';

void main() {
  late MockTodoRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockTodoRepository();
  });

  tearDown(() {
    container.dispose();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        todoRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  }

  /// Waits until the notifier finishes its initial load.
  Future<void> pumpUntilSettled(ProviderContainer c) async {
    final completer = Completer<void>();
    c.listen(todosNotifierProvider, (prev, next) {
      if (!next.isLoading && !completer.isCompleted) {
        completer.complete();
      }
    });
    // If already settled (edge case)
    if (!c.read(todosNotifierProvider).isLoading) return;
    await completer.future;
  }

  group('TodosNotifier', () {
    group('build (initial load)', () {
      test('fetches first page on initialization', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        final state = container.read(todosNotifierProvider);
        expect(state.isLoading, true);
        expect(state.todos, isEmpty);

        await pumpUntilSettled(container);

        final updatedState = container.read(todosNotifierProvider);
        expect(updatedState.isLoading, false);
        expect(updatedState.todos.length, 3);
        expect(updatedState.offset, 3);
        expect(updatedState.hasMore, false); // 3 < 20
      });

      test('sets hasMore true when page is full', () async {
        final fullPage = TestData.generateTodos(AppConstants.todosPageSize);
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => fullPage);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        final state = container.read(todosNotifierProvider);
        expect(state.hasMore, true);
        expect(state.offset, AppConstants.todosPageSize);
      });

      test('sets error on AppException', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => throw const NetworkException());

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        final state = container.read(todosNotifierProvider);
        expect(state.isLoading, false);
        expect(state.error, AppConstants.networkErrorMessage);
      });

      test('sets unknown error on unexpected exception', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => throw Exception('oops'));

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        final state = container.read(todosNotifierProvider);
        expect(state.isLoading, false);
        expect(state.error, AppConstants.unknownErrorMessage);
      });
    });

    group('refresh', () {
      test('resets and fetches first page', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        final refreshedTodos = [TestData.todoEntity1];
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => refreshedTodos);

        await container.read(todosNotifierProvider.notifier).refresh();

        final state = container.read(todosNotifierProvider);
        expect(state.todos.length, 1);
        expect(state.offset, 1);
        expect(state.isLoading, false);
        expect(state.hasMore, false);
      });

      test('sets error on failure during refresh', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => throw const ServerException(statusCode: 500));

        await container.read(todosNotifierProvider.notifier).refresh();

        final state = container.read(todosNotifierProvider);
        expect(state.isLoading, false);
        expect(state.error, isNotNull);
      });
    });

    group('loadMore', () {
      test('appends next page to existing todos', () async {
        final firstPage = TestData.generateTodos(AppConstants.todosPageSize);
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => firstPage);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        final secondPage = TestData.generateTodos(5, startId: 21);
        when(mockRepository.getTodosPaged(
          start: AppConstants.todosPageSize,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => secondPage);

        await container.read(todosNotifierProvider.notifier).loadMore();

        final state = container.read(todosNotifierProvider);
        expect(state.todos.length, AppConstants.todosPageSize + 5);
        expect(state.offset, AppConstants.todosPageSize + 5);
        expect(state.hasMore, false); // 5 < pageSize
        expect(state.isLoadingMore, false);
      });

      test('does not load when hasMore is false', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        expect(container.read(todosNotifierProvider).hasMore, false);

        await container.read(todosNotifierProvider.notifier).loadMore();

        verify(mockRepository.getTodosPaged(
          start: anyNamed('start'),
          limit: anyNamed('limit'),
        )).called(1); // Only initial load
      });

      test('does not load when already loading more', () async {
        final fullPage = TestData.generateTodos(AppConstants.todosPageSize);
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => fullPage);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        final completer = Completer<List<TodoEntity>>();
        when(mockRepository.getTodosPaged(
          start: AppConstants.todosPageSize,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) => completer.future);

        final notifier = container.read(todosNotifierProvider.notifier);
        final future1 = notifier.loadMore();
        // Second call should be a no-op (isLoadingMore is true)
        final future2 = notifier.loadMore();

        completer.complete([]);
        await Future.wait([future1, future2]);

        // Only called twice total: initial + one loadMore
        verify(mockRepository.getTodosPaged(
          start: anyNamed('start'),
          limit: anyNamed('limit'),
        )).called(2);
      });

      test('sets error on failure during loadMore', () async {
        final fullPage = TestData.generateTodos(AppConstants.todosPageSize);
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => fullPage);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        when(mockRepository.getTodosPaged(
          start: AppConstants.todosPageSize,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => throw const NetworkException());

        await container.read(todosNotifierProvider.notifier).loadMore();

        final state = container.read(todosNotifierProvider);
        expect(state.isLoadingMore, false);
        expect(state.error, AppConstants.networkErrorMessage);
        expect(state.todos.length, AppConstants.todosPageSize);
      });
    });

    group('setFilter', () {
      test('updates filter in state', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        container.read(todosNotifierProvider.notifier).setFilter(TodoFilter.completed);

        expect(container.read(todosNotifierProvider).filter, TodoFilter.completed);
      });

      test('updates filter to favorites', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        container.read(todosNotifierProvider.notifier).setFilter(TodoFilter.favorites);

        expect(container.read(todosNotifierProvider).filter, TodoFilter.favorites);
      });

      test('resets sort to titleAZ when completed filter conflicts with pendingFirst sort', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        final notifier = container.read(todosNotifierProvider.notifier);
        notifier.setSort(TodoSort.pendingFirst);
        notifier.setFilter(TodoFilter.completed);

        final state = container.read(todosNotifierProvider);
        expect(state.filter, TodoFilter.completed);
        expect(state.sort, TodoSort.titleAZ);
      });

      test('resets sort to titleAZ when pending filter conflicts with completedFirst sort', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        final notifier = container.read(todosNotifierProvider.notifier);
        notifier.setSort(TodoSort.completedFirst);
        notifier.setFilter(TodoFilter.pending);

        final state = container.read(todosNotifierProvider);
        expect(state.filter, TodoFilter.pending);
        expect(state.sort, TodoSort.titleAZ);
      });
    });

    group('setSort', () {
      test('updates sort in state', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        container.read(todosNotifierProvider.notifier).setSort(TodoSort.idHighToLow);

        expect(container.read(todosNotifierProvider).sort, TodoSort.idHighToLow);
      });

      test('switches filter to pending when pendingFirst sort conflicts with completed filter', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        final notifier = container.read(todosNotifierProvider.notifier);
        notifier.setFilter(TodoFilter.completed);
        notifier.setSort(TodoSort.pendingFirst);

        final state = container.read(todosNotifierProvider);
        expect(state.sort, TodoSort.pendingFirst);
        expect(state.filter, TodoFilter.pending);
      });

      test('switches filter to completed when completedFirst sort conflicts with pending filter', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        final notifier = container.read(todosNotifierProvider.notifier);
        notifier.setFilter(TodoFilter.pending);
        notifier.setSort(TodoSort.completedFirst);

        final state = container.read(todosNotifierProvider);
        expect(state.sort, TodoSort.completedFirst);
        expect(state.filter, TodoFilter.completed);
      });
    });

    group('setSearchQuery', () {
      test('updates searchQuery in state', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        container.read(todosNotifierProvider.notifier).setSearchQuery('test');

        expect(container.read(todosNotifierProvider).searchQuery, 'test');
      });
    });

    group('toggleSearchAsFilter', () {
      test('toggles searchAsFilter from false to true', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        expect(container.read(todosNotifierProvider).searchAsFilter, false);

        container.read(todosNotifierProvider.notifier).toggleSearchAsFilter();

        expect(container.read(todosNotifierProvider).searchAsFilter, true);
      });

      test('toggles searchAsFilter from true to false', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        final notifier = container.read(todosNotifierProvider.notifier);
        notifier.toggleSearchAsFilter(); // false -> true
        notifier.toggleSearchAsFilter(); // true -> false

        expect(container.read(todosNotifierProvider).searchAsFilter, false);
      });
    });

    group('toggleFavorite', () {
      test('marks a todo as favorite', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        container.read(todosNotifierProvider.notifier).toggleFavorite(1);

        final state = container.read(todosNotifierProvider);
        final todo = state.todos.firstWhere((t) => t.id == 1);
        expect(todo.isFavorite, true);
      });

      test('unmarks a favorite todo', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        final notifier = container.read(todosNotifierProvider.notifier);
        notifier.toggleFavorite(1); // mark
        notifier.toggleFavorite(1); // unmark

        final state = container.read(todosNotifierProvider);
        final todo = state.todos.firstWhere((t) => t.id == 1);
        expect(todo.isFavorite, false);
      });

      test('does not affect other todos', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        container.read(todosNotifierProvider.notifier).toggleFavorite(1);

        final state = container.read(todosNotifierProvider);
        final otherTodos = state.todos.where((t) => t.id != 1);
        expect(otherTodos.every((t) => !t.isFavorite), true);
      });

      test('favorites filter shows only favorited todos', () async {
        when(mockRepository.getTodosPaged(
          start: 0,
          limit: AppConstants.todosPageSize,
        )).thenAnswer((_) async => TestData.sampleTodos);

        container = createContainer();
        container.read(todosNotifierProvider);
        await pumpUntilSettled(container);

        final notifier = container.read(todosNotifierProvider.notifier);
        notifier.toggleFavorite(1);
        notifier.toggleFavorite(3);
        notifier.setFilter(TodoFilter.favorites);

        final state = container.read(todosNotifierProvider);
        expect(state.filteredAndSortedTodos.length, 2);
        expect(state.filteredAndSortedTodos.every((t) => t.isFavorite), true);
      });
    });
  });
}
