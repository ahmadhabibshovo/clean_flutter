import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/todo.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<TodoEntity>>> getTodos();
  Future<Either<Failure, TodoEntity>> addTodo({
    required String title,
    String? description,
  });
}
