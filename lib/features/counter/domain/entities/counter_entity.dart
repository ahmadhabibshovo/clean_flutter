/// Entity representing the counter domain model
///
/// This is a pure domain entity following Clean Architecture principles:
/// - Immutable (all fields are final)
/// - No dependencies on frameworks or external libraries
/// - Contains only business logic related to the counter concept
/// - Value object semantics (equality based on value, not identity)
///
/// In Clean Architecture, entities are the innermost layer and represent
/// the core business concepts of your application.
class CounterEntity {
  /// The current counter value
  final int value;

  /// Minimum allowed value (business rule)
  static const int minValue = -999999;

  /// Maximum allowed value (business rule)
  static const int maxValue = 999999;

  /// Creates a new CounterEntity
  ///
  /// [value] must be between [minValue] and [maxValue]
  const CounterEntity({required this.value});

  /// Factory constructor for creating a zero counter
  factory CounterEntity.zero() => const CounterEntity(value: 0);

  /// Factory constructor from a raw integer
  factory CounterEntity.fromInt(int value) {
    return CounterEntity(value: value.clamp(minValue, maxValue));
  }

  /// Check if the counter is at its maximum value
  bool get isAtMax => value >= maxValue;

  /// Check if the counter is at its minimum value
  bool get isAtMin => value <= minValue;

  /// Check if the counter is positive
  bool get isPositive => value > 0;

  /// Check if the counter is negative
  bool get isNegative => value < 0;

  /// Check if the counter is zero
  bool get isZero => value == 0;

  /// Get the absolute value
  int get absoluteValue => value.abs();

  /// Creates a copy with the provided value
  CounterEntity copyWith({int? value}) {
    return CounterEntity(value: value ?? this.value);
  }

  /// Returns a new entity with incremented value
  /// Respects the maximum boundary
  CounterEntity increment([int by = 1]) {
    final newValue = (value + by).clamp(minValue, maxValue);
    return CounterEntity(value: newValue);
  }

  /// Returns a new entity with decremented value
  /// Respects the minimum boundary
  CounterEntity decrement([int by = 1]) {
    final newValue = (value - by).clamp(minValue, maxValue);
    return CounterEntity(value: newValue);
  }

  /// Returns a new entity with value reset to zero
  CounterEntity reset() => CounterEntity.zero();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterEntity &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'CounterEntity(value: $value)';
}
