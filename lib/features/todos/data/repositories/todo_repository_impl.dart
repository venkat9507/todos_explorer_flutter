import '../../../../core/core.dart' show AppLogger;
import '../../domain/datasources/todo_remote_data_source.dart'
    show TodoRemoteDataSource;
import '../../domain/entities/todo_entity.dart' show TodoEntity;
import '../../domain/repositories/todo_repository.dart' show TodoRepository;

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource _remoteDataSource;

  TodoRepositoryImpl({required TodoRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<TodoEntity>> getTodosPaged({
    required int start,
    required int limit,
  }) async {
    try {
      return await _remoteDataSource.getTodosPaged(
          start: start, limit: limit);
    } catch (e, st) {
      AppLogger.error(
          title: 'TodoRepository',
          message: 'Error in getTodosPaged',
          exception: e,
          stackTrace: st);
      rethrow;
    }
  }
}
