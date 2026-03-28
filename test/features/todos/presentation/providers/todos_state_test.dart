import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_app/features/todos/presentation/providers/todos_provider.dart';
import 'package:flutter_interview_app/features/todos/domain/entities/todo_entity.dart';
import 'package:flutter_interview_app/core/constants/enums.dart';

void main() {
  group('TodosState', () {
    group('defaults', () {
      test('has correct initial values', () {
        const state = TodosState();

        expect(state.todos, isEmpty);
        expect(state.isLoading, true);
        expect(state.isLoadingMore, false);
        expect(state.error, isNull);
        expect(state.hasMore, true);
        expect(state.offset, 0);
        expect(state.filter, TodoFilter.all);
        expect(state.sort, TodoSort.titleAZ);
        expect(state.searchQuery, '');
        expect(state.searchAsFilter, false);
      });
    });

    group('totalCount', () {
      test('returns total number of todos', () {
        const state = TodosState(todos: [
          TodoEntity(id: 1, title: 'A'),
          TodoEntity(id: 2, title: 'B'),
        ]);

        expect(state.totalCount, 2);
      });

      test('returns 0 when no todos', () {
        const state = TodosState();
        expect(state.totalCount, 0);
      });
    });

    group('filteredAndSortedTodos', () {
      const todos = [
        TodoEntity(id: 1, userId: 1, title: 'Buy milk', completed: false),
        TodoEntity(id: 2, userId: 1, title: 'Walk dog', completed: true),
        TodoEntity(id: 3, userId: 2, title: 'Clean room', completed: false),
        TodoEntity(id: 4, userId: 2, title: 'Do laundry', completed: true),
      ];

      group('filter', () {
        test('returns all todos when filter is all', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            filter: TodoFilter.all,
          );

          expect(state.filteredAndSortedTodos.length, 4);
        });

        test('returns only completed todos when filter is completed', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            filter: TodoFilter.completed,
          );

          final result = state.filteredAndSortedTodos;
          expect(result.every((t) => t.completed), true);
          expect(result.length, 2);
        });

        test('returns only pending todos when filter is pending', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            filter: TodoFilter.pending,
          );

          final result = state.filteredAndSortedTodos;
          expect(result.every((t) => !t.completed), true);
          expect(result.length, 2);
        });
      });

      group('search as filter', () {
        test('does not filter by search when searchAsFilter is false', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            searchQuery: 'milk',
            searchAsFilter: false,
          );

          expect(state.filteredAndSortedTodos.length, 4);
        });

        test('filters by search when searchAsFilter is true', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            searchQuery: 'milk',
            searchAsFilter: true,
          );

          final result = state.filteredAndSortedTodos;
          expect(result.length, 1);
          expect(result[0].title, 'Buy milk');
        });

        test('search is case-insensitive', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            searchQuery: 'CLEAN',
            searchAsFilter: true,
          );

          final result = state.filteredAndSortedTodos;
          expect(result.length, 1);
          expect(result[0].title, 'Clean room');
        });

        test('does not filter when searchQuery is empty even if searchAsFilter is true', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            searchQuery: '',
            searchAsFilter: true,
          );

          expect(state.filteredAndSortedTodos.length, 4);
        });

        test('combines status filter with search filter', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            filter: TodoFilter.completed,
            searchQuery: 'dog',
            searchAsFilter: true,
          );

          final result = state.filteredAndSortedTodos;
          expect(result.length, 1);
          expect(result[0].title, 'Walk dog');
          expect(result[0].completed, true);
        });

        test('returns empty when search matches but filter excludes', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            filter: TodoFilter.completed,
            searchQuery: 'milk',
            searchAsFilter: true,
          );

          // 'Buy milk' is pending, so completed filter removes it
          expect(state.filteredAndSortedTodos, isEmpty);
        });
      });

      group('favorites filter', () {
        const todosWithFavorites = [
          TodoEntity(id: 1, title: 'Buy milk', completed: false, isFavorite: true),
          TodoEntity(id: 2, title: 'Walk dog', completed: true, isFavorite: false),
          TodoEntity(id: 3, title: 'Clean room', completed: false, isFavorite: true),
          TodoEntity(id: 4, title: 'Do laundry', completed: true, isFavorite: false),
        ];

        test('returns only favorite todos when filter is favorites', () {
          const state = TodosState(
            todos: todosWithFavorites,
            isLoading: false,
            filter: TodoFilter.favorites,
          );

          final result = state.filteredAndSortedTodos;
          expect(result.length, 2);
          expect(result.every((t) => t.isFavorite), true);
        });

        test('returns all todos including favorites when filter is all', () {
          const state = TodosState(
            todos: todosWithFavorites,
            isLoading: false,
            filter: TodoFilter.all,
          );

          expect(state.filteredAndSortedTodos.length, 4);
        });

        test('favorites filter combines with search-as-filter', () {
          const state = TodosState(
            todos: todosWithFavorites,
            isLoading: false,
            filter: TodoFilter.favorites,
            searchQuery: 'milk',
            searchAsFilter: true,
          );

          final result = state.filteredAndSortedTodos;
          expect(result.length, 1);
          expect(result[0].title, 'Buy milk');
          expect(result[0].isFavorite, true);
        });

        test('returns empty when no todos are favorited', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            filter: TodoFilter.favorites,
          );

          expect(state.filteredAndSortedTodos, isEmpty);
        });
      });

      group('sort', () {
        test('sorts by title A-Z', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            sort: TodoSort.titleAZ,
          );

          final result = state.filteredAndSortedTodos;
          expect(result[0].title, 'Buy milk');
          expect(result[1].title, 'Clean room');
          expect(result[2].title, 'Do laundry');
          expect(result[3].title, 'Walk dog');
        });

        test('sorts by title Z-A', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            sort: TodoSort.titleZA,
          );

          final result = state.filteredAndSortedTodos;
          expect(result[0].title, 'Walk dog');
          expect(result[3].title, 'Buy milk');
        });

        test('sorts completed first', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            sort: TodoSort.completedFirst,
          );

          final result = state.filteredAndSortedTodos;
          expect(result[0].completed, true);
          expect(result[1].completed, true);
          expect(result[2].completed, false);
          expect(result[3].completed, false);
        });

        test('sorts pending first', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            sort: TodoSort.pendingFirst,
          );

          final result = state.filteredAndSortedTodos;
          expect(result[0].completed, false);
          expect(result[1].completed, false);
          expect(result[2].completed, true);
          expect(result[3].completed, true);
        });

        test('sorts by ID low to high', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            sort: TodoSort.idLowToHigh,
          );

          final result = state.filteredAndSortedTodos;
          expect(result[0].id, 1);
          expect(result[1].id, 2);
          expect(result[2].id, 3);
          expect(result[3].id, 4);
        });

        test('sorts by ID high to low', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            sort: TodoSort.idHighToLow,
          );

          final result = state.filteredAndSortedTodos;
          expect(result[0].id, 4);
          expect(result[1].id, 3);
          expect(result[2].id, 2);
          expect(result[3].id, 1);
        });
      });

      group('filter + sort combined', () {
        test('filters then sorts correctly', () {
          const state = TodosState(
            todos: todos,
            isLoading: false,
            filter: TodoFilter.pending,
            sort: TodoSort.titleZA,
          );

          final result = state.filteredAndSortedTodos;
          expect(result.length, 2);
          // Pending: 'Buy milk' and 'Clean room' sorted Z-A
          expect(result[0].title, 'Clean room');
          expect(result[1].title, 'Buy milk');
        });
      });
    });

    group('visibleCount', () {
      test('equals filteredAndSortedTodos length', () {
        const state = TodosState(
          todos: [
            TodoEntity(id: 1, title: 'A', completed: true),
            TodoEntity(id: 2, title: 'B', completed: false),
          ],
          isLoading: false,
          filter: TodoFilter.completed,
        );

        expect(state.visibleCount, 1);
      });
    });

    group('copyWith', () {
      test('creates new state with updated fields', () {
        const original = TodosState();
        final updated = original.copyWith(
          isLoading: false,
          offset: 20,
          hasMore: false,
        );

        expect(updated.isLoading, false);
        expect(updated.offset, 20);
        expect(updated.hasMore, false);
        // Unchanged fields
        expect(updated.todos, isEmpty);
        expect(updated.filter, TodoFilter.all);
      });
    });
  });
}
