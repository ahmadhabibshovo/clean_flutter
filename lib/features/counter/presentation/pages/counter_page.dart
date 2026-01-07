import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/counter_provider.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  void initState() {
    super.initState();
    // Initialize counter on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CounterProvider>().initCounter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clean Architecture Counter'),
        centerTitle: true,
      ),
      body: Consumer<CounterProvider>(
        builder: (context, counterProvider, _) {
          if (counterProvider.isLoading && counterProvider.counter == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (counterProvider.error != null) {
            return Center(child: Text('Error: ${counterProvider.error}'));
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Counter Value',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple.withAlpha(30),
                  ),
                  child: Text(
                    '${counterProvider.counter?.value ?? 0}',
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: counterProvider.isLoading
                          ? null
                          : () => counterProvider.decrement(),
                      icon: const Icon(Icons.remove),
                      label: const Text('Decrement'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: counterProvider.isLoading
                          ? null
                          : () => counterProvider.increment(),
                      icon: const Icon(Icons.add),
                      label: const Text('Increment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: counterProvider.isLoading
                      ? null
                      : () => counterProvider.reset(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
