import '../models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> fetchTodos();
  Future<TodoModel> addTodo({
    required String title,
    required String description,
  });

  Future<TodoModel> toggleTodo({required String id});
}

/// Offline mock API that returns JSON-like responses.
///
/// This simulates a backend without any network dependency.
class TodoRemoteDataSourceMock implements TodoRemoteDataSource {
  final Duration latency;
  final double failureRate;

  TodoRemoteDataSourceMock({
    this.latency = const Duration(milliseconds: 250),
    this.failureRate = 0.0,
  });

  static final List<Map<String, dynamic>> _serverTodos = [
    {
      'id': '1',
      'title': 'Read Clean Architecture',
      'description': 'Finish core concepts and layers',
      'isCompleted': false,
      'createdAt': '2026-01-01T10:00:00.000Z',
      'updatedAt': null,
    },
    {
      'id': '2',
      'title': 'Implement offline mock API',
      'description': 'Remote datasource returns JSON response',
      'isCompleted': true,
      'createdAt': '2026-01-02T12:00:00.000Z',
      'updatedAt': '2026-01-03T09:00:00.000Z',
    },
  ];

  Future<void> _maybeFail() async {
    // deterministic by default (failureRate=0.0). Keep it simple for enterprise demos.
    if (failureRate <= 0) return;
    final now = DateTime.now().microsecondsSinceEpoch;
    final normalized = (now % 1000) / 1000.0;
    if (normalized < failureRate) {
      throw MockApiException('Mock API failure');
    }
  }

  Map<String, dynamic> _ok(dynamic data) {
    return {'status': 200, 'message': 'OK', 'data': data};
  }

  @override
  Future<List<TodoModel>> fetchTodos() async {
    await Future.delayed(latency);
    await _maybeFail();

    final response = _ok(List<Map<String, dynamic>>.from(_serverTodos));
    final list = (response['data'] as List).cast<Map<String, dynamic>>();
    return list.map(TodoModel.fromJson).toList();
  }

  @override
  Future<TodoModel> addTodo({
    required String title,
    required String description,
  }) async {
    await Future.delayed(latency);
    await _maybeFail();

    final newJson = <String, dynamic>{
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'description': description,
      'isCompleted': false,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'updatedAt': null,
    };
    _serverTodos.add(newJson);

    final response = _ok(newJson);
    return TodoModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  @override
  Future<TodoModel> toggleTodo({required String id}) async {
    await Future.delayed(latency);
    await _maybeFail();

    final index = _serverTodos.indexWhere((t) => t['id'] == id);
    if (index == -1) {
      throw MockApiException('Todo not found');
    }

    final current = Map<String, dynamic>.from(_serverTodos[index]);
    current['isCompleted'] = !(current['isCompleted'] as bool? ?? false);
    current['updatedAt'] = DateTime.now().toUtc().toIso8601String();
    _serverTodos[index] = current;

    final response = _ok(current);
    return TodoModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}

class MockApiException implements Exception {
  final String message;
  MockApiException(this.message);
  @override
  String toString() => 'MockApiException: $message';
}
