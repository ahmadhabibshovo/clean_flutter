import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/todo/data/datasources/todo_local_datasource.dart';
import '../../features/todo/data/datasources/todo_remote_datasource.dart';

/// Global DI (Riverpod providers)
///
/// In a bigger enterprise codebase you’d typically split this by feature
/// and keep shared infra here.
final todoLocalDataSourceProvider = Provider<TodoLocalDataSource>((ref) {
  return TodoLocalDataSourceInMemory();
});

final todoRemoteDataSourceProvider = Provider<TodoRemoteDataSource>((ref) {
  return TodoRemoteDataSourceMock(latency: Duration.zero);
});
