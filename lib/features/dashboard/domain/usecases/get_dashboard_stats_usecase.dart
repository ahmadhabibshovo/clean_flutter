import '../entities/dashboard_stats_entity.dart';
import '../repositories/dashboard_repository.dart';

/// Use case for retrieving dashboard statistics
///
/// Following the Single Responsibility Principle, this use case has one job:
/// to get dashboard statistics. It encapsulates the business logic for
/// retrieving aggregated data from multiple features.
///
/// This demonstrates the Use Case pattern from Clean Architecture, where
/// each use case represents a single business operation.
class GetDashboardStatsUseCase {
  final DashboardRepository repository;

  GetDashboardStatsUseCase({required this.repository});

  /// Execute the use case to get dashboard statistics
  ///
  /// Returns [DashboardStatsEntity] with aggregated data
  /// Throws exception if operation fails
  Future<DashboardStatsEntity> call() async {
    return await repository.getDashboardStats();
  }

  /// Alternative method name for clarity (same as call)
  Future<DashboardStatsEntity> execute() async {
    return await call();
  }
}
