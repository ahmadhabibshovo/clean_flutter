// Example Unit Tests for Clean Architecture Counter App
// 
// This file shows how to test each layer independently
// Run with: flutter test test/features/counter/
// 
// ==============================================================

// DOMAIN LAYER TESTS
// ==============================================================

// test/features/counter/domain/usecases/increment_counter_usecase_test.dart
/*
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:clean/features/counter/domain/entities/counter_entity.dart';
import 'package:clean/features/counter/domain/repositories/counter_repository.dart';
import 'package:clean/features/counter/domain/usecases/increment_counter_usecase.dart';

class MockCounterRepository extends Mock implements CounterRepository {}

void main() {
  late IncrementCounterUseCase useCase;
  late MockCounterRepository mockRepository;

  setUp(() {
    mockRepository = MockCounterRepository();
    useCase = IncrementCounterUseCase(repository: mockRepository);
  });

  test(
    'should call repository.increment() and return updated entity',
    () async {
      // Arrange
      final tCounterEntity = CounterEntity(value: 5);
      when(mockRepository.increment()).thenAnswer((_) async => tCounterEntity);

      // Act
      final result = await useCase();

      // Assert
      expect(result, tCounterEntity);
      verify(mockRepository.increment()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
*/

// test/features/counter/domain/usecases/decrement_counter_usecase_test.dart
/*
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:clean/features/counter/domain/entities/counter_entity.dart';
import 'package:clean/features/counter/domain/repositories/counter_repository.dart';
import 'package:clean/features/counter/domain/usecases/decrement_counter_usecase.dart';

class MockCounterRepository extends Mock implements CounterRepository {}

void main() {
  late DecrementCounterUseCase useCase;
  late MockCounterRepository mockRepository;

  setUp(() {
    mockRepository = MockCounterRepository();
    useCase = DecrementCounterUseCase(repository: mockRepository);
  });

  test(
    'should call repository.decrement() and return updated entity',
    () async {
      // Arrange
      final tCounterEntity = CounterEntity(value: 3);
      when(mockRepository.decrement()).thenAnswer((_) async => tCounterEntity);

      // Act
      final result = await useCase();

      // Assert
      expect(result, tCounterEntity);
      verify(mockRepository.decrement()).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
*/

// ==============================================================

// DATA LAYER TESTS
// ==============================================================

// test/features/counter/data/repositories/counter_repository_impl_test.dart
/*
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:clean/features/counter/data/datasources/counter_local_datasource.dart';
import 'package:clean/features/counter/data/models/counter_model.dart';
import 'package:clean/features/counter/data/repositories/counter_repository_impl.dart';
import 'package:clean/features/counter/domain/entities/counter_entity.dart';

class MockCounterLocalDataSource extends Mock implements CounterLocalDataSource {}

void main() {
  late CounterRepositoryImpl repository;
  late MockCounterLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockCounterLocalDataSource();
    repository = CounterRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  test(
    'should return CounterEntity when increment is called',
    () async {
      // Arrange
      final tCounterModel = CounterModel(value: 5);
      when(mockLocalDataSource.increment()).thenAnswer((_) async => tCounterModel);

      // Act
      final result = await repository.increment();

      // Assert
      expect(result, isA<CounterEntity>());
      expect(result.value, 5);
      verify(mockLocalDataSource.increment()).called(1);
    },
  );

  test(
    'should return CounterEntity when decrement is called',
    () async {
      // Arrange
      final tCounterModel = CounterModel(value: 3);
      when(mockLocalDataSource.decrement()).thenAnswer((_) async => tCounterModel);

      // Act
      final result = await repository.decrement();

      // Assert
      expect(result, isA<CounterEntity>());
      expect(result.value, 3);
      verify(mockLocalDataSource.decrement()).called(1);
    },
  );
}
*/

// ==============================================================

// PRESENTATION LAYER TESTS
// ==============================================================

