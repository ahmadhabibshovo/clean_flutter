/// Entity representing the counter domain model
class CounterEntity {
  final int value;

  CounterEntity({required this.value});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterEntity &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
