/// Entity representing dashboard statistics in the domain layer
/// 
/// This entity aggregates data from multiple features (Counter & Todo)
/// following the Single Responsibility Principle - it only represents
/// the business logic data structure without any implementation details.
class DashboardStatsEntity {
  /// Current counter value from Counter feature
  final int counterValue;

  /// Total number of todos from Todo feature
  final int totalTodos;

  /// Number of completed todos
  final int completedTodos;

  /// Number of pending/incomplete todos
  final int pendingTodos;

  /// Completion rate as a percentage (0.0 to 100.0)
  final double completionRate;

  /// Combined productivity score based on counter and completion
  final int productivityScore;

  /// When the stats were generated
  final DateTime generatedAt;

  DashboardStatsEntity({
    required this.counterValue,
    required this.totalTodos,
    required this.completedTodos,
    required this.pendingTodos,
    required this.completionRate,
    required this.productivityScore,
    required this.generatedAt,
  });

  /// Copy with method for immutability pattern
  DashboardStatsEntity copyWith({
    int? counterValue,
    int? totalTodos,
    int? completedTodos,
    int? pendingTodos,
    double? completionRate,
    int? productivityScore,
    DateTime? generatedAt,
  }) {
    return DashboardStatsEntity(
      counterValue: counterValue ?? this.counterValue,
      totalTodos: totalTodos ?? this.totalTodos,
      completedTodos: completedTodos ?? this.completedTodos,
      pendingTodos: pendingTodos ?? this.pendingTodos,
      completionRate: completionRate ?? this.completionRate,
      productivityScore: productivityScore ?? this.productivityScore,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardStatsEntity &&
          runtimeType == other.runtimeType &&
          counterValue == other.counterValue &&
          totalTodos == other.totalTodos &&
          completedTodos == other.completedTodos &&
          pendingTodos == other.pendingTodos &&
          completionRate == other.completionRate &&
          productivityScore == other.productivityScore &&
          generatedAt == other.generatedAt;

  @override
  int get hashCode =>
      counterValue.hashCode ^
      totalTodos.hashCode ^
      completedTodos.hashCode ^
      pendingTodos.hashCode ^
      completionRate.hashCode ^
      productivityScore.hashCode ^
      generatedAt.hashCode;

  @override
  String toString() {
    return 'DashboardStatsEntity(counterValue: $counterValue, totalTodos: $totalTodos, '
        'completedTodos: $completedTodos, pendingTodos: $pendingTodos, '
        'completionRate: ${completionRate.toStringAsFixed(1)}%, '
        'productivityScore: $productivityScore, generatedAt: $generatedAt)';
  }
}
