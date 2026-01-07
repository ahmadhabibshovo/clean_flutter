import '../../../../core/types/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Use case for getting all todos
///
/// Returns a list of all todos, empty list if none exist.
/// Never throws exceptions - uses Result pattern.
class GetTodosUseCase extends UseCase<List<TodoEntity>, NoParams> {
  final TodoRepository repository;

  GetTodosUseCase({required this.repository});

  @override
  Future<Result<List<TodoEntity>>> call(NoParams params) {
    return repository.getTodos();
  }
}
