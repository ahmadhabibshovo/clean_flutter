import '../../../../core/types/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Parameters for toggling todo completion
class ToggleTodoParams extends Params {
  final String id;

  const ToggleTodoParams({required this.id});

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

/// Use case for toggling todo completion status
///
/// Switches completed ↔ not completed.
/// Returns the updated todo on success.
class ToggleTodoUseCase extends UseCase<TodoEntity, ToggleTodoParams> {
  final TodoRepository repository;

  ToggleTodoUseCase({required this.repository});

  @override
  Future<Result<TodoEntity>> call(ToggleTodoParams params) {
    return repository.toggleTodo(params.id);
  }
}
