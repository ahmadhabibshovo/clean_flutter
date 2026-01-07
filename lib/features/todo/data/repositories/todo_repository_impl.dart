import '../../../../core/error/failures.dart';
import '../../../../core/types/result.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';

/// Implementation of TODO repository with comprehensive error handling
///
/// This implementation:
/// - Catches all exceptions from data sources
/// - Maps exceptions to appropriate failures
/// - Returns type-safe Result objects
/// - Ensures the domain layer never sees exceptions
class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<Result<List<TodoEntity>>> getTodos() async {
    try {
      final models = await localDataSource.getTodos();
      final entities = models.map((model) => model.toEntity()).toList();
      return Result.success(entities);
    } on TodoNotFoundException catch (e) {
      return Result.failure(
        NotFoundFailure(
          message: e.message,
          resourceType: 'Todo',
          resourceId: e.todoId,
        ),
      );
    } catch (e, stackTrace) {
      return Result.failure(UnexpectedFailure.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<TodoEntity>> getTodoById(String id) async {
    try {
      final model = await localDataSource.getTodoById(id);
      if (model == null) {
        return Result.failure(
          NotFoundFailure(
            message: 'Todo not found',
            resourceType: 'Todo',
            resourceId: id,
          ),
        );
      }
      return Result.success(model.toEntity());
    } on TodoNotFoundException catch (e) {
      return Result.failure(
        NotFoundFailure(
          message: e.message,
          resourceType: 'Todo',
          resourceId: e.todoId,
        ),
      );
    } catch (e, stackTrace) {
      return Result.failure(UnexpectedFailure.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<TodoEntity>> addTodo({
    required String title,
    String? description,
    TodoPriority priority = TodoPriority.medium,
    DateTime? dueDate,
  }) async {
    try {
      // Validate title
      if (title.trim().isEmpty) {
        return Result.failure(
          const ValidationFailure(
            message: 'Title cannot be empty',
            fieldErrors: {'title': 'Required field'},
          ),
        );
      }

      final model = await localDataSource.addTodo(
        title.trim(),
        description?.trim() ?? '',
      );
      return Result.success(model.toEntity());
    } catch (e, stackTrace) {
      return Result.failure(UnexpectedFailure.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<TodoEntity>> updateTodo({
    required String id,
    String? title,
    String? description,
    TodoPriority? priority,
    DateTime? dueDate,
  }) async {
    try {
      // Validate title if provided
      if (title != null && title.trim().isEmpty) {
        return Result.failure(
          const ValidationFailure(
            message: 'Title cannot be empty',
            fieldErrors: {'title': 'Required field'},
          ),
        );
      }

      final model = await localDataSource.updateTodo(
        id,
        title?.trim() ?? '',
        description?.trim() ?? '',
      );
      return Result.success(model.toEntity());
    } on TodoNotFoundException catch (e) {
      return Result.failure(
        NotFoundFailure(
          message: e.message,
          resourceType: 'Todo',
          resourceId: e.todoId,
        ),
      );
    } catch (e, stackTrace) {
      return Result.failure(UnexpectedFailure.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<void>> deleteTodo(String id) async {
    try {
      await localDataSource.deleteTodo(id);
      return Result.success(null);
    } on TodoNotFoundException catch (e) {
      return Result.failure(
        NotFoundFailure(
          message: e.message,
          resourceType: 'Todo',
          resourceId: e.todoId,
        ),
      );
    } catch (e, stackTrace) {
      return Result.failure(UnexpectedFailure.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<TodoEntity>> toggleTodo(String id) async {
    try {
      final model = await localDataSource.toggleTodo(id);
      return Result.success(model.toEntity());
    } on TodoNotFoundException catch (e) {
      return Result.failure(
        NotFoundFailure(
          message: e.message,
          resourceType: 'Todo',
          resourceId: e.todoId,
        ),
      );
    } catch (e, stackTrace) {
      return Result.failure(UnexpectedFailure.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<int>> deleteCompletedTodos() async {
    try {
      final count = await localDataSource.deleteCompletedTodos();
      return Result.success(count);
    } catch (e, stackTrace) {
      return Result.failure(UnexpectedFailure.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<List<TodoEntity>>> getTodosByStatus({
    required bool completed,
  }) async {
    try {
      final models = await localDataSource.getTodosByStatus(completed);
      final entities = models.map((model) => model.toEntity()).toList();
      return Result.success(entities);
    } catch (e, stackTrace) {
      return Result.failure(UnexpectedFailure.fromException(e, stackTrace));
    }
  }
}
