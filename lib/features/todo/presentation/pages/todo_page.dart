import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/todo_provider.dart';
import '../widgets/todo_widgets.dart';

/// TODO feature page
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  void initState() {
    super.initState();
    // Initialize todos on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoProvider>().initTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO List'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, _) {
          if (todoProvider.isLoading && todoProvider.todos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (todoProvider.error != null && todoProvider.todos.isEmpty) {
            return Center(child: Text('Error: ${todoProvider.error}'));
          }

          return Column(
            children: [
              // Stats section
              Container(
                color: Colors.deepPurple.withAlpha(30),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${todoProvider.totalCount}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Total'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${todoProvider.completedCount}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const Text('Completed'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${todoProvider.totalCount - todoProvider.completedCount}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        const Text('Pending'),
                      ],
                    ),
                  ],
                ),
              ),
              // TODO list
              Expanded(
                child: todoProvider.todos.isEmpty
                    ? const Center(child: Text('No TODOs yet. Add one!'))
                    : ListView.builder(
                        itemCount: todoProvider.todos.length,
                        itemBuilder: (context, index) {
                          final todo = todoProvider.todos[index];
                          return TodoItemWidget(
                            todo: todo,
                            onToggle: () => todoProvider.toggleTodo(todo.id),
                            onDelete: () => todoProvider.deleteTodo(todo.id),
                            onEdit: () {
                              showDialog(
                                context: context,
                                builder: (_) => TodoDialog(todo: todo),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (_) => const TodoDialog());
        },
        tooltip: 'Add TODO',
        child: const Icon(Icons.add),
      ),
    );
  }
}
