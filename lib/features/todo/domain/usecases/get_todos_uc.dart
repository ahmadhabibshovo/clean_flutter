import '../../../../core/types/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class GetTodosUseCase extends UseCase<List<TodoEntity>, NoParams> {
  final TodoRepository repository;

  GetTodosUseCase({required this.repository});

  @override
  Future<Result<List<TodoEntity>>> call(NoParams params) {
    return repository.getTodos();
  }
}
