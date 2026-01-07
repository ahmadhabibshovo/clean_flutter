import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Use case for adding a new todo
class AddTodoUseCase {
  final TodoRepository repository;

  AddTodoUseCase({required this.repository});

  Future<TodoEntity> call(String title, String description) {
    return repository.addTodo(title, description);
  }
}
