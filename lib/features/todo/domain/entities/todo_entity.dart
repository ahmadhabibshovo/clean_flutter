/// Entity representing a TODO item in the domain layer
///
/// This is a pure domain entity following Clean Architecture principles:
/// - Immutable (all fields are final)
/// - No dependencies on frameworks or external libraries
/// - Contains business logic related to the TODO concept
/// - Value object semantics (equality based on value, not identity)
///
/// The TodoEntity encapsulates all the essential attributes and behaviors
/// of a TODO item as understood by the business domain.
class TodoEntity {
  /// Unique identifier for the todo
  final String id;

  /// Title of the todo item
  final String title;

  /// Detailed description (optional)
  final String description;

  /// Whether the todo has been completed
  final bool isCompleted;

  /// When the todo was created
  final DateTime createdAt;

  /// When the todo was last updated (optional)
  final DateTime? updatedAt;

  /// Priority level (optional business rule)
  final TodoPriority priority;

  /// Due date for the todo (optional)
  final DateTime? dueDate;

  /// Creates a new TodoEntity
  const TodoEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.updatedAt,
    this.priority = TodoPriority.medium,
    this.dueDate,
  });

  /// Factory constructor for creating a new todo with generated values
  factory TodoEntity.create({
    required String title,
    String description = '',
    TodoPriority priority = TodoPriority.medium,
    DateTime? dueDate,
  }) {
    final now = DateTime.now();
    return TodoEntity(
      id: now.millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: false,
      createdAt: now,
      priority: priority,
      dueDate: dueDate,
    );
  }

  /// Check if the todo is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// Check if the todo is due today
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  /// Check if the todo has a description
  bool get hasDescription => description.isNotEmpty;

  /// Get a short preview of the description
  String get descriptionPreview {
    if (description.length <= 50) return description;
    return '${description.substring(0, 47)}...';
  }

  /// Creates a copy with the provided values
  TodoEntity copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    TodoPriority? priority,
    DateTime? dueDate,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  /// Returns a new entity with toggled completion status
  TodoEntity toggle() {
    return copyWith(isCompleted: !isCompleted, updatedAt: DateTime.now());
  }

  /// Returns a new entity marked as completed
  TodoEntity complete() {
    return copyWith(isCompleted: true, updatedAt: DateTime.now());
  }

  /// Returns a new entity marked as incomplete
  TodoEntity uncomplete() {
    return copyWith(isCompleted: false, updatedAt: DateTime.now());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          isCompleted == other.isCompleted &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      isCompleted.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'TodoEntity(id: $id, title: $title, isCompleted: $isCompleted, '
        'priority: ${priority.name}, isOverdue: $isOverdue)';
  }
}

/// Enumeration for todo priority levels
///
/// Following domain-driven design, this enum represents a bounded
/// set of priority values that have business meaning.
enum TodoPriority {
  low(1, 'Low'),
  medium(2, 'Medium'),
  high(3, 'High'),
  urgent(4, 'Urgent');

  final int level;
  final String displayName;

  const TodoPriority(this.level, this.displayName);

  /// Compare priorities
  bool isHigherThan(TodoPriority other) => level > other.level;
  bool isLowerThan(TodoPriority other) => level < other.level;

  /// Create from level
  static TodoPriority fromLevel(int level) {
    return TodoPriority.values.firstWhere(
      (p) => p.level == level,
      orElse: () => TodoPriority.medium,
    );
  }
}
