import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection_container.dart';
import '../data/repositories/todo_repository_impl.dart';
import '../domain/repositories/todo_repository.dart';
import '../domain/usecases/add_todo_uc.dart';
import '../domain/usecases/get_todos_uc.dart';
import '../domain/usecases/toggle_todo_uc.dart';
import '../presentation/bloc/todo_bloc.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepositoryImpl(
    localDataSource: ref.watch(todoLocalDataSourceProvider),
    remoteDataSource: ref.watch(todoRemoteDataSourceProvider),
  );
});

final getTodosUseCaseProvider = Provider<GetTodosUseCase>((ref) {
  return GetTodosUseCase(repository: ref.watch(todoRepositoryProvider));
});

final addTodoUseCaseProvider = Provider<AddTodoUseCase>((ref) {
  return AddTodoUseCase(repository: ref.watch(todoRepositoryProvider));
});

final toggleTodoUseCaseProvider = Provider<ToggleTodoUseCase>((ref) {
  return ToggleTodoUseCase(repository: ref.watch(todoRepositoryProvider));
});

final todoBlocProvider = Provider.autoDispose<TodoBloc>((ref) {
  final bloc = TodoBloc(
    getTodos: ref.watch(getTodosUseCaseProvider),
    addTodo: ref.watch(addTodoUseCaseProvider),
    toggleTodo: ref.watch(toggleTodoUseCaseProvider),
  );
  ref.onDispose(bloc.close);
  return bloc;
});
