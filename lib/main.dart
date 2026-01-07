import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/service_locator.dart';
import 'features/counter/presentation/pages/counter_page.dart';
import 'features/counter/presentation/provider/counter_provider.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/dashboard/presentation/provider/dashboard_provider.dart';
import 'features/todo/presentation/pages/todo_page.dart';
import 'features/todo/presentation/provider/todo_provider.dart';

void main() {
  setupServiceLocator();
  runApp(const RootApp());
}

/// Root application widget that manages all features
class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CounterProvider>(
          create: (_) => getIt<CounterProvider>(),
        ),
        ChangeNotifierProvider<TodoProvider>(
          create: (_) => getIt<TodoProvider>(),
        ),
        ChangeNotifierProvider<DashboardProvider>(
          create: (_) => getIt<DashboardProvider>(),
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

/// Home page with navigation between features
class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const CounterPage(),
    const TodoPage(),
  ];

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
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
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
