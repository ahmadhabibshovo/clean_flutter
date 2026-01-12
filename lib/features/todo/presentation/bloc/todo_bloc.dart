import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_todo_uc.dart';
import '../../domain/usecases/get_todos_uc.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosUseCase getTodos;
  final AddTodoUseCase addTodo;

  TodoBloc({required this.getTodos, required this.addTodo})
    : super(const TodoInitial()) {
    on<TodoLoadRequested>(_onLoad);
    on<TodoAddRequested>(_onAdd);
  }

  Future<void> _onLoad(TodoLoadRequested event, Emitter<TodoState> emit) async {
    emit(const TodoLoading());
    final result = await getTodos(const NoParams());
    result.fold(
      (f) => emit(TodoError(failure: f)),
      (todos) => emit(TodoLoaded(todos: todos)),
    );
  }

  Future<void> _onAdd(TodoAddRequested event, Emitter<TodoState> emit) async {
    emit(const TodoLoading());

    final result = await addTodo(
      AddTodoParams(title: event.title, description: event.description),
    );

    await result.fold(
      (f) async {
        emit(TodoError(failure: f));
      },
      (newTodo) async {
        // reload list (enterprise-safe consistency)
        final listResult = await getTodos(const NoParams());
        listResult.fold(
          (f) => emit(TodoError(failure: f)),
          (todos) => emit(TodoLoaded(todos: todos)),
        );
      },
    );
  }
}
