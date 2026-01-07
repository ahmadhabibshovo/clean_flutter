import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Use case for getting all todos
class GetTodosUseCase {
  final TodoRepository repository;

  GetTodosUseCase({required this.repository});

  Future<List<TodoEntity>> call() {
    return repository.getTodos();
  }
}
