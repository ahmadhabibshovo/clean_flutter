import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/datasources/counter_local_datasource.dart';
import '../../data/repositories/counter_repository_impl.dart';
import '../../domain/repositories/counter_repository.dart';
import '../../domain/usecases/decrement_counter_usecase.dart';
import '../../domain/usecases/get_counter_usecase.dart';
import '../../domain/usecases/increment_counter_usecase.dart';
import '../../domain/usecases/reset_counter_usecase.dart';
import '../provider/counter_provider.dart';
import '../pages/counter_page.dart';

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup dependency injection
    final CounterLocalDataSource localDataSource = CounterLocalDataSourceImpl();
    final CounterRepository repository = CounterRepositoryImpl(
      localDataSource: localDataSource,
    );
    final GetCounterUseCase getCounterUseCase = GetCounterUseCase(
      repository: repository,
    );
    final IncrementCounterUseCase incrementCounterUseCase =
        IncrementCounterUseCase(repository: repository);
    final DecrementCounterUseCase decrementCounterUseCase =
        DecrementCounterUseCase(repository: repository);
    final ResetCounterUseCase resetCounterUseCase = ResetCounterUseCase(
      repository: repository,
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
      ],
      child: MaterialApp(
        title: 'Clean Architecture Counter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const CounterPage(),
      ),
    );
  }
}
