import 'package:flutter/foundation.dart';

import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import '../../domain/usecases/refresh_dashboard_stats_usecase.dart';

/// Provider for Dashboard feature state management
///
/// Following the Presentation layer responsibilities in Clean Architecture:
/// - Manages UI state
/// - Coordinates between UI and Use Cases
/// - Implements ChangeNotifier for Flutter's reactive UI
///
/// This class doesn't know about repositories or data sources,
/// only about use cases (respecting layer boundaries).
class DashboardProvider extends ChangeNotifier {
  final GetDashboardStatsUseCase getDashboardStatsUseCase;
  final RefreshDashboardStatsUseCase refreshDashboardStatsUseCase;

  /// Current dashboard statistics
  DashboardStatsEntity? _stats;

  /// Loading state for async operations
  bool _isLoading = false;

  /// Error message if operation fails
  String? _errorMessage;

  /// Constructor with dependency injection
  DashboardProvider({
    required this.getDashboardStatsUseCase,
    required this.refreshDashboardStatsUseCase,
  }) {
    // Load initial data when provider is created
    loadDashboardStats();
  }

  // Getters following encapsulation principle
  DashboardStatsEntity? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasData => _stats != null;

  /// Load dashboard statistics
  ///
  /// This method orchestrates the UI flow:
  /// 1. Set loading state
  /// 2. Execute use case
  /// 3. Update state based on result
  /// 4. Notify listeners for UI update
  Future<void> loadDashboardStats() async {
    _setLoadingState(true);
    _clearError();

    try {
      final statsEntity = await getDashboardStatsUseCase.execute();
      _stats = statsEntity;
      _clearError();
    } catch (e) {
      _setError('Failed to load dashboard statistics: ${e.toString()}');
      debugPrint('Error loading dashboard stats: $e');
    } finally {
      _setLoadingState(false);
    }
  }

  /// Refresh dashboard statistics
  ///
  /// Similar to load but uses the refresh use case which may
  /// have different behavior (e.g., cache invalidation)
  Future<void> refreshDashboardStats() async {
    _setLoadingState(true);
    _clearError();

    try {
      final statsEntity = await refreshDashboardStatsUseCase.execute();
      _stats = statsEntity;
      _clearError();
    } catch (e) {
      _setError('Failed to refresh dashboard statistics: ${e.toString()}');
      debugPrint('Error refreshing dashboard stats: $e');
    } finally {
      _setLoadingState(false);
    }
  }

  /// Private helper methods for state management
  /// Following DRY principle and reducing code duplication

  void _setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  /// Clean up resources when provider is disposed
  @override
  void dispose() {
    super.dispose();
  }
}
