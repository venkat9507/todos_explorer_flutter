import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/todo_entity.dart' show TodoEntity;

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
abstract class TodoModel with _$TodoModel {
  const TodoModel._();

  const factory TodoModel({
    @Default(0) int userId,
    @Default(0) int id,
    @Default('') String title,
    @Default(false) bool completed,
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  TodoEntity toEntity() => TodoEntity(
        userId: userId,
        id: id,
        title: title,
        completed: completed,
        isFavorite: false,
      );
}
