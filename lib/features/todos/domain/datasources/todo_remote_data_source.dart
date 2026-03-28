import '../entities/todo_entity.dart' show TodoEntity;

abstract interface class TodoRemoteDataSource {
  /// Fetches a page of todos using offset-based pagination.
  /// [start] — offset (skip N items), [limit] — max items to return.
  Future<List<TodoEntity>> getTodosPaged({
    required int start,
    required int limit,
  });
}
