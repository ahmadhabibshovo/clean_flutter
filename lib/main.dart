import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/counter/data/datasources/counter_local_datasource.dart';
import 'features/counter/data/repositories/counter_repository_impl.dart';
import 'features/counter/domain/repositories/counter_repository.dart';
import 'features/counter/domain/usecases/decrement_counter_usecase.dart';
import 'features/counter/domain/usecases/get_counter_usecase.dart';
import 'features/counter/domain/usecases/increment_counter_usecase.dart';
import 'features/counter/domain/usecases/reset_counter_usecase.dart';
import 'features/counter/presentation/pages/counter_page.dart';
import 'features/counter/presentation/provider/counter_provider.dart';
import 'features/todo/data/datasources/todo_local_datasource.dart';
import 'features/todo/data/repositories/todo_repository_impl.dart';
import 'features/todo/domain/repositories/todo_repository.dart';
import 'features/todo/domain/usecases/add_todo_usecase.dart';
import 'features/todo/domain/usecases/delete_todo_usecase.dart';
import 'features/todo/domain/usecases/get_todos_usecase.dart';
import 'features/todo/domain/usecases/toggle_todo_usecase.dart';
import 'features/todo/domain/usecases/update_todo_usecase.dart';
import 'features/todo/presentation/pages/todo_page.dart';
import 'features/todo/presentation/provider/todo_provider.dart';

void main() {
  runApp(const RootApp());
}

/// Root application widget that manages both features
class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup Counter DI
    final counterLocalDataSource = CounterLocalDataSourceImpl();
    final CounterRepository counterRepository = CounterRepositoryImpl(
      localDataSource: counterLocalDataSource,
    );
    final GetCounterUseCase getCounterUseCase = GetCounterUseCase(
      repository: counterRepository,
    );
    final IncrementCounterUseCase incrementCounterUseCase =
        IncrementCounterUseCase(repository: counterRepository);
    final DecrementCounterUseCase decrementCounterUseCase =
        DecrementCounterUseCase(repository: counterRepository);
    final ResetCounterUseCase resetCounterUseCase = ResetCounterUseCase(
      repository: counterRepository,
    );

    // Setup TODO DI
    final todoLocalDataSource = TodoLocalDataSourceImpl();
    final TodoRepository todoRepository = TodoRepositoryImpl(
      localDataSource: todoLocalDataSource,
    );
    final GetTodosUseCase getTodosUseCase = GetTodosUseCase(
      repository: todoRepository,
    );
    final AddTodoUseCase addTodoUseCase = AddTodoUseCase(
      repository: todoRepository,
    );
    final UpdateTodoUseCase updateTodoUseCase = UpdateTodoUseCase(
      repository: todoRepository,
    );
    final DeleteTodoUseCase deleteTodoUseCase = DeleteTodoUseCase(
      repository: todoRepository,
    );
    final ToggleTodoUseCase toggleTodoUseCase = ToggleTodoUseCase(
      repository: todoRepository,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CounterProvider(
            getCounterUseCase: getCounterUseCase,
            incrementCounterUseCase: incrementCounterUseCase,
            decrementCounterUseCase: decrementCounterUseCase,
            resetCounterUseCase: resetCounterUseCase,
          ),
        ),
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
        title: 'Clean Architecture App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AppHome(),
      ),
    );
  }
}

/// Home page with navigation between Counter and TODO
class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [const CounterPage(), const TodoPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Counter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'TODO',
          ),
        ],
      ),
    );
  }
}
