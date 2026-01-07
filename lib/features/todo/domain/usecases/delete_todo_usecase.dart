import '../../../../core/types/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

/// Parameters for deleting a todo
class DeleteTodoParams extends Params {
  final String id;

  const DeleteTodoParams({required this.id});

  @override
  List<Object?> get props => [id];

  @override
  ValidationResult validate() {
    if (id.isEmpty) {
      return ValidationResult.invalid('Todo ID is required', {
        'id': 'Required',
      });
    }
    return ValidationResult.valid();
  }
}

/// Use case for deleting a todo
///
/// Returns void on success, appropriate failure if todo not found.
class DeleteTodoUseCase extends UseCaseVoid<DeleteTodoParams> {
  final TodoRepository repository;

  DeleteTodoUseCase({required this.repository});

  @override
  Future<Result<void>> call(DeleteTodoParams params) {
    return repository.deleteTodo(params.id);
  }
}
