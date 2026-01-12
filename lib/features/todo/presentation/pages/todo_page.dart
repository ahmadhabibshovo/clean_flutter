import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/todo_providers.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../widgets/todo_item.dart';

class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key});

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  @override
  void initState() {
    super.initState();
    // Load once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(todoBlocProvider).add(const TodoLoadRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(todoBlocProvider);

    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('TODO (Riverpod + Bloc + Mock API)')),
        body: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            switch (state) {
              case TodoInitial():
                return const Center(child: Text('Initializing...'));
              case TodoLoading():
                return const Center(child: CircularProgressIndicator());
              case TodoLoaded(:final todos):
                if (todos.isEmpty) {
                  return const Center(child: Text('No TODOs. Add one!'));
                }
                return ListView.separated(
                  itemCount: todos.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) => TodoItem(
                    todo: todos[index],
                    onToggle: () =>
                        bloc.add(TodoToggleRequested(id: todos[index].id)),
                  ),
                );
              case TodoError(:final failure):
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${failure.message}'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => bloc.add(const TodoLoadRequested()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await showDialog<_TodoDialogResult>(
              context: context,
              builder: (_) => const _TodoDialog(),
            );
            if (result == null) return;
            if (!context.mounted) return;
            bloc.add(
              TodoAddRequested(
                title: result.title,
                description: result.description,
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _TodoDialogResult {
  final String title;
  final String description;
  const _TodoDialogResult({required this.title, required this.description});
}

class _TodoDialog extends StatefulWidget {
  const _TodoDialog();

  @override
  State<_TodoDialog> createState() => _TodoDialogState();
}

class _TodoDialogState extends State<_TodoDialog> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add TODO'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            key: const Key('todo_title_field'),
            controller: _title,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            key: const Key('todo_description_field'),
            controller: _desc,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final title = _title.text.trim();
            if (title.isEmpty) {
              setState(() => _error = 'Title is required');
              return;
            }
            Navigator.pop(
              context,
              _TodoDialogResult(title: title, description: _desc.text.trim()),
            );
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
