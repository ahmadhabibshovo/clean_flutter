import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/todo_entity.dart';
import '../provider/todo_provider.dart';

/// Reusable TODO item widget
class TodoItemWidget extends StatelessWidget {
  final TodoEntity todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggle(),
          activeColor: Colors.green,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          todo.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(child: const Text('Edit'), onTap: onEdit),
            PopupMenuItem(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog for adding/editing todos
class TodoDialog extends StatefulWidget {
  final TodoEntity? todo;

  const TodoDialog({super.key, this.todo});

  @override
  State<TodoDialog> createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo?.title ?? '');
    descriptionController = TextEditingController(
      text: widget.todo?.description ?? '',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit TODO' : 'Add TODO'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Title cannot be empty')),
              );
              return;
            }

            if (isEditing) {
              context.read<TodoProvider>().updateTodo(
                id: widget.todo!.id,
                title: titleController.text,
                description: descriptionController.text,
              );
            } else {
              context.read<TodoProvider>().addTodo(
                title: titleController.text,
                description: descriptionController.text,
              );
            }
            Navigator.pop(context);
          },
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
