import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Use case for toggling todo completion status
class ToggleTodoUseCase {
  final TodoRepository repository;

  ToggleTodoUseCase({required this.repository});

  Future<TodoEntity> call(String id) {
    return repository.toggleTodo(id);
  }
}
