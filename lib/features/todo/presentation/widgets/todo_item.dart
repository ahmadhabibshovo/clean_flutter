import 'package:flutter/material.dart';

import '../../domain/entities/todo.dart';

class TodoItem extends StatelessWidget {
  final TodoEntity todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        todo.isCompleted ? Icons.check_circle : Icons.circle_outlined,
      ),
      title: Text(todo.title),
      subtitle: todo.description.isEmpty ? null : Text(todo.description),
    );
  }
}
