import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<void> cacheTodos(List<TodoModel> todos);
  Future<TodoModel> addTodo({
    required String title,
    required String description,
  });
}

/// In-memory local store (acts like a DB/cache)
class TodoLocalDataSourceInMemory implements TodoLocalDataSource {
  final List<TodoModel> _cache = [];

  @override
  Future<List<TodoModel>> getTodos() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return List.unmodifiable(_cache);
  }

  @override
  Future<void> cacheTodos(List<TodoModel> todos) async {
    _cache
      ..clear()
      ..addAll(todos);
  }

  @override
  Future<TodoModel> addTodo({
    required String title,
    required String description,
  }) async {
    final model = TodoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );
    _cache.add(model);
    return model;
  }
}
