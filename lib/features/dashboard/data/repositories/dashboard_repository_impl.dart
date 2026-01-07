import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../../counter/domain/entities/counter_entity.dart';
import '../../../counter/domain/repositories/counter_repository.dart';
import '../../../todo/domain/entities/todo_entity.dart';
import '../../../todo/domain/repositories/todo_repository.dart';

/// Implementation of DashboardRepository
///
/// This demonstrates the Dependency Inversion Principle and Repository Pattern.
/// Instead of depending on concrete implementations, it depends on abstractions
/// (CounterRepository and TodoRepository interfaces).
///
/// This class orchestrates data from multiple features and applies business
/// logic to compute derived metrics. It acts as a Facade pattern over
/// multiple repositories.
class DashboardRepositoryImpl implements DashboardRepository {
  final CounterRepository counterRepository;
  final TodoRepository todoRepository;

  /// Constructor injection for dependencies (Dependency Injection pattern)
  DashboardRepositoryImpl({
    required this.counterRepository,
    required this.todoRepository,
  });

  @override
  Future<DashboardStatsEntity> getDashboardStats() async {
    try {
      // Parallel execution for better performance
      // This is an optimization technique for I/O bound operations
      final results = await Future.wait([
        counterRepository.getCounter(),
        todoRepository.getTodos(),
      ]);

      final counterEntity = results[0] as CounterEntity;
      final todos = results[1] as List<TodoEntity>;

      // Apply business logic to compute statistics
      return _computeStats(counterValue: counterEntity.value, todos: todos);
    } catch (e) {
      // In production, you'd have proper error handling with custom exceptions
      rethrow;
    }
  }

  @override
  Future<DashboardStatsEntity> refreshStats() async {
    // In a real app, you might clear caches here or force reload
    // For now, we'll just recompute
    return await getDashboardStats();
  }

  /// Private method to compute statistics following SRP
  ///
  /// This encapsulates the business logic for calculating derived metrics.
  /// In a larger system, this could be extracted into a separate
  /// DomainService or Calculator class.
  DashboardStatsEntity _computeStats({
    required int counterValue,
    required List<TodoEntity> todos,
  }) {
    final totalTodos = todos.length;
    final completedTodos = todos.where((todo) => todo.isCompleted).length;
    final pendingTodos = totalTodos - completedTodos;

    // Calculate completion rate
    final completionRate = totalTodos > 0
        ? (completedTodos / totalTodos) * 100
        : 0.0;

    // Calculate productivity score (custom business logic)
    // Formula: (counter value × 10) + (completed todos × 20)
    // This is a domain-specific calculation that might be defined
    // by business analysts or product managers
    final productivityScore = (counterValue * 10) + (completedTodos * 20);

    return DashboardStatsEntity(
      counterValue: counterValue,
      totalTodos: totalTodos,
      completedTodos: completedTodos,
      pendingTodos: pendingTodos,
      completionRate: completionRate,
      productivityScore: productivityScore,
      generatedAt: DateTime.now(),
    );
  }
}
