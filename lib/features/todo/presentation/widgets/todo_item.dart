import 'package:flutter/material.dart';

import '../../domain/entities/todo.dart';

class TodoItem extends StatelessWidget {
  final TodoEntity todo;
  final VoidCallback? onToggle;

  const TodoItem({super.key, required this.todo, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: todo.isCompleted,
      onChanged: (_) => onToggle?.call(),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: todo.description.isEmpty ? null : Text(todo.description),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
