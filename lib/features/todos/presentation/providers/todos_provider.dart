import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/core.dart' show AppConstants, TodoFilter, TodoSort, todoRepositoryProvider, AppException, AppLogger;
import '../../domain/entities/todo_entity.dart' show TodoEntity;
part 'todos_provider.freezed.dart';
part 'todos_provider.g.dart';

@freezed
abstract class TodosState with _$TodosState {
  const TodosState._();

  const factory TodosState({
    @Default([]) List<TodoEntity> todos,
    @Default(true) bool isLoading,
    @Default(false) bool isLoadingMore,
    String? error,
    @Default(true) bool hasMore,
    @Default(0) int offset,
    @Default(TodoFilter.all) TodoFilter filter,
    @Default(TodoSort.titleAZ) TodoSort sort,
    @Default('') String searchQuery,
    @Default(false) bool searchAsFilter,
  }) = _TodosState;

  /// Applies filter → search-as-filter (if on) → sort → returns display list.
  List<TodoEntity> get filteredAndSortedTodos {
    var result = List<TodoEntity>.from(todos);

    // 1. Filter by status
    switch (filter) {
      case TodoFilter.completed:
        result = result.where((t) => t.completed).toList();
      case TodoFilter.pending:
        result = result.where((t) => !t.completed).toList();
      case TodoFilter.favorites:
        result = result.where((t) => t.isFavorite).toList();
      case TodoFilter.all:
        break;
    }

    // 2. Search-as-filter (if enabled and query non-empty)
    if (searchAsFilter && searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result.where((t) => t.title.toLowerCase().contains(q)).toList();
    }

    // 3. Sort
    switch (sort) {
      case TodoSort.titleAZ:
        result.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      case TodoSort.titleZA:
        result.sort(
            (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
      case TodoSort.completedFirst:
        result.sort(
            (a, b) => (b.completed ? 1 : 0).compareTo(a.completed ? 1 : 0));
      case TodoSort.pendingFirst:
        result.sort(
            (a, b) => (a.completed ? 1 : 0).compareTo(b.completed ? 1 : 0));
      case TodoSort.idLowToHigh:
        result.sort((a, b) => a.id.compareTo(b.id));
      case TodoSort.idHighToLow:
        result.sort((a, b) => b.id.compareTo(a.id));
    }

    return result;
  }

  int get visibleCount => filteredAndSortedTodos.length;
  int get totalCount => todos.length;
}

@riverpod
class TodosNotifier extends _$TodosNotifier {
  @override
  TodosState build() {
    // Schedule fetch after state is initialized
    Future.microtask(_fetchFirstPage);
    return const TodosState();
  }

  /// Initial load — fetches first page from offset 0.
  Future<void> _fetchFirstPage() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(todoRepositoryProvider);
      final todos = await repository.getTodosPaged(
        start: 0,
        limit: AppConstants.todosPageSize,
      );
      state = state.copyWith(
        todos: todos,
        isLoading: false,
        offset: todos.length,
        hasMore: todos.length >= AppConstants.todosPageSize,
      );
    } on AppException catch (e) {
      AppLogger.error(
          title: 'TodosNotifier',
          message: 'AppException in _fetchFirstPage',
          exception: e);
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e, st) {
      AppLogger.error(
          title: 'TodosNotifier',
          message: 'Unexpected error in _fetchFirstPage',
          exception: e,
          stackTrace: st);
      state = state.copyWith(
          isLoading: false, error: AppConstants.unknownErrorMessage);
    }
  }

  /// Pull-to-refresh — resets pagination and fetches first page.
  Future<void> refresh() async {
    state =
        state.copyWith(isLoading: true, error: null, offset: 0, hasMore: true);
    try {
      final repository = ref.read(todoRepositoryProvider);
      final todos = await repository.getTodosPaged(
        start: 0,
        limit: AppConstants.todosPageSize,
      );
      state = state.copyWith(
        todos: todos,
        isLoading: false,
        offset: todos.length,
        hasMore: todos.length >= AppConstants.todosPageSize,
      );
    } on AppException catch (e) {
      AppLogger.error(
          title: 'TodosNotifier',
          message: 'AppException in refresh',
          exception: e);
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e, st) {
      AppLogger.error(
          title: 'TodosNotifier',
          message: 'Unexpected error in refresh',
          exception: e,
          stackTrace: st);
      state = state.copyWith(
          isLoading: false, error: AppConstants.unknownErrorMessage);
    }
  }

  /// Called by ScrollController when user nears the bottom.
  /// Fetches NEXT page and APPENDS to existing todos.
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true, error: null);
    try {
      final repository = ref.read(todoRepositoryProvider);
      final newTodos = await repository.getTodosPaged(
        start: state.offset,
        limit: AppConstants.todosPageSize,
      );
      state = state.copyWith(
        todos: [...state.todos, ...newTodos],
        isLoadingMore: false,
        offset: state.offset + newTodos.length,
        hasMore: newTodos.length >= AppConstants.todosPageSize,
      );
    } on AppException catch (e) {
      AppLogger.error(
          title: 'TodosNotifier',
          message: 'AppException in loadMore',
          exception: e);
      state = state.copyWith(isLoadingMore: false, error: e.message);
    } catch (e, st) {
      AppLogger.error(
          title: 'TodosNotifier',
          message: 'Unexpected error in loadMore',
          exception: e,
          stackTrace: st);
      state = state.copyWith(
          isLoadingMore: false, error: AppConstants.unknownErrorMessage);
    }
  }

  void setFilter(TodoFilter filter) {
    var currentSort = state.sort;
    // Reset conflicting sorts
    if (filter == TodoFilter.completed && currentSort == TodoSort.pendingFirst) {
      currentSort = TodoSort.titleAZ;
    } else if (filter == TodoFilter.pending && currentSort == TodoSort.completedFirst) {
      currentSort = TodoSort.titleAZ;
    }
    state = state.copyWith(filter: filter, sort: currentSort);
  }

  void setSort(TodoSort sort) {
    var currentFilter = state.filter;
    // Sync filter to match sort intent
    if (sort == TodoSort.completedFirst && currentFilter == TodoFilter.pending) {
      currentFilter = TodoFilter.completed;
    } else if (sort == TodoSort.pendingFirst && currentFilter == TodoFilter.completed) {
      currentFilter = TodoFilter.pending;
    }
    state = state.copyWith(sort: sort, filter: currentFilter);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleSearchAsFilter() {
    final newValue = !state.searchAsFilter;
    state = state.copyWith(searchAsFilter: newValue);
  }

  void toggleFavorite(int todoId) {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == todoId) {
        return todo.copyWith(isFavorite: !todo.isFavorite);
      }
      return todo;
    }).toList();
    state = state.copyWith(todos: updatedTodos);
  }
}
