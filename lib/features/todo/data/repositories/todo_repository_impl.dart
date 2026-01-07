import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';

/// Implementation of TODO repository
class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TodoEntity>> getTodos() async {
    final models = await localDataSource.getTodos();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<TodoEntity> addTodo(String title, String description) async {
    final model = await localDataSource.addTodo(title, description);
    return model.toEntity();
  }

  @override
  Future<TodoEntity> updateTodo(
    String id,
    String title,
    String description,
  ) async {
    final model = await localDataSource.updateTodo(id, title, description);
    return model.toEntity();
  }

  @override
  Future<void> deleteTodo(String id) async {
    await localDataSource.deleteTodo(id);
  }

  @override
  Future<TodoEntity> toggleTodo(String id) async {
    final model = await localDataSource.toggleTodo(id);
    return model.toEntity();
  }
}
