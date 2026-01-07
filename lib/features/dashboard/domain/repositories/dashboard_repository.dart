import '../entities/dashboard_stats_entity.dart';

/// Abstract repository interface for dashboard operations
///
/// Following the Dependency Inversion Principle (DIP), this interface
/// defines what the domain needs without depending on implementation details.
/// The actual implementation will depend on other repositories (Counter & Todo)
/// but the domain layer remains independent.
abstract class DashboardRepository {
  /// Get aggregated statistics from Counter and Todo features
  ///
  /// This method orchestrates data from multiple sources and computes
  /// derived metrics following business rules.
  ///
  /// Returns [DashboardStatsEntity] containing all computed statistics
  /// Throws an exception if data cannot be retrieved
  Future<DashboardStatsEntity> getDashboardStats();

  /// Refresh all cached data and recompute statistics
  ///
  /// Useful for ensuring data consistency across features
  Future<DashboardStatsEntity> refreshStats();
}
