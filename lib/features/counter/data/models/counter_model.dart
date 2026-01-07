import '../../domain/entities/counter_entity.dart';

/// Model for counter data - Data Transfer Object (DTO)
///
/// This model is responsible for:
/// - Converting between domain entities and data representations
/// - JSON serialization/deserialization
/// - Database mapping
///
/// Following Clean Architecture, models exist in the Data layer and
/// handle all external format conversions. The Domain layer entities
/// remain pure and unaware of serialization formats.
class CounterModel extends CounterEntity {
  /// Additional data layer fields for persistence
  final DateTime? lastUpdated;
  final String? userId;

  const CounterModel({required super.value, this.lastUpdated, this.userId});

  /// Convert CounterEntity to CounterModel
  factory CounterModel.fromEntity(CounterEntity entity) {
    return CounterModel(value: entity.value, lastUpdated: DateTime.now());
  }

  /// Factory constructor for a zero counter
  factory CounterModel.zero() =>
      CounterModel(value: 0, lastUpdated: DateTime.now());

  /// Convert CounterModel to CounterEntity
  CounterEntity toEntity() {
    return CounterEntity(value: value);
  }

  /// Create from JSON (for API/database responses)
  factory CounterModel.fromJson(Map<String, dynamic> json) {
    return CounterModel(
      value: json['value'] as int? ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
      userId: json['userId'] as String?,
    );
  }

  /// Convert to JSON (for API/database storage)
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'userId': userId,
    };
  }

  /// Copy with new values
  @override
  CounterModel copyWith({int? value, DateTime? lastUpdated, String? userId}) {
    return CounterModel(
      value: value ?? this.value,
      lastUpdated: lastUpdated ?? DateTime.now(),
      userId: userId ?? this.userId,
    );
  }

  /// Create incremented model
  CounterModel incrementModel([int by = 1]) {
    return copyWith(
      value: (value + by).clamp(CounterEntity.minValue, CounterEntity.maxValue),
      lastUpdated: DateTime.now(),
    );
  }

  /// Create decremented model
  CounterModel decrementModel([int by = 1]) {
    return copyWith(
      value: (value - by).clamp(CounterEntity.minValue, CounterEntity.maxValue),
      lastUpdated: DateTime.now(),
    );
  }

  /// Create reset model
  CounterModel resetModel() {
    return copyWith(value: 0, lastUpdated: DateTime.now());
  }

  @override
  String toString() =>
      'CounterModel(value: $value, lastUpdated: $lastUpdated, userId: $userId)';
}

extension CounterEntityExtension on CounterEntity {
  /// Convert entity to model
  CounterModel toModel() => CounterModel.fromEntity(this);

  /// Convert entity to JSON via model
  Map<String, dynamic> toJson() => toModel().toJson();
}
