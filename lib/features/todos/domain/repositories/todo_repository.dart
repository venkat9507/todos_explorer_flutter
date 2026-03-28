import '../entities/todo_entity.dart' show TodoEntity;

abstract interface class TodoRepository {
  /// Fetches a page of todos.
  /// [start] — offset, [limit] — page size.
  Future<List<TodoEntity>> getTodosPaged({
    required int start,
    required int limit,
  });
}
