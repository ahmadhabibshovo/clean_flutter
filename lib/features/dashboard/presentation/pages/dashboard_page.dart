import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/dashboard_provider.dart';
import '../widgets/dashboard_widgets.dart';

/// Dashboard page that displays aggregated statistics
///
/// This demonstrates proper separation between UI and business logic.
/// The page only handles presentation concerns and delegates all
/// business operations to the provider.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DashboardProvider>().refreshDashboardStats();
            },
            tooltip: 'Refresh Statistics',
          ),
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          // Loading state
          if (provider.isLoading && !provider.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading dashboard statistics...'),
                ],
              ),
            );
          }

          // Error state
          if (provider.hasError && !provider.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.errorMessage ?? 'An error occurred',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        provider.loadDashboardStats();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Success state with data
          if (provider.hasData) {
            final stats = provider.stats!;

            return RefreshIndicator(
              onRefresh: provider.refreshDashboardStats,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header card
                    DashboardHeaderCard(
                      productivityScore: stats.productivityScore,
                      generatedAt: stats.generatedAt,
                    ),
                    const SizedBox(height: 16),

                    // Counter statistics card
                    CounterStatsCard(counterValue: stats.counterValue),
                    const SizedBox(height: 16),

                    // Todo statistics card
                    TodoStatsCard(
                      totalTodos: stats.totalTodos,
                      completedTodos: stats.completedTodos,
                      pendingTodos: stats.pendingTodos,
                      completionRate: stats.completionRate,
                    ),
                    const SizedBox(height: 16),

                    // Combined insights card
                    InsightsCard(stats: stats),

                    // Loading indicator overlay during refresh
                    if (provider.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            );
          }

          // Fallback (should not reach here)
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
