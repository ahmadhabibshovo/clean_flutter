import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class ToggleTodoParams extends Params {
  final String id;

  const ToggleTodoParams({required this.id});
}

class ToggleTodoUseCase extends UseCase<TodoEntity, ToggleTodoParams> {
  final TodoRepository repository;

  ToggleTodoUseCase({required this.repository});

  @override
  Future<Either<Failure, TodoEntity>> call(ToggleTodoParams params) {
    return repository.toggleTodo(id: params.id);
  }
}
