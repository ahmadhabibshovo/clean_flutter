import 'package:get_storage/get_storage.dart';

import '../models/todo_model.dart';
import 'todo_local_datasource.dart';

/// GetStorage implementation of local data source
class TodoGetStorageDataSourceImpl implements TodoLocalDataSource {
  static const String _storageKey = 'todos';
  final GetStorage _storage;

  TodoGetStorageDataSourceImpl({GetStorage? storage})
    : _storage = storage ?? GetStorage();

  @override
  Future<List<TodoModel>> getTodos() async {
    await _storage.erase();
    final todos = _storage.read<List>(_storageKey) ?? [];
    return todos
        .cast<Map<String, dynamic>>()
        .map((json) => TodoModel.fromJson(json))
        .toList();
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

    final todos = await getTodos();
    todos.add(todo);
    await _storage.write(_storageKey, todos.map((t) => t.toJson()).toList());

    return todo;
  }

  @override
  Future<TodoModel> updateTodo(
    String id,
    String title,
    String description,
  ) async {
    final todos = await getTodos();
    final index = todos.indexWhere((todo) => todo.id == id);

    if (index != -1) {
      final updatedTodo = todos[index].copyWith(
        title: title,
        description: description,
      );
      todos[index] = updatedTodo;
      await _storage.write(_storageKey, todos.map((t) => t.toJson()).toList());
      return updatedTodo;
    }

    throw Exception('TODO not found');
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todos = await getTodos();
    todos.removeWhere((todo) => todo.id == id);
    await _storage.write(_storageKey, todos.map((t) => t.toJson()).toList());
  }

  @override
  Future<TodoModel> toggleTodo(String id) async {
    final todos = await getTodos();
    final index = todos.indexWhere((todo) => todo.id == id);

    if (index != -1) {
      final updatedTodo = todos[index].copyWith(
        isCompleted: !todos[index].isCompleted,
      );
      todos[index] = updatedTodo;
      await _storage.write(_storageKey, todos.map((t) => t.toJson()).toList());
      return updatedTodo;
    }

    throw Exception('TODO not found');
  }
}
