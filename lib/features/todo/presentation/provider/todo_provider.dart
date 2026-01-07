import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/toggle_todo_usecase.dart';
import '../../domain/usecases/update_todo_usecase.dart';

/// UI state enum for better state management
enum TodoState { initial, loading, loaded, error }

/// Provider class for TODO state management
///
/// This provider follows best practices:
/// - Uses Result pattern for error handling (no try/catch)
/// - Immutable state updates using List.from()
/// - Clear state machine (initial → loading → loaded/error)
/// - Optimistic updates with rollback capability
/// - Computed properties for filtered views
class TodoProvider with ChangeNotifier {
  final GetTodosUseCase getTodosUseCase;
  final AddTodoUseCase addTodoUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;
  final ToggleTodoUseCase toggleTodoUseCase;

  List<TodoEntity> _todos = [];
  TodoState _state = TodoState.initial;
  Failure? _failure;

  TodoProvider({
    required this.getTodosUseCase,
    required this.addTodoUseCase,
    required this.updateTodoUseCase,
    required this.deleteTodoUseCase,
    required this.toggleTodoUseCase,
  });

  // State getters
  List<TodoEntity> get todos => List.unmodifiable(_todos);
  TodoState get state => _state;
  bool get isLoading => _state == TodoState.loading;
  bool get hasError => _state == TodoState.error;
  Failure? get failure => _failure;
  String? get errorMessage => _failure?.message;

  // Computed getters
  int get totalCount => _todos.length;
  int get completedCount => _todos.where((t) => t.isCompleted).length;
  int get pendingCount => _todos.where((t) => !t.isCompleted).length;
  List<TodoEntity> get completedTodos =>
      _todos.where((t) => t.isCompleted).toList();
  List<TodoEntity> get pendingTodos =>
      _todos.where((t) => !t.isCompleted).toList();
  List<TodoEntity> get overdueTodos =>
      _todos.where((t) => t.isOverdue).toList();
  double get completionRate =>
      totalCount > 0 ? completedCount / totalCount : 0.0;

  /// Get todos by priority
  List<TodoEntity> getTodosByPriority(TodoPriority priority) {
    return _todos.where((t) => t.priority == priority).toList();
  }

  /// Initialize todos - should be called on widget initialization
  Future<void> initTodos() async {
    _setState(TodoState.loading);

    final result = await getTodosUseCase(const NoParams());

    result.fold(
      onFailure: (failure) {
        _failure = failure;
        _setState(TodoState.error);
      },
      onSuccess: (todos) {
        _todos = List.from(todos);
        _failure = null;
        _setState(TodoState.loaded);
      },
    );
  }

  /// Refresh todos from data source
  Future<void> refreshTodos() async {
    await initTodos();
  }

  /// Add a new todo
  Future<bool> addTodo({
    required String title,
    String? description,
    TodoPriority priority = TodoPriority.medium,
    DateTime? dueDate,
  }) async {
    _setState(TodoState.loading);

    final params = AddTodoParams(
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
    );

    final result = await addTodoUseCase(params);

    return result.fold(
      onFailure: (failure) {
        _failure = failure;
        _setState(TodoState.error);
        return false;
      },
      onSuccess: (newTodo) {
        _todos = List.from(_todos)..add(newTodo);
        _failure = null;
        _setState(TodoState.loaded);
        return true;
      },
    );
  }

  /// Update a todo
  Future<bool> updateTodo({
    required String id,
    String? title,
    String? description,
    TodoPriority? priority,
    DateTime? dueDate,
  }) async {
    // Store previous state for rollback
    final previousTodos = List<TodoEntity>.from(_todos);
    final index = _todos.indexWhere((t) => t.id == id);

    if (index == -1) {
      _failure = NotFoundFailure(
        message: 'Todo not found',
        resourceType: 'Todo',
        resourceId: id,
      );
      _setState(TodoState.error);
      return false;
    }

    final params = UpdateTodoParams(
      id: id,
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
    );

    final result = await updateTodoUseCase(params);

    return result.fold(
      onFailure: (failure) {
        _todos = previousTodos;
        _failure = failure;
        _setState(TodoState.error);
        return false;
      },
      onSuccess: (updatedTodo) {
        _todos = List.from(_todos)..[index] = updatedTodo;
        _failure = null;
        _setState(TodoState.loaded);
        return true;
      },
    );
  }

  /// Delete a todo
  Future<bool> deleteTodo(String id) async {
    // Store previous state for rollback
    final previousTodos = List<TodoEntity>.from(_todos);

    // Optimistic update
    _todos = List.from(_todos)..removeWhere((t) => t.id == id);
    notifyListeners();

    final result = await deleteTodoUseCase(DeleteTodoParams(id: id));

    return result.fold(
      onFailure: (failure) {
        // Rollback on failure
        _todos = previousTodos;
        _failure = failure;
        _setState(TodoState.error);
        return false;
      },
      onSuccess: (_) {
        _failure = null;
        _setState(TodoState.loaded);
        return true;
      },
    );
  }

  /// Toggle todo completion status
  Future<bool> toggleTodo(String id) async {
    // Store previous state for rollback
    final previousTodos = List<TodoEntity>.from(_todos);
    final index = _todos.indexWhere((t) => t.id == id);

    if (index == -1) {
      _failure = NotFoundFailure(
        message: 'Todo not found',
        resourceType: 'Todo',
        resourceId: id,
      );
      notifyListeners();
      return false;
    }

    // Optimistic update
    final currentTodo = _todos[index];
    _todos = List.from(_todos)..[index] = currentTodo.toggle();
    notifyListeners();

    final result = await toggleTodoUseCase(ToggleTodoParams(id: id));

    return result.fold(
      onFailure: (failure) {
        // Rollback on failure
        _todos = previousTodos;
        _failure = failure;
        notifyListeners();
        return false;
      },
      onSuccess: (updatedTodo) {
        _todos = List.from(_todos)..[index] = updatedTodo;
        _failure = null;
        _setState(TodoState.loaded);
        return true;
      },
    );
  }

  /// Clear any error state
  void clearError() {
    if (_state == TodoState.error) {
      _failure = null;
      _setState(TodoState.loaded);
    }
  }

  void _setState(TodoState newState) {
    _state = newState;
    notifyListeners();
  }
}
