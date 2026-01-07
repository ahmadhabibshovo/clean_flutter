import '../../domain/entities/counter_entity.dart';
import '../../domain/repositories/counter_repository.dart';
import '../datasources/counter_local_datasource.dart';

/// Implementation of counter repository
class CounterRepositoryImpl implements CounterRepository {
  final CounterLocalDataSource localDataSource;

  CounterRepositoryImpl({required this.localDataSource});

  @override
  Future<CounterEntity> getCounter() async {
    final model = await localDataSource.getCounter();
    return model.toEntity();
  }

  @override
  Future<CounterEntity> increment() async {
    final model = await localDataSource.increment();
    return model.toEntity();
  }

  @override
  Future<CounterEntity> decrement() async {
    final model = await localDataSource.decrement();
    return model.toEntity();
  }

  @override
  Future<CounterEntity> reset() async {
    final model = await localDataSource.reset();
    return model.toEntity();
  }
}
