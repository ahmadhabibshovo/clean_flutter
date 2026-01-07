import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/dashboard_stats_entity.dart';

/// Dashboard Header Card displaying overall productivity score
///
/// Following Component-Based Architecture and SRP
class DashboardHeaderCard extends StatelessWidget {
  final int productivityScore;
  final DateTime generatedAt;

  const DashboardHeaderCard({
    super.key,
    required this.productivityScore,
    required this.generatedAt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('MMM dd, yyyy - hh:mm a');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.dashboard, size: 48, color: Colors.white),
            const SizedBox(height: 16),
            const Text(
              'Productivity Score',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              productivityScore.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Updated: ${timeFormat.format(generatedAt)}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

/// Counter Statistics Card
///
/// Displays counter-related metrics
class CounterStatsCard extends StatelessWidget {
  final int counterValue;

  const CounterStatsCard({super.key, required this.counterValue});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calculate,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Counter Statistics',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            _StatRow(
              label: 'Current Value',
              value: counterValue.toString(),
              icon: Icons.numbers,
              valueColor: counterValue > 0
                  ? Colors.green
                  : counterValue < 0
                  ? Colors.red
                  : Colors.grey,
            ),
            const SizedBox(height: 12),
            _InfoChip(
              label: counterValue > 0
                  ? 'Positive value'
                  : counterValue < 0
                  ? 'Negative value'
                  : 'At zero',
              color: counterValue > 0
                  ? Colors.green.shade100
                  : counterValue < 0
                  ? Colors.red.shade100
                  : Colors.grey.shade200,
            ),
          ],
        ),
      ),
    );
  }
}

/// Todo Statistics Card
///
/// Displays todo-related metrics with completion tracking
class TodoStatsCard extends StatelessWidget {
  final int totalTodos;
  final int completedTodos;
  final int pendingTodos;
  final double completionRate;

  const TodoStatsCard({
    super.key,
    required this.totalTodos,
    required this.completedTodos,
    required this.pendingTodos,
    required this.completionRate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.checklist,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Todo Statistics',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            _StatRow(
              label: 'Total Todos',
              value: totalTodos.toString(),
              icon: Icons.list,
            ),
            const SizedBox(height: 12),
            _StatRow(
              label: 'Completed',
              value: completedTodos.toString(),
              icon: Icons.check_circle,
              valueColor: Colors.green,
            ),
            const SizedBox(height: 12),
            _StatRow(
              label: 'Pending',
              value: pendingTodos.toString(),
              icon: Icons.pending,
              valueColor: Colors.orange,
            ),
            const SizedBox(height: 16),
            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Completion Rate',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${completionRate.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _getCompletionColor(completionRate),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: completionRate / 100,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getCompletionColor(completionRate),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCompletionColor(double rate) {
    if (rate >= 75) return Colors.green;
    if (rate >= 50) return Colors.blue;
    if (rate >= 25) return Colors.orange;
    return Colors.red;
  }
}

/// Insights Card showing analysis and recommendations
///
/// Demonstrates business logic presentation
class InsightsCard extends StatelessWidget {
  final DashboardStatsEntity stats;

  const InsightsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final insights = _generateInsights();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber.shade700, size: 32),
                const SizedBox(width: 12),
                const Text(
                  'Insights',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            ...insights.map(
              (insight) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(insight.icon, size: 20, color: insight.color),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        insight.message,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_Insight> _generateInsights() {
    final insights = <_Insight>[];

    // Productivity score insight
    if (stats.productivityScore > 100) {
      insights.add(
        _Insight(
          icon: Icons.trending_up,
          message: 'Excellent productivity! You\'re on fire! 🔥',
          color: Colors.green,
        ),
      );
    } else if (stats.productivityScore > 50) {
      insights.add(
        _Insight(
          icon: Icons.thumb_up,
          message: 'Good progress. Keep it up!',
          color: Colors.blue,
        ),
      );
    } else {
      insights.add(
        _Insight(
          icon: Icons.info,
          message:
              'Start using the counter and completing todos to increase your score.',
          color: Colors.orange,
        ),
      );
    }

    // Todo completion insight
    if (stats.totalTodos > 0) {
      if (stats.completionRate >= 75) {
        insights.add(
          _Insight(
            icon: Icons.star,
            message:
                'Great job! ${stats.completionRate.toStringAsFixed(0)}% of todos completed.',
            color: Colors.green,
          ),
        );
      } else if (stats.pendingTodos > 5) {
        insights.add(
          _Insight(
            icon: Icons.warning,
            message:
                'You have ${stats.pendingTodos} pending todos. Time to get them done!',
            color: Colors.orange,
          ),
        );
      }
    } else {
      insights.add(
        _Insight(
          icon: Icons.add_task,
          message: 'No todos yet. Create your first todo to get started!',
          color: Colors.blue,
        ),
      );
    }

    // Counter usage insight
    if (stats.counterValue.abs() > 10) {
      insights.add(
        _Insight(
          icon: Icons.insights,
          message:
              'Counter is actively being used. Value: ${stats.counterValue}',
          color: Colors.purple,
        ),
      );
    }

    return insights;
  }
}

/// Private helper widgets following composition pattern

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _Insight {
  final IconData icon;
  final String message;
  final Color color;

  _Insight({required this.icon, required this.message, required this.color});
}
