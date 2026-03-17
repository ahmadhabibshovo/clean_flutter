import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

import 'features/counter/data/datasources/counter_local_datasource.dart';
import 'features/counter/data/repositories/counter_repository_impl.dart';
import 'features/counter/domain/repositories/counter_repository.dart';
import 'features/counter/domain/usecases/decrement_counter_usecase.dart';
import 'features/counter/domain/usecases/get_counter_usecase.dart';
import 'features/counter/domain/usecases/increment_counter_usecase.dart';
import 'features/counter/domain/usecases/reset_counter_usecase.dart';
import 'features/counter/presentation/pages/counter_page.dart';
import 'features/counter/presentation/provider/counter_provider.dart';

void main() {
  runApp(ProviderScope(child: const RootApp()));
}

final counterLocalDataSource = CounterLocalDataSourceImpl();
final CounterRepository counterRepository = CounterRepositoryImpl(
  localDataSource: counterLocalDataSource,
);
final GetCounterUseCase getCounterUseCase = GetCounterUseCase(
  repository: counterRepository,
);
final IncrementCounterUseCase incrementCounterUseCase = IncrementCounterUseCase(
  repository: counterRepository,
);
final DecrementCounterUseCase decrementCounterUseCase = DecrementCounterUseCase(
  repository: counterRepository,
);
final ResetCounterUseCase resetCounterUseCase = ResetCounterUseCase(
  repository: counterRepository,
);
final counterProvider = ChangeNotifierProvider<CounterProvider>(
  (ref) => CounterProvider(
    getCounterUseCase: getCounterUseCase,
    incrementCounterUseCase: incrementCounterUseCase,
    decrementCounterUseCase: decrementCounterUseCase,
    resetCounterUseCase: resetCounterUseCase,
  )..initCounter(),
);

/// Root application widget that manages both features
class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup Counter DI

    return MaterialApp(
      title: 'Clean Architecture App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppHome(),
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

  final List<Widget> _pages = [const CounterPage()];

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
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'TODO'),
        ],
      ),
    );
  }
}
