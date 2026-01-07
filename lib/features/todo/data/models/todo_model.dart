import '../../domain/entities/todo_entity.dart';

/// Model for TODO data - Data Transfer Object (DTO)
///
/// This model is responsible for:
/// - Converting between domain entities and data representations
/// - JSON serialization/deserialization
/// - Database mapping
///
/// Following Clean Architecture, models exist in the Data layer and
/// handle all external format conversions. The Domain layer entities
/// remain pure and unaware of serialization formats.
class TodoModel extends TodoEntity {
  const TodoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.isCompleted,
    required super.createdAt,
    super.updatedAt,
    super.priority,
    super.dueDate,
  });

  /// Convert TodoEntity to TodoModel
  factory TodoModel.fromEntity(TodoEntity entity) {
    return TodoModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      priority: entity.priority,
      dueDate: entity.dueDate,
    );
  }

  /// Convert TodoModel to TodoEntity
  TodoEntity toEntity() {
    return TodoEntity(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      priority: priority,
      dueDate: dueDate,
    );
  }

  /// Create from JSON (for API/database responses)
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted:
          json['isCompleted'] as bool? ??
          json['is_completed'] as bool? ??
          false,
      createdAt: _parseDateTime(json['createdAt'] ?? json['created_at']),
      updatedAt: json['updatedAt'] != null || json['updated_at'] != null
          ? _parseDateTime(json['updatedAt'] ?? json['updated_at'])
          : null,
      priority: _parsePriority(json['priority']),
      dueDate: json['dueDate'] != null || json['due_date'] != null
          ? _parseDateTime(json['dueDate'] ?? json['due_date'])
          : null,
    );
  }

  /// Convert to JSON (for API/database storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'priority': priority.level,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  /// Convert to JSON with snake_case keys (for some APIs)
  Map<String, dynamic> toJsonSnakeCase() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'priority': priority.level,
      'due_date': dueDate?.toIso8601String(),
    };
  }

  /// Copy with new values
  @override
  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    TodoPriority? priority,
    DateTime? dueDate,
  }) {
    return TodoModel(
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

  /// Parse DateTime from various formats
  static DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return DateTime.now();
  }

  /// Parse TodoPriority from various formats
  static TodoPriority _parsePriority(dynamic value) {
    if (value is TodoPriority) return value;
    if (value is int) return TodoPriority.fromLevel(value);
    if (value is String) {
      return TodoPriority.values.firstWhere(
        (p) => p.name.toLowerCase() == value.toLowerCase(),
        orElse: () => TodoPriority.medium,
      );
    }
    return TodoPriority.medium;
  }
}
