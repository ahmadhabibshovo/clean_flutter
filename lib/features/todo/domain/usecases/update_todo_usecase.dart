import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Use case for updating a todo
class UpdateTodoUseCase {
  final TodoRepository repository;

  UpdateTodoUseCase({required this.repository});

  Future<TodoEntity> call(String id, String title, String description) {
    return repository.updateTodo(id, title, description);
  }
}
