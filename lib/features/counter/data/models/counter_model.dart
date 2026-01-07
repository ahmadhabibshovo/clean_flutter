import '../../domain/entities/counter_entity.dart';

/// Model for counter data
class CounterModel extends CounterEntity {
  CounterModel({required super.value});

  /// Convert CounterEntity to CounterModel
  factory CounterModel.fromEntity(CounterEntity entity) {
    return CounterModel(value: entity.value);
  }

  /// Convert CounterModel to CounterEntity
  CounterEntity toEntity() {
    return CounterEntity(value: value);
  }

  /// Create from JSON
  factory CounterModel.fromJson(Map<String, dynamic> json) {
    return CounterModel(value: json['value'] as int);
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'value': value};
  }
}
