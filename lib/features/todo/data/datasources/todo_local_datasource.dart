import '../../domain/entities/todo_entity.dart';
import '../models/todo_model.dart';

/// Abstract local data source for TODO operations
///
/// This interface defines the contract for local data operations.
/// Following the Dependency Inversion Principle, the repository
/// depends on this abstraction, not concrete implementations.
///
/// This allows for:
/// - Easy testing with mock implementations
/// - Swapping storage mechanisms (memory, SQLite, Hive, etc.)
/// - Clear separation between data access and business logic
abstract class TodoLocalDataSource {
  /// Retrieve all todos from local storage
  Future<List<TodoModel>> getTodos();

  /// Retrieve a single todo by ID
  Future<TodoModel?> getTodoById(String id);

  /// Add a new todo to local storage
  Future<TodoModel> addTodo(String title, String description);

  /// Update an existing todo
  Future<TodoModel> updateTodo(String id, String title, String description);

  /// Delete a todo from local storage
  Future<void> deleteTodo(String id);

  /// Toggle the completion status of a todo
  Future<TodoModel> toggleTodo(String id);

  /// Delete all completed todos
  Future<int> deleteCompletedTodos();

  /// Get todos filtered by completion status
  Future<List<TodoModel>> getTodosByStatus(bool isCompleted);
}

/// In-memory implementation of local data source
///
/// This implementation uses an in-memory list for storage.
/// In a production app, you would replace this with SQLite, Hive,
/// SharedPreferences, or another persistent storage mechanism.
///
/// The key benefit of this architecture is that the storage
/// implementation can be changed without affecting other layers.
class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  /// Static storage to persist across instances
  /// In production, this would be a database or file storage
  static final List<TodoModel> _todos = [];

  @override
  Future<List<TodoModel>> getTodos() async {
    // Simulate async operation (would be real in production)
    await Future.delayed(const Duration(milliseconds: 10));
    // Return a copy to prevent external modification
    return List.unmodifiable(_todos);
  }

  @override
  Future<TodoModel?> getTodoById(String id) async {
    try {
      return _todos.firstWhere((todo) => todo.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<TodoModel> addTodo(String title, String description) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final todo = TodoModel(
      id: id,
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
      priority: TodoPriority.medium,
    );
    _todos.add(todo);
    return todo;
  }

  @override
  Future<TodoModel> updateTodo(
    String id,
    String title,
    String description,
  ) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      throw TodoNotFoundException(id);
    }

    final updatedTodo = _todos[index].copyWith(
      title: title,
      description: description,
      updatedAt: DateTime.now(),
    );
    _todos[index] = updatedTodo;
    return updatedTodo;
  }

  @override
  Future<void> deleteTodo(String id) async {
    final existsBefore = _todos.any((todo) => todo.id == id);
    if (!existsBefore) {
      throw TodoNotFoundException(id);
    }
    _todos.removeWhere((todo) => todo.id == id);
  }

  @override
  Future<TodoModel> toggleTodo(String id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      throw TodoNotFoundException(id);
    }

    final updatedTodo = _todos[index].copyWith(
      isCompleted: !_todos[index].isCompleted,
      updatedAt: DateTime.now(),
    );
    _todos[index] = updatedTodo;
    return updatedTodo;
  }

  @override
  Future<int> deleteCompletedTodos() async {
    final initialCount = _todos.length;
    _todos.removeWhere((todo) => todo.isCompleted);
    return initialCount - _todos.length;
  }

  @override
  Future<List<TodoModel>> getTodosByStatus(bool isCompleted) async {
    return _todos.where((todo) => todo.isCompleted == isCompleted).toList();
  }
}

/// Custom exception for todo not found scenarios
///
/// Domain-specific exceptions provide better error handling
/// and can be converted to appropriate Failures in the repository
class TodoNotFoundException implements Exception {
  final String todoId;
  final String message;

  TodoNotFoundException(this.todoId)
    : message = 'TODO with id $todoId not found';

  @override
  String toString() => 'TodoNotFoundException: $message';
}
