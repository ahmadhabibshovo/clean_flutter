import '../../../../core/types/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Parameters for updating a todo
class UpdateTodoParams extends Params {
  final String id;
  final String? title;
  final String? description;
  final TodoPriority? priority;
  final DateTime? dueDate;

  const UpdateTodoParams({
    required this.id,
    this.title,
    this.description,
    this.priority,
    this.dueDate,
  });

  @override
  List<Object?> get props => [id, title, description, priority, dueDate];

  @override
  ValidationResult validate() {
    final errors = <String, String>{};

    if (id.isEmpty) {
      errors['id'] = 'Todo ID is required';
    }
    if (title != null && title!.trim().isEmpty) {
      errors['title'] = 'Title cannot be empty';
    }
    if (title != null && title!.length > 200) {
      errors['title'] = 'Title must be less than 200 characters';
    }

    if (errors.isEmpty) {
      return ValidationResult.valid();
    }
    return ValidationResult.invalid(errors.values.first, errors);
  }
}

/// Use case for updating an existing todo
///
/// Only updates fields that are provided (partial update).
/// Returns the updated todo on success.
class UpdateTodoUseCase extends UseCase<TodoEntity, UpdateTodoParams> {
  final TodoRepository repository;

  UpdateTodoUseCase({required this.repository});

  @override
  Future<Result<TodoEntity>> call(UpdateTodoParams params) {
    return repository.updateTodo(
      id: params.id,
      title: params.title,
      description: params.description,
      priority: params.priority,
      dueDate: params.dueDate,
    );
  }
}
