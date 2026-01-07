import '../repositories/todo_repository.dart';

/// Use case for deleting a todo
class DeleteTodoUseCase {
  final TodoRepository repository;

  DeleteTodoUseCase({required this.repository});

  Future<void> call(String id) {
    return repository.deleteTodo(id);
  }
}
