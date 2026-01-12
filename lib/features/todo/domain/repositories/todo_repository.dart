import '../../../../core/types/result.dart';
import '../entities/todo.dart';

abstract class TodoRepository {
  Future<Result<List<TodoEntity>>> getTodos();
  Future<Result<TodoEntity>> addTodo({
    required String title,
    String? description,
  });
}
