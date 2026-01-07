import '../../../../core/types/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Parameters for adding a new todo
class AddTodoParams extends Params {
  final String title;
  final String? description;
  final TodoPriority priority;
  final DateTime? dueDate;

  const AddTodoParams({
    required this.title,
    this.description,
    this.priority = TodoPriority.medium,
    this.dueDate,
  });

  @override
  List<Object?> get props => [title, description, priority, dueDate];

  @override
  ValidationResult validate() {
    final errors = <String, String>{};

    if (title.trim().isEmpty) {
      errors['title'] = 'Title cannot be empty';
    }
    if (title.length > 200) {
      errors['title'] = 'Title must be less than 200 characters';
    }
    if (description != null && description!.length > 1000) {
      errors['description'] = 'Description must be less than 1000 characters';
    }

    if (errors.isEmpty) {
      return ValidationResult.valid();
    }
    return ValidationResult.invalid(errors.values.first, errors);
  }
}

/// Use case for adding a new todo
///
/// Validates the input before creating the todo.
/// Returns the newly created todo on success.
class AddTodoUseCase extends UseCase<TodoEntity, AddTodoParams> {
  final TodoRepository repository;

  AddTodoUseCase({required this.repository});

  @override
  Future<Result<TodoEntity>> call(AddTodoParams params) {
    return repository.addTodo(
      title: params.title,
      description: params.description,
      priority: params.priority,
      dueDate: params.dueDate,
    );
  }
}
