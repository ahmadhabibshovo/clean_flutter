import '../models/todo_model.dart';
import '../../../../core/db/app_database.dart';
import 'package:drift/drift.dart' as drift;

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<void> cacheTodos(List<TodoModel> todos);
  Future<TodoModel> addTodo({
    required String title,
    required String description,
  });
  Future<TodoModel> toggleTodo({required String id});
}

/// In-memory local store (acts like a DB/cache)
class TodoLocalDataSourceInMemory implements TodoLocalDataSource {
  final List<TodoModel> _cache = [];

  @override
  Future<List<TodoModel>> getTodos() async {
    await Future.delayed(const Duration(milliseconds: 10));
    return List.unmodifiable(_cache);
  }

  @override
  Future<void> cacheTodos(List<TodoModel> todos) async {
    _cache
      ..clear()
      ..addAll(todos);
  }

  @override
  Future<TodoModel> addTodo({
    required String title,
    required String description,
  }) async {
    final model = TodoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );
    _cache.add(model);
    return model;
  }

  @override
  Future<TodoModel> toggleTodo({required String id}) async {
    final index = _cache.indexWhere((t) => t.id == id);
    if (index == -1) {
      throw StateError('Todo not found: $id');
    }

    final current = _cache[index];
    final updated = current.copyWith(
      isCompleted: !current.isCompleted,
      updatedAt: DateTime.now(),
    );
    _cache[index] = updated;
    return updated;
  }
}

/// Drift (SQLite) implementation for enterprise-grade local persistence.
class TodoLocalDataSourceDrift implements TodoLocalDataSource {
  final AppDatabase db;

  TodoLocalDataSourceDrift({required this.db});

  @override
  Future<List<TodoModel>> getTodos() async {
    final rows =
        await (db.select(db.todos)..orderBy([
              (t) => drift.OrderingTerm(
                expression: t.createdAt,
                mode: drift.OrderingMode.desc,
              ),
            ]))
            .get();

    return rows
        .map(
          (r) => TodoModel(
            id: r.id,
            title: r.title,
            description: r.description,
            isCompleted: r.isCompleted,
            createdAt: r.createdAt,
            updatedAt: r.updatedAt,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> cacheTodos(List<TodoModel> todos) async {
    await db.transaction(() async {
      await db.delete(db.todos).go();
      await db.batch((batch) {
        batch.insertAll(
          db.todos,
          todos
              .map(
                (t) => TodosCompanion.insert(
                  id: t.id,
                  title: t.title,
                  description: drift.Value(t.description),
                  isCompleted: drift.Value(t.isCompleted),
                  createdAt: t.createdAt,
                  updatedAt: drift.Value(t.updatedAt),
                ),
              )
              .toList(growable: false),
          mode: drift.InsertMode.insertOrReplace,
        );
      });
    });
  }

  @override
  Future<TodoModel> addTodo({
    required String title,
    required String description,
  }) async {
    final model = TodoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    await db
        .into(db.todos)
        .insert(
          TodosCompanion.insert(
            id: model.id,
            title: model.title,
            description: drift.Value(model.description),
            isCompleted: drift.Value(model.isCompleted),
            createdAt: model.createdAt,
            updatedAt: drift.Value(model.updatedAt),
          ),
          mode: drift.InsertMode.insertOrReplace,
        );

    return model;
  }

  @override
  Future<TodoModel> toggleTodo({required String id}) async {
    return db.transaction(() async {
      final row = await (db.select(
        db.todos,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      if (row == null) {
        throw StateError('Todo not found: $id');
      }

      final updatedAt = DateTime.now();
      final newCompleted = !row.isCompleted;

      await (db.update(db.todos)..where((t) => t.id.equals(id))).write(
        TodosCompanion(
          isCompleted: drift.Value(newCompleted),
          updatedAt: drift.Value(updatedAt),
        ),
      );

      return TodoModel(
        id: row.id,
        title: row.title,
        description: row.description,
        isCompleted: newCompleted,
        createdAt: row.createdAt,
        updatedAt: updatedAt,
      );
    });
  }
}
