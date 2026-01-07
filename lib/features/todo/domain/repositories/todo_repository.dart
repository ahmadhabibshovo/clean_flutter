import '../../../../core/error/failures.dart';
import '../../../../core/types/result.dart';
import '../entities/todo_entity.dart';

/// Abstract repository for TODO operations
///
/// This defines the contract for todo data operations following
/// Repository Pattern from Clean Architecture. All operations return
/// [Result] to handle both success and failure cases type-safely.
abstract class TodoRepository {
  /// Get all todos
  ///
  /// Returns list of all todos, or appropriate failure on error.
  Future<Result<List<TodoEntity>>> getTodos();

  /// Get a single todo by [id]
  ///
  /// Returns [NotFoundFailure] if todo doesn't exist.
  Future<Result<TodoEntity>> getTodoById(String id);

  /// Add a new todo with [title] and optional [description]
  Future<Result<TodoEntity>> addTodo({
    required String title,
    String? description,
    TodoPriority priority = TodoPriority.medium,
    DateTime? dueDate,
  });

  /// Update an existing todo
  Future<Result<TodoEntity>> updateTodo({
    required String id,
    String? title,
    String? description,
    TodoPriority? priority,
    DateTime? dueDate,
  });

  /// Delete a todo by [id]
  ///
  /// Returns [NotFoundFailure] if todo doesn't exist.
  Future<Result<void>> deleteTodo(String id);

  /// Toggle todo completion status
  Future<Result<TodoEntity>> toggleTodo(String id);

  /// Delete all completed todos
  ///
  /// Returns the count of deleted todos.
  Future<Result<int>> deleteCompletedTodos();

  /// Get todos filtered by completion status
  Future<Result<List<TodoEntity>>> getTodosByStatus({required bool completed});
}
