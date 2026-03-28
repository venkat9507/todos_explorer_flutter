import 'package:mockito/annotations.dart';
import 'package:flutter_interview_app/core/network/http_client.dart';
import 'package:flutter_interview_app/features/todos/domain/datasources/todo_remote_data_source.dart';
import 'package:flutter_interview_app/features/todos/domain/repositories/todo_repository.dart';

@GenerateMocks([
  AppHttpClient,
  TodoRemoteDataSource,
  TodoRepository,
])
void main() {}
