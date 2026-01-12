import 'package:flutter/foundation.dart';

import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/toggle_todo_usecase.dart';
import '../../domain/usecases/update_todo_usecase.dart';

/// Provider class for TODO state management
class TodoProvider with ChangeNotifier {
  final GetTodosUseCase getTodosUseCase;
  final AddTodoUseCase addTodoUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;
  final ToggleTodoUseCase toggleTodoUseCase;

  List<TodoEntity> _todos = [];
  bool _isLoading = false;
  String? _error;

  TodoProvider({
    required this.getTodosUseCase,
    required this.addTodoUseCase,
    required this.updateTodoUseCase,
    required this.deleteTodoUseCase,
    required this.toggleTodoUseCase,
  });

  // Getters
  List<TodoEntity> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get completedCount => _todos.where((t) => t.isCompleted).length;
  int get totalCount => _todos.length;

  /// Initialize todos
  Future<void> initTodos() async {
    _setLoading(true);
    try {
      _todos = await getTodosUseCase();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Add a new todo
  Future<void> addTodo(String title, String description) async {
    _setLoading(true);
    try {
      final newTodo = await addTodoUseCase(title, description);
      _todos.add(newTodo);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Update a todo
  Future<void> updateTodo(String id, String title, String description) async {
    _setLoading(true);
    try {
      final updatedTodo = await updateTodoUseCase(id, title, description);
      final index = _todos.indexWhere((t) => t.id == id);
      if (index != -1) {
        _todos[index] = updatedTodo;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    _setLoading(true);
    try {
      await deleteTodoUseCase(id);
      _todos.removeWhere((t) => t.id == id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle todo completion
  Future<void> toggleTodo(String id) async {
    try {
      final updatedTodo = await toggleTodoUseCase(id);
      final index = _todos.indexWhere((t) => t.id == id);
      if (index != -1) {
        _todos[index] = updatedTodo;
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
