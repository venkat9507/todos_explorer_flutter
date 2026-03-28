// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodoEntity {
  int get userId;
  int get id;
  String get title;
  bool get completed;
  bool get isFavorite;

  /// Create a copy of TodoEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TodoEntityCopyWith<TodoEntity> get copyWith =>
      _$TodoEntityCopyWithImpl<TodoEntity>(this as TodoEntity, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TodoEntity &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, id, title, completed, isFavorite);

  @override
  String toString() {
    return 'TodoEntity(userId: $userId, id: $id, title: $title, completed: $completed, isFavorite: $isFavorite)';
  }
}

/// @nodoc
abstract mixin class $TodoEntityCopyWith<$Res> {
  factory $TodoEntityCopyWith(
          TodoEntity value, $Res Function(TodoEntity) _then) =
      _$TodoEntityCopyWithImpl;
  @useResult
  $Res call(
      {int userId, int id, String title, bool completed, bool isFavorite});
}

/// @nodoc
class _$TodoEntityCopyWithImpl<$Res> implements $TodoEntityCopyWith<$Res> {
  _$TodoEntityCopyWithImpl(this._self, this._then);

  final TodoEntity _self;
  final $Res Function(TodoEntity) _then;

  /// Create a copy of TodoEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? id = null,
    Object? title = null,
    Object? completed = null,
    Object? isFavorite = null,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _self.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _TodoEntity implements TodoEntity {
  const _TodoEntity(
      {this.userId = 0,
      this.id = 0,
      this.title = '',
      this.completed = false,
      this.isFavorite = false});

  @override
  @JsonKey()
  final int userId;
  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final bool completed;
  @override
  @JsonKey()
  final bool isFavorite;

  /// Create a copy of TodoEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TodoEntityCopyWith<_TodoEntity> get copyWith =>
      __$TodoEntityCopyWithImpl<_TodoEntity>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TodoEntity &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, id, title, completed, isFavorite);

  @override
  String toString() {
    return 'TodoEntity(userId: $userId, id: $id, title: $title, completed: $completed, isFavorite: $isFavorite)';
  }
}

/// @nodoc
abstract mixin class _$TodoEntityCopyWith<$Res>
    implements $TodoEntityCopyWith<$Res> {
  factory _$TodoEntityCopyWith(
          _TodoEntity value, $Res Function(_TodoEntity) _then) =
      __$TodoEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int userId, int id, String title, bool completed, bool isFavorite});
}

/// @nodoc
class __$TodoEntityCopyWithImpl<$Res> implements _$TodoEntityCopyWith<$Res> {
  __$TodoEntityCopyWithImpl(this._self, this._then);

  final _TodoEntity _self;
  final $Res Function(_TodoEntity) _then;

  /// Create a copy of TodoEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? id = null,
    Object? title = null,
    Object? completed = null,
    Object? isFavorite = null,
  }) {
    return _then(_TodoEntity(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _self.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
