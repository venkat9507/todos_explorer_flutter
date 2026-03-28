import 'package:flutter_interview_app/features/todos/domain/entities/todo_entity.dart';

/// Shared test data for todo feature tests.
class TestData {
  TestData._();

  static const todoJson1 = {
    'userId': 1,
    'id': 1,
    'title': 'Buy groceries',
    'completed': false,
  };

  static const todoJson2 = {
    'userId': 1,
    'id': 2,
    'title': 'Walk the dog',
    'completed': true,
  };

  static const todoJson3 = {
    'userId': 2,
    'id': 3,
    'title': 'Clean house',
    'completed': false,
  };

  static const todoEntity1 = TodoEntity(
    userId: 1,
    id: 1,
    title: 'Buy groceries',
    completed: false,
    isFavorite: false,
  );

  static const todoEntity2 = TodoEntity(
    userId: 1,
    id: 2,
    title: 'Walk the dog',
    completed: true,
    isFavorite: false,
  );

  static const todoEntity3 = TodoEntity(
    userId: 2,
    id: 3,
    title: 'Clean house',
    completed: false,
    isFavorite: false,
  );

  static List<TodoEntity> get sampleTodos => [
        todoEntity1,
        todoEntity2,
        todoEntity3,
      ];

  static List<Map<String, dynamic>> get sampleJsonList => [
        todoJson1,
        todoJson2,
        todoJson3,
      ];

  /// Generates a list of N todo entities for pagination tests.
  static List<TodoEntity> generateTodos(int count, {int startId = 1}) {
    return List.generate(
      count,
      (i) => TodoEntity(
        userId: (i % 5) + 1,
        id: startId + i,
        title: 'Todo ${startId + i}',
        completed: i.isEven,
      ),
    );
  }
}
