import '../../../../core/types/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class AddTodoParams extends Params {
  final String title;
  final String? description;

  const AddTodoParams({required this.title, this.description});
}

class AddTodoUseCase extends UseCase<TodoEntity, AddTodoParams> {
  final TodoRepository repository;

  AddTodoUseCase({required this.repository});

  @override
  Future<Result<TodoEntity>> call(AddTodoParams params) {
    return repository.addTodo(
      title: params.title,
      description: params.description,
    );
  }
}
