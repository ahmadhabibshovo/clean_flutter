import '../entities/dashboard_stats_entity.dart';
import '../repositories/dashboard_repository.dart';

/// Use case for refreshing dashboard statistics
///
/// Separate from GetDashboardStatsUseCase to follow SRP.
/// This use case handles the specific business logic of refreshing
/// and recalculating all statistics, which may involve clearing caches
/// or forcing data reloads from multiple sources.
class RefreshDashboardStatsUseCase {
  final DashboardRepository repository;

  RefreshDashboardStatsUseCase({required this.repository});

  /// Execute the use case to refresh and get latest statistics
  ///
  /// Returns [DashboardStatsEntity] with freshly computed data
  /// Throws exception if operation fails
  Future<DashboardStatsEntity> call() async {
    return await repository.refreshStats();
  }

  /// Alternative method name for clarity (same as call)
  Future<DashboardStatsEntity> execute() async {
    return await call();
  }
}