// test/features/counter/presentation/provider/counter_provider_test.dart
/*
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:clean/features/counter/domain/entities/counter_entity.dart';
import 'package:clean/features/counter/domain/usecases/decrement_counter_usecase.dart';
import 'package:clean/features/counter/domain/usecases/get_counter_usecase.dart';
import 'package:clean/features/counter/domain/usecases/increment_counter_usecase.dart';
import 'package:clean/features/counter/domain/usecases/reset_counter_usecase.dart';
import 'package:clean/features/counter/presentation/provider/counter_provider.dart';

class MockGetCounterUseCase extends Mock implements GetCounterUseCase {}
class MockIncrementCounterUseCase extends Mock implements IncrementCounterUseCase {}
class MockDecrementCounterUseCase extends Mock implements DecrementCounterUseCase {}
class MockResetCounterUseCase extends Mock implements ResetCounterUseCase {}

void main() {
  late CounterProvider provider;
  late MockGetCounterUseCase mockGetUseCase;
  late MockIncrementCounterUseCase mockIncrementUseCase;
  late MockDecrementCounterUseCase mockDecrementUseCase;
  late MockResetCounterUseCase mockResetUseCase;

  setUp(() {
    mockGetUseCase = MockGetCounterUseCase();
    mockIncrementUseCase = MockIncrementCounterUseCase();
    mockDecrementUseCase = MockDecrementCounterUseCase();
    mockResetUseCase = MockResetCounterUseCase();

    provider = CounterProvider(
      getCounterUseCase: mockGetUseCase,
      incrementCounterUseCase: mockIncrementUseCase,
      decrementCounterUseCase: mockDecrementUseCase,
      resetCounterUseCase: mockResetUseCase,
    );
  });

  test('initial state should be loading', () {
    expect(provider.isLoading, false);
    expect(provider.counter, null);
    expect(provider.error, null);
  });

  test(
    'should update counter and set loading to false when initCounter succeeds',
    () async {
      // Arrange
      final tCounterEntity = CounterEntity(value: 0);
      when(mockGetUseCase()).thenAnswer((_) async => tCounterEntity);

      // Act
      await provider.initCounter();

      // Assert
      expect(provider.counter, tCounterEntity);
      expect(provider.isLoading, false);
      expect(provider.error, null);
    },
  );

  test(
    'should increment counter value',
    () async {
      // Arrange
      final tCounterEntity = CounterEntity(value: 1);
      when(mockIncrementUseCase()).thenAnswer((_) async => tCounterEntity);

      // Act
      await provider.increment();

      // Assert
      expect(provider.counter, tCounterEntity);
      verify(mockIncrementUseCase()).called(1);
    },
  );

  test(
    'should decrement counter value',
    () async {
      // Arrange
      final tCounterEntity = CounterEntity(value: -1);
      when(mockDecrementUseCase()).thenAnswer((_) async => tCounterEntity);

      // Act
      await provider.decrement();

      // Assert
      expect(provider.counter, tCounterEntity);
      verify(mockDecrementUseCase()).called(1);
    },
  );

  test(
    'should reset counter to 0',
    () async {
      // Arrange
      final tCounterEntity = CounterEntity(value: 0);
      when(mockResetUseCase()).thenAnswer((_) async => tCounterEntity);

      // Act
      await provider.reset();

      // Assert
      expect(provider.counter, tCounterEntity);
      verify(mockResetUseCase()).called(1);
    },
  );

  test(
    'should set error when usecase throws exception',
    () async {
      // Arrange
      when(mockIncrementUseCase()).thenThrow('Test Error');

      // Act
      await provider.increment();

      // Assert
      expect(provider.error, isNotEmpty);
      expect(provider.isLoading, false);
    },
  );
}
*/

// ==============================================================

// INTEGRATION TEST
// ==============================================================

// test_driver/integration_test.dart
/*
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Counter App Integration Tests', () {
    testWidgets('Counter app should increment and decrement',
        (WidgetTester tester) async {
      // Build the app
      // await tester.pumpWidget(const CounterApp());

      // Verify initial value is 0
      expect(find.text('0'), findsOneWidget);

      // Tap increment button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify value is 1
      expect(find.text('1'), findsOneWidget);

      // Tap decrement button
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      // Verify value is 0
      expect(find.text('0'), findsOneWidget);

      // Tap reset button
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Verify value is still 0
      expect(find.text('0'), findsOneWidget);
    });
  });
}
*/

// ==============================================================

// TESTING BEST PRACTICES
// ==============================================================

/*
1. UNIT TESTS (Test individual functions)
   - Test each use case independently
   - Mock all dependencies
   - Test happy path and error cases
   - Use 'arrange', 'act', 'assert' pattern

2. WIDGET TESTS (Test UI components)
   - Test widgets in isolation
   - Mock providers and repositories
   - Verify UI rebuilds on state changes
   - Test user interactions

3. INTEGRATION TESTS (Test entire flow)
   - Test app as a whole
   - No mocking
   - Test real user scenarios
   - Slower but more comprehensive

4. TESTING EACH LAYER

   DOMAIN LAYER:
   - Test use cases call repository methods
   - Verify correct parameters passed
   - Check return values

   DATA LAYER:
   - Test repository calls data source
   - Mock data sources
   - Verify model/entity conversion

   PRESENTATION LAYER:
   - Test provider state management
   - Mock use cases
   - Test UI updates based on state
   - Test error handling

5. MOCKING STRATEGIES
   - Use mockito for easy mocking
   - Create mock classes for interfaces
   - Use 'when().thenAnswer()' for async
   - Verify method calls with 'verify()'

6. RUN TESTS
   flutter test
   flutter test --coverage
   flutter test test/features/counter/
*/

// print('See comments above for test examples');
