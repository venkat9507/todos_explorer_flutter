import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_interview_app/features/todos/data/models/todo_model.dart';
import 'package:flutter_interview_app/features/todos/domain/entities/todo_entity.dart';

import '../../helpers/test_data.dart';

void main() {
  group('TodoModel', () {
    group('fromJson', () {
      test('creates model from valid JSON', () {
        final model = TodoModel.fromJson(TestData.todoJson1);

        expect(model.userId, 1);
        expect(model.id, 1);
        expect(model.title, 'Buy groceries');
        expect(model.completed, false);
      });

      test('creates completed model from JSON', () {
        final model = TodoModel.fromJson(TestData.todoJson2);

        expect(model.id, 2);
        expect(model.title, 'Walk the dog');
        expect(model.completed, true);
      });

      test('uses default values for missing fields', () {
        final model = TodoModel.fromJson(const <String, dynamic>{});

        expect(model.userId, 0);
        expect(model.id, 0);
        expect(model.title, '');
        expect(model.completed, false);
      });

      test('handles partial JSON with only some fields', () {
        final model = TodoModel.fromJson(const {
          'title': 'Partial todo',
          'completed': true,
        });

        expect(model.userId, 0);
        expect(model.id, 0);
        expect(model.title, 'Partial todo');
        expect(model.completed, true);
      });
    });

    group('toJson', () {
      test('serializes model to JSON', () {
        const model = TodoModel(
          userId: 1,
          id: 1,
          title: 'Test todo',
          completed: true,
        );

        final json = model.toJson();

        expect(json['userId'], 1);
        expect(json['id'], 1);
        expect(json['title'], 'Test todo');
        expect(json['completed'], true);
      });

      test('roundtrip fromJson -> toJson preserves data', () {
        final model = TodoModel.fromJson(TestData.todoJson1);
        final json = model.toJson();

        expect(json, TestData.todoJson1);
      });
    });

    group('toEntity', () {
      test('converts model to TodoEntity correctly', () {
        const model = TodoModel(
          userId: 1,
          id: 1,
          title: 'Buy groceries',
          completed: false,
        );

        final entity = model.toEntity();

        expect(entity, isA<TodoEntity>());
        expect(entity.userId, 1);
        expect(entity.id, 1);
        expect(entity.title, 'Buy groceries');
        expect(entity.completed, false);
      });

      test('preserves all fields when converting to entity', () {
        final model = TodoModel.fromJson(TestData.todoJson2);
        final entity = model.toEntity();

        expect(entity, TestData.todoEntity2);
      });
    });

    group('equality', () {
      test('two models with same data are equal', () {
        const model1 = TodoModel(userId: 1, id: 1, title: 'Test', completed: false);
        const model2 = TodoModel(userId: 1, id: 1, title: 'Test', completed: false);

        expect(model1, model2);
      });

      test('two models with different data are not equal', () {
        const model1 = TodoModel(userId: 1, id: 1, title: 'Test', completed: false);
        const model2 = TodoModel(userId: 1, id: 2, title: 'Test', completed: false);

        expect(model1, isNot(model2));
      });
    });
  });
}
