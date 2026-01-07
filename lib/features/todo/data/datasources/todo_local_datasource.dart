import '../models/todo_model.dart';

/// Abstract local data source for TODO
abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> addTodo(String title, String description);
  Future<TodoModel> updateTodo(String id, String title, String description);
  Future<void> deleteTodo(String id);
  Future<TodoModel> toggleTodo(String id);
}

/// Implementation of local data source
class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  static final List<TodoModel> _todos = [];

  @override
  Future<List<TodoModel>> getTodos() async {
    return _todos;
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
    if (index != -1) {
      final updatedTodo = _todos[index].copyWith(
        title: title,
        description: description,
      );
      _todos[index] = updatedTodo;
      return updatedTodo;
    }
    throw Exception('TODO not found');
  }

  @override
  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
  }

  @override
  Future<TodoModel> toggleTodo(String id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final updatedTodo = _todos[index].copyWith(
        isCompleted: !_todos[index].isCompleted,
      );
      _todos[index] = updatedTodo;
      return updatedTodo;
    }
    throw Exception('TODO not found');
  }
}
