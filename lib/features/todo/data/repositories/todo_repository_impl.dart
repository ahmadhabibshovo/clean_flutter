import '../../../../core/errors/failures.dart';
import '../../../../core/types/result.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../datasources/todo_remote_datasource.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;
  final TodoRemoteDataSource remoteDataSource;

  TodoRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Result<List<TodoEntity>>> getTodos() async {
    try {
      // Prefer remote (even though it is offline-mock) to simulate enterprise sync.
      final remoteTodos = await remoteDataSource.fetchTodos();
      await localDataSource.cacheTodos(remoteTodos);
      return ResultFactories.success(
        remoteTodos.map((m) => m.toEntity()).toList(),
      );
    } on MockApiException catch (e) {
      // Fallback to local cache
      try {
        final localTodos = await localDataSource.getTodos();
        return ResultFactories.success(
          localTodos.map((m) => m.toEntity()).toList(),
        );
      } catch (cacheError) {
        return ResultFactories.failure(ServerFailure(message: e.message));
      }
    } catch (e) {
      return ResultFactories.failure(UnexpectedFailure.fromException(e));
    }
  }

  @override
  Future<Result<TodoEntity>> addTodo({
    required String title,
    String? description,
  }) async {
    if (title.trim().isEmpty) {
      return ResultFactories.failure(
        const ValidationFailure(
          message: 'Title cannot be empty',
          fieldErrors: {'title': 'Required'},
        ),
      );
    }

    try {
      final model = await remoteDataSource.addTodo(
        title: title.trim(),
        description: (description ?? '').trim(),
      );

      // Also cache locally for offline-first reads.
      final current = await localDataSource.getTodos();
      await localDataSource.cacheTodos([...current, model]);

      return ResultFactories.success(model.toEntity());
    } on MockApiException {
      // If remote fails, write locally (offline mode)
      try {
        final local = await localDataSource.addTodo(
          title: title.trim(),
          description: (description ?? '').trim(),
        );
        return ResultFactories.success(local.toEntity());
      } catch (cacheError) {
        return ResultFactories.failure(
          CacheFailure(message: 'Failed to save locally'),
        );
      }
    } catch (e) {
      return ResultFactories.failure(UnexpectedFailure.fromException(e));
    }
  }
}
