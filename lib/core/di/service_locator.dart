import 'package:get_it/get_it.dart';

import '../../features/counter/data/datasources/counter_local_datasource.dart';
import '../../features/counter/data/repositories/counter_repository_impl.dart';
import '../../features/counter/domain/repositories/counter_repository.dart';
import '../../features/counter/domain/usecases/decrement_counter_usecase.dart';
import '../../features/counter/domain/usecases/get_counter_usecase.dart';
import '../../features/counter/domain/usecases/increment_counter_usecase.dart';
import '../../features/counter/domain/usecases/reset_counter_usecase.dart';
import '../../features/counter/presentation/provider/counter_provider.dart';
import '../../features/todo/data/datasources/todo_local_datasource.dart';
import '../../features/todo/data/repositories/todo_repository_impl.dart';
import '../../features/todo/domain/repositories/todo_repository.dart';
import '../../features/todo/domain/usecases/add_todo_usecase.dart';
import '../../features/todo/domain/usecases/delete_todo_usecase.dart';
import '../../features/todo/domain/usecases/get_todos_usecase.dart';
import '../../features/todo/domain/usecases/toggle_todo_usecase.dart';
import '../../features/todo/domain/usecases/update_todo_usecase.dart';
import '../../features/todo/presentation/provider/todo_provider.dart';

final getIt = GetIt.instance;

/// Setup all dependencies for the application
void setupServiceLocator() {
  // Counter - Data Sources
  getIt.registerSingleton<CounterLocalDataSource>(CounterLocalDataSourceImpl());

  // Counter - Repositories
  getIt.registerSingleton<CounterRepository>(
    CounterRepositoryImpl(localDataSource: getIt<CounterLocalDataSource>()),
  );

  // Counter - Use Cases
  getIt.registerSingleton<GetCounterUseCase>(
    GetCounterUseCase(repository: getIt<CounterRepository>()),
  );
  getIt.registerSingleton<IncrementCounterUseCase>(
    IncrementCounterUseCase(repository: getIt<CounterRepository>()),
  );
  getIt.registerSingleton<DecrementCounterUseCase>(
    DecrementCounterUseCase(repository: getIt<CounterRepository>()),
  );
  getIt.registerSingleton<ResetCounterUseCase>(
    ResetCounterUseCase(repository: getIt<CounterRepository>()),
  );

  // Counter - Provider
  getIt.registerSingleton<CounterProvider>(
    CounterProvider(
      getCounterUseCase: getIt<GetCounterUseCase>(),
      incrementCounterUseCase: getIt<IncrementCounterUseCase>(),
      decrementCounterUseCase: getIt<DecrementCounterUseCase>(),
      resetCounterUseCase: getIt<ResetCounterUseCase>(),
    ),
  );

  // TODO - Data Sources
  getIt.registerSingleton<TodoLocalDataSource>(TodoLocalDataSourceImpl());

  // TODO - Repositories
  getIt.registerSingleton<TodoRepository>(
    TodoRepositoryImpl(localDataSource: getIt<TodoLocalDataSource>()),
  );

  // TODO - Use Cases
  getIt.registerSingleton<GetTodosUseCase>(
    GetTodosUseCase(repository: getIt<TodoRepository>()),
  );
  getIt.registerSingleton<AddTodoUseCase>(
    AddTodoUseCase(repository: getIt<TodoRepository>()),
  );
  getIt.registerSingleton<UpdateTodoUseCase>(
    UpdateTodoUseCase(repository: getIt<TodoRepository>()),
  );
  getIt.registerSingleton<DeleteTodoUseCase>(
    DeleteTodoUseCase(repository: getIt<TodoRepository>()),
  );
  getIt.registerSingleton<ToggleTodoUseCase>(
    ToggleTodoUseCase(repository: getIt<TodoRepository>()),
  );

  // TODO - Provider
  getIt.registerSingleton<TodoProvider>(
    TodoProvider(
      getTodosUseCase: getIt<GetTodosUseCase>(),
      addTodoUseCase: getIt<AddTodoUseCase>(),
      updateTodoUseCase: getIt<UpdateTodoUseCase>(),
      deleteTodoUseCase: getIt<DeleteTodoUseCase>(),
      toggleTodoUseCase: getIt<ToggleTodoUseCase>(),
    ),
  );
}
