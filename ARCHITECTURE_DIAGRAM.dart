// Clean Architecture - Counter App Structure
// 
// PRESENTATION LAYER
// ==================
// 
// CounterApp (counter_app.dart)
//   └─ Sets up dependency injection
//   └─ Provides CounterProvider to widgets
//   └─ Routes to CounterPage
//
// CounterPage (counter_page.dart)
//   └─ Displays counter UI
//   └─ Shows current value
//   └─ Provides buttons: Increment, Decrement, Reset
//   └─ Listens to CounterProvider for state changes
//
// CounterProvider (counter_provider.dart)
//   ├─ Manages counter state using ChangeNotifier
//   ├─ Exposes: counter, isLoading, error
//   ├─ Methods: initCounter(), increment(), decrement(), reset()
//   └─ Calls use cases based on user actions
//
//
// DOMAIN LAYER (Business Logic)
// =============================
//
// Entities:
//   └─ CounterEntity (counter_entity.dart)
//      └─ Represents counter value in domain layer
//
// Repositories (Abstract):
//   └─ CounterRepository (counter_repository.dart)
//      ├─ getCounter(): Future<CounterEntity>
//      ├─ increment(): Future<CounterEntity>
//      ├─ decrement(): Future<CounterEntity>
//      └─ reset(): Future<CounterEntity>
//
// Use Cases:
//   ├─ GetCounterUseCase
//   │  └─ call() → calls repository.getCounter()
//   ├─ IncrementCounterUseCase
//   │  └─ call() → calls repository.increment()
//   ├─ DecrementCounterUseCase
//   │  └─ call() → calls repository.decrement()
//   └─ ResetCounterUseCase
//      └─ call() → calls repository.reset()
//
//
// DATA LAYER (Implementation Details)
// ===================================
//
// Models:
//   └─ CounterModel (counter_model.dart)
//      └─ Extends CounterEntity
//      └─ Handles JSON serialization/deserialization
//      └─ Conversion between Entity and Model
//
// Data Sources:
//   └─ CounterLocalDataSource (counter_local_datasource.dart)
//      ├─ Abstract interface for data operations
//      └─ CounterLocalDataSourceImpl
//         ├─ Static _counterValue = 0
//         ├─ getCounter(): Returns current value
//         ├─ increment(): Increases value
//         ├─ decrement(): Decreases value
//         └─ reset(): Sets value to 0
//
// Repositories (Implementation):
//   └─ CounterRepositoryImpl (counter_repository_impl.dart)
//      └─ Implements abstract CounterRepository
//      └─ Uses CounterLocalDataSource
//      └─ Converts Model → Entity before returning
//
//
// DEPENDENCY INJECTION FLOW
// ==========================
//
// 1. main.dart
//    └─ Calls CounterApp()
//
// 2. CounterApp setup:
//    ├─ Creates CounterLocalDataSourceImpl
//    ├─ Creates CounterRepositoryImpl(datasource)
//    ├─ Creates GetCounterUseCase(repository)
//    ├─ Creates IncrementCounterUseCase(repository)
//    ├─ Creates DecrementCounterUseCase(repository)
//    ├─ Creates ResetCounterUseCase(repository)
//    └─ Provides CounterProvider with all use cases
//
// 3. CounterPage uses CounterProvider
//    └─ Provider handles all business logic
//
//
// DATA FLOW EXAMPLE (User clicks Increment)
// =========================================
//
// User Press Increment
//   ↓
// CounterPage → counterProvider.increment()
//   ↓
// CounterProvider.increment() calls incrementCounterUseCase()
//   ↓
// IncrementCounterUseCase.call() calls repository.increment()
//   ↓
// CounterRepositoryImpl.increment() calls datasource.increment()
//   ↓
// CounterLocalDataSourceImpl.increment()
//   ├─ Increments static _counterValue
//   └─ Returns CounterModel(value: _counterValue)
//   ↓
// CounterRepositoryImpl converts Model → Entity
//   ↓
// CounterProvider receives updated CounterEntity
//   ↓
// CounterProvider calls notifyListeners()
//   ↓
// CounterPage Consumer rebuilds with new value
//   ↓
// UI displays updated counter
//
//
// BENEFITS OF CLEAN ARCHITECTURE
// ===============================
// ✅ Separation of Concerns - Each layer has single responsibility
// ✅ Testability - Each layer can be tested independently
// ✅ Reusability - Domain layer is framework-independent
// ✅ Maintainability - Easy to understand and modify
// ✅ Scalability - Easy to add new features
// ✅ Dependency Inversion - Depend on abstractions, not concrete implementations
