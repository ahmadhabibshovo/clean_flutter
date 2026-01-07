import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/datasources/todo_local_datasource.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/toggle_todo_usecase.dart';
import '../../domain/usecases/update_todo_usecase.dart';
import '../provider/todo_provider.dart';
import '../pages/todo_page.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup dependency injection
    final TodoLocalDataSource localDataSource = TodoLocalDataSourceImpl();
    final TodoRepository repository = TodoRepositoryImpl(
      localDataSource: localDataSource,
    );
    final GetTodosUseCase getTodosUseCase = GetTodosUseCase(
      repository: repository,
    );
    final AddTodoUseCase addTodoUseCase = AddTodoUseCase(
      repository: repository,
    );
    final UpdateTodoUseCase updateTodoUseCase = UpdateTodoUseCase(
      repository: repository,
    );
    final DeleteTodoUseCase deleteTodoUseCase = DeleteTodoUseCase(
      repository: repository,
    );
    final ToggleTodoUseCase toggleTodoUseCase = ToggleTodoUseCase(
      repository: repository,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TodoProvider(
            getTodosUseCase: getTodosUseCase,
            addTodoUseCase: addTodoUseCase,
            updateTodoUseCase: updateTodoUseCase,
            deleteTodoUseCase: deleteTodoUseCase,
            toggleTodoUseCase: toggleTodoUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Clean Architecture TODO',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TodoPage(),
      ),
    );
  }
}
