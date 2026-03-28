import '../../../../core/core.dart' show AppConstants, AppException, ExceptionHandler, AppHttpClient;
import '../../domain/datasources/todo_remote_data_source.dart'
    show TodoRemoteDataSource;
import '../../domain/entities/todo_entity.dart' show TodoEntity;
import '../models/todo_model.dart' show TodoModel;

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final AppHttpClient _httpClient;

  TodoRemoteDataSourceImpl({required AppHttpClient httpClient})
      : _httpClient = httpClient;

  @override
  Future<List<TodoEntity>> getTodosPaged({
    required int start,
    required int limit,
  }) async {
    try {
      final url = '${AppConstants.todosBaseUrl}?_start=$start&_limit=$limit';

      final data = await _httpClient.get(url);
      final todos = (data as List<dynamic>)
          .map((json) =>
              TodoModel.fromJson(json as Map<String, dynamic>).toEntity())
          .toList();

      return todos;
    } on AppException {
      rethrow;
    } catch (e, st) {
      throw ExceptionHandler.handleException(e, st);
    }
  }
}
