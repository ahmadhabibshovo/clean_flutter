import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../datasources/todo_remote_datasource.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;
  final TodoRemoteDataSource remoteDataSource;

  TodoRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<TodoEntity>>> getTodos() async {
    try {
      // Prefer remote (even though it is offline-mock) to simulate enterprise sync.
      final remoteTodos = await remoteDataSource.fetchTodos();
      await localDataSource.cacheTodos(remoteTodos);
      return Right(remoteTodos.map((m) => m.toEntity()).toList());
    } on MockApiException catch (e) {
      // Fallback to local cache
      try {
        final localTodos = await localDataSource.getTodos();
        return Right(localTodos.map((m) => m.toEntity()).toList());
      } catch (cacheError) {
        return Left(ServerFailure(message: e.message));
      }
    } catch (e) {
      return Left(UnexpectedFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> addTodo({
    required String title,
    String? description,
  }) async {
    if (title.trim().isEmpty) {
      return const Left(
        ValidationFailure(
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

      return Right(model.toEntity());
    } on MockApiException {
      // If remote fails, write locally (offline mode)
      try {
        final local = await localDataSource.addTodo(
          title: title.trim(),
          description: (description ?? '').trim(),
        );
        return Right(local.toEntity());
      } catch (cacheError) {
        return const Left(CacheFailure(message: 'Failed to save locally'));
      }
    } catch (e) {
      return Left(UnexpectedFailure.fromException(e));
    }
  }
}
