// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todos_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodosState {
  List<TodoEntity> get todos;
  bool get isLoading;
  bool get isLoadingMore;
  String? get error;
  bool get hasMore;
  int get offset;
  TodoFilter get filter;
  TodoSort get sort;
  String get searchQuery;
  bool get searchAsFilter;

  /// Create a copy of TodosState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TodosStateCopyWith<TodosState> get copyWith =>
      _$TodosStateCopyWithImpl<TodosState>(this as TodosState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TodosState &&
            const DeepCollectionEquality().equals(other.todos, todos) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.searchAsFilter, searchAsFilter) ||
                other.searchAsFilter == searchAsFilter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(todos),
      isLoading,
      isLoadingMore,
      error,
      hasMore,
      offset,
      filter,
      sort,
      searchQuery,
      searchAsFilter);

  @override
  String toString() {
    return 'TodosState(todos: $todos, isLoading: $isLoading, isLoadingMore: $isLoadingMore, error: $error, hasMore: $hasMore, offset: $offset, filter: $filter, sort: $sort, searchQuery: $searchQuery, searchAsFilter: $searchAsFilter)';
  }
}

/// @nodoc
abstract mixin class $TodosStateCopyWith<$Res> {
  factory $TodosStateCopyWith(
          TodosState value, $Res Function(TodosState) _then) =
      _$TodosStateCopyWithImpl;
  @useResult
  $Res call(
      {List<TodoEntity> todos,
      bool isLoading,
      bool isLoadingMore,
      String? error,
      bool hasMore,
      int offset,
      TodoFilter filter,
      TodoSort sort,
      String searchQuery,
      bool searchAsFilter});
}

/// @nodoc
class _$TodosStateCopyWithImpl<$Res> implements $TodosStateCopyWith<$Res> {
  _$TodosStateCopyWithImpl(this._self, this._then);

  final TodosState _self;
  final $Res Function(TodosState) _then;

  /// Create a copy of TodosState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todos = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? error = freezed,
    Object? hasMore = null,
    Object? offset = null,
    Object? filter = null,
    Object? sort = null,
    Object? searchQuery = null,
    Object? searchAsFilter = null,
  }) {
    return _then(_self.copyWith(
      todos: null == todos
          ? _self.todos
          : todos // ignore: cast_nullable_to_non_nullable
              as List<TodoEntity>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _self.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      offset: null == offset
          ? _self.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      filter: null == filter
          ? _self.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as TodoFilter,
      sort: null == sort
          ? _self.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as TodoSort,
      searchQuery: null == searchQuery
          ? _self.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      searchAsFilter: null == searchAsFilter
          ? _self.searchAsFilter
          : searchAsFilter // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _TodosState extends TodosState {
  const _TodosState(
      {final List<TodoEntity> todos = const [],
      this.isLoading = true,
      this.isLoadingMore = false,
      this.error,
      this.hasMore = true,
      this.offset = 0,
      this.filter = TodoFilter.all,
      this.sort = TodoSort.titleAZ,
      this.searchQuery = '',
      this.searchAsFilter = false})
      : _todos = todos,
        super._();

  final List<TodoEntity> _todos;
  @override
  @JsonKey()
  List<TodoEntity> get todos {
    if (_todos is EqualUnmodifiableListView) return _todos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_todos);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  final String? error;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final int offset;
  @override
  @JsonKey()
  final TodoFilter filter;
  @override
  @JsonKey()
  final TodoSort sort;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final bool searchAsFilter;

  /// Create a copy of TodosState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TodosStateCopyWith<_TodosState> get copyWith =>
      __$TodosStateCopyWithImpl<_TodosState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TodosState &&
            const DeepCollectionEquality().equals(other._todos, _todos) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.sort, sort) || other.sort == sort) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.searchAsFilter, searchAsFilter) ||
                other.searchAsFilter == searchAsFilter));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_todos),
      isLoading,
      isLoadingMore,
      error,
      hasMore,
      offset,
      filter,
      sort,
      searchQuery,
      searchAsFilter);

  @override
  String toString() {
    return 'TodosState(todos: $todos, isLoading: $isLoading, isLoadingMore: $isLoadingMore, error: $error, hasMore: $hasMore, offset: $offset, filter: $filter, sort: $sort, searchQuery: $searchQuery, searchAsFilter: $searchAsFilter)';
  }
}

/// @nodoc
abstract mixin class _$TodosStateCopyWith<$Res>
    implements $TodosStateCopyWith<$Res> {
  factory _$TodosStateCopyWith(
          _TodosState value, $Res Function(_TodosState) _then) =
      __$TodosStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<TodoEntity> todos,
      bool isLoading,
      bool isLoadingMore,
      String? error,
      bool hasMore,
      int offset,
      TodoFilter filter,
      TodoSort sort,
      String searchQuery,
      bool searchAsFilter});
}

/// @nodoc
class __$TodosStateCopyWithImpl<$Res> implements _$TodosStateCopyWith<$Res> {
  __$TodosStateCopyWithImpl(this._self, this._then);

  final _TodosState _self;
  final $Res Function(_TodosState) _then;

  /// Create a copy of TodosState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? todos = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? error = freezed,
    Object? hasMore = null,
    Object? offset = null,
    Object? filter = null,
    Object? sort = null,
    Object? searchQuery = null,
    Object? searchAsFilter = null,
  }) {
    return _then(_TodosState(
      todos: null == todos
          ? _self._todos
          : todos // ignore: cast_nullable_to_non_nullable
              as List<TodoEntity>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _self.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      offset: null == offset
          ? _self.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      filter: null == filter
          ? _self.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as TodoFilter,
      sort: null == sort
          ? _self.sort
          : sort // ignore: cast_nullable_to_non_nullable
              as TodoSort,
      searchQuery: null == searchQuery
          ? _self.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      searchAsFilter: null == searchAsFilter
          ? _self.searchAsFilter
          : searchAsFilter // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
