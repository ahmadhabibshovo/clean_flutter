import '../entities/todo_entity.dart';

/// Abstract repository for TODO operations
abstract class TodoRepository {
  /// Get all todos
  Future<List<TodoEntity>> getTodos();

  /// Add a new todo
  Future<TodoEntity> addTodo(String title, String description);

  /// Update an existing todo
  Future<TodoEntity> updateTodo(String id, String title, String description);

  /// Delete a todo
  Future<void> deleteTodo(String id);

  /// Toggle todo completion status
  Future<TodoEntity> toggleTodo(String id);
}
