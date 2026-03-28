import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/enums.dart' show NetworkStatus;
import '../network/http_client.dart' show AppHttpClient, AppHttpClientImpl;
import '../network/network_monitor_impl.dart'
    show NetworkMonitorImpl, NetworkMonitor;
import '../../features/todos/domain/datasources/todo_remote_data_source.dart'
    show TodoRemoteDataSource;
import '../../features/todos/domain/repositories/todo_repository.dart'
    show TodoRepository;
import '../../features/todos/data/datasources/todo_remote_data_source_impl.dart'
    show TodoRemoteDataSourceImpl;
import '../../features/todos/data/repositories/todo_repository_impl.dart'
    show TodoRepositoryImpl;

part 'providers.g.dart';

@riverpod
AppHttpClient httpClient(Ref ref) => AppHttpClientImpl();

@riverpod
TodoRemoteDataSource todoRemoteDataSource(Ref ref) {
  return TodoRemoteDataSourceImpl(httpClient: ref.watch(httpClientProvider));
}

@riverpod
TodoRepository todoRepository(Ref ref) {
  return TodoRepositoryImpl(
      remoteDataSource: ref.watch(todoRemoteDataSourceProvider));
}

@riverpod
NetworkMonitor networkMonitor(Ref ref) => NetworkMonitorImpl();

@riverpod
Stream<NetworkStatus> networkStatus(Ref ref) {
  final monitor = ref.watch(networkMonitorProvider);
  return monitor.statusStream;
}
