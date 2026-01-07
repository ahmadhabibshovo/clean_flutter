# Complete Clean Architecture Visual Guide

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                          │
│                    (UI & State Management)                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐ │
│  │  CounterPage     │  │ CounterProvider  │  │ CounterApp   │ │
│  │  (UI Widgets)    │  │ (ChangeNotifier) │  │ (Setup & DI) │ │
│  └────────┬─────────┘  └────────┬─────────┘  └──────────────┘ │
│           │                    │                               │
│           └────────┬───────────┘                               │
│                    │                                           │
│            Calls use cases from                                │
│            CounterProvider                                     │
│                                                                 │
└────────────────────┬─────────────────────────────────────────────┘
                     │
                     │ Depends on
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                               │
│              (Pure Business Logic & Contracts)                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐  ┌────────────────────┐  ┌──────────────┐   │
│  │ CounterEntity│  │CounterRepository   │  │  Use Cases   │   │
│  │              │  │(Abstract Interface)│  │              │   │
│  │- value: int  │  │                    │  │- GetCounter  │   │
│  └──────────────┘  │- getCounter()      │  │- Increment   │   │
│                    │- increment()       │  │- Decrement   │   │
│                    │- decrement()       │  │- Reset       │   │
│                    │- reset()           │  │              │   │
│                    └────────────────────┘  └──────────────┘   │
│                                                                  │
│         (NO FRAMEWORK DEPENDENCIES - Framework Independent)     │
│                                                                  │
└────────────────────┬─────────────────────────────────────────────┘
                     │
                     │ Implemented by
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│                       DATA LAYER                                │
│                  (Implementation & Storage)                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────┐  ┌────────────────────┐ ┌──────────────┐ │
│  │ CounterModel     │  │ CounterRepository │ │ CounterLocal │ │
│  │                  │  │ Impl               │ │ DataSource   │ │
│  │- extends         │  │                    │ │              │ │
│  │  CounterEntity   │  │- delegates to      │ │- getCounter()│ │
│  │- toJson()        │  │  datasource        │ │- increment() │ │
│  │- fromJson()      │  │- converts to Entity│ │- decrement() │ │
│  │- toEntity()      │  │                    │ │- reset()     │ │
│  └──────────────────┘  └────────────────────┘ └──────────────┘ │
│                                                                  │
│      (Concrete implementations, handles storage)                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Data Flow - User Clicks Increment

```
┌────────────────────────────────────────────────────────────────┐
│ User clicks Increment Button                                   │
└────────────────────┬─────────────────────────────────────────────┘
                     │
                     ▼
         ┌─────────────────────────┐
         │ CounterPage (UI)        │
         │ onPressed: () {         │
         │   provider.increment()  │
         │ }                       │
         └────────────┬────────────┘
                      │
                      ▼
        ┌────────────────────────────┐
        │ CounterProvider            │
        │ .increment()               │
        │ {                          │
        │  _setLoading(true)         │
        │ }                          │
        └───────────┬────────────────┘
                    │
                    ▼
     ┌──────────────────────────────┐
     │ IncrementCounterUseCase      │
     │ .call()                      │
     │ {                            │
     │  return                      │
     │    repository.increment()    │
     │ }                            │
     └──────────┬───────────────────┘
                │
                ▼
    ┌───────────────────────────────┐
    │ CounterRepositoryImpl          │
    │ .increment()                  │
    │ {                             │
    │  final model =                │
    │    datasource.increment()     │
    │  return model.toEntity()      │
    │ }                             │
    └──────────┬────────────────────┘
               │
               ▼
   ┌────────────────────────────────┐
   │ CounterLocalDataSourceImpl      │
   │ .increment()                   │
   │ {                              │
   │  _counterValue++               │
   │  return CounterModel(value: _) │
   │ }                              │
   └──────────┬─────────────────────┘
              │
              ▼
   Returns Model → Entity → Provider → Notifies → UI Rebuilds
```

---

## 📦 Class Dependencies

```
CounterPage
  └─> uses: CounterProvider

CounterProvider (ChangeNotifier)
  ├─> uses: GetCounterUseCase
  ├─> uses: IncrementCounterUseCase
  ├─> uses: DecrementCounterUseCase
  └─> uses: ResetCounterUseCase

GetCounterUseCase
  └─> uses: CounterRepository (abstract)

IncrementCounterUseCase
  └─> uses: CounterRepository (abstract)

DecrementCounterUseCase
  └─> uses: CounterRepository (abstract)

ResetCounterUseCase
  └─> uses: CounterRepository (abstract)

CounterRepositoryImpl (implements CounterRepository)
  └─> uses: CounterLocalDataSource (abstract)

CounterLocalDataSourceImpl (implements CounterLocalDataSource)
  └─> manages: _counterValue (static int)

CounterModel (extends CounterEntity)
  └─> used by: CounterLocalDataSourceImpl

CounterEntity
  └─> value: int
```

---

## 🎯 Layer Responsibilities

```
┌─────────────────────────────────────────────────────────────────┐
│ PRESENTATION LAYER                                              │
├─────────────────────────────────────────────────────────────────┤
│ What: Show UI to user, handle user input, manage screen state   │
│ Who: CounterPage, CounterProvider, CounterApp                  │
│ Depends on: Domain Layer (UseCases)                            │
│ Knows about: Flutter, Provider, ChangeNotifier                │
│ Tests: Widget tests, Provider tests                            │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ DOMAIN LAYER                                                    │
├─────────────────────────────────────────────────────────────────┤
│ What: Define business logic contracts and operations            │
│ Who: Entities, Repositories (interfaces), UseCases             │
│ Depends on: Nothing! (Framework Independent)                   │
│ Knows about: Business rules only                               │
│ Tests: Unit tests (no mocking needed for domain)              │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ DATA LAYER                                                      │
├─────────────────────────────────────────────────────────────────┤
│ What: Implement data access and storage                         │
│ Who: Models, Repositories (impl), DataSources                 │
│ Depends on: Domain Layer (abstractions)                        │
│ Knows about: How to get/store data                            │
│ Tests: Unit tests with mocked datasources                     │
└─────────────────────────────────────────────────────────────────┘
```

---

## 💾 State Management Flow

```
User Action (Button Press)
    │
    ▼
CounterPage calls provider.increment()
    │
    ▼
CounterProvider._setLoading(true)
    │
    ├─> notifyListeners()
    │   └─> Listeners rebuild with isLoading=true
    │
    ▼
CounterProvider calls use case
    │
    ▼
Use case returns result
    │
    ▼
CounterProvider updates counter value
    │
    ├─> _counter = result
    ├─> _error = null
    │
    ▼
CounterProvider._setLoading(false)
    │
    ├─> notifyListeners()
    │   └─> Listeners rebuild with new counter value
    │
    ▼
CounterPage rebuilds
    │
    ▼
UI displays new value
```

---

## 🧩 Dependency Injection Setup

```
CounterApp.build()
│
├─> Creates CounterLocalDataSourceImpl instance
│
├─> Creates CounterRepositoryImpl(datasource)
│
├─> Creates GetCounterUseCase(repository)
├─> Creates IncrementCounterUseCase(repository)
├─> Creates DecrementCounterUseCase(repository)
├─> Creates ResetCounterUseCase(repository)
│
├─> Creates CounterProvider(
│     getCounterUseCase: ...,
│     incrementCounterUseCase: ...,
│     decrementCounterUseCase: ...,
│     resetCounterUseCase: ...
│   )
│
└─> Provides via ChangeNotifierProvider
    └─> CounterPage can access via context.read<CounterProvider>()
```

---

## 🔁 Benefits Visualization

```
WITHOUT CLEAN ARCHITECTURE          WITH CLEAN ARCHITECTURE
────────────────────────────────────────────────────────────

Business Logic in UI               Business Logic in Domain
  ❌ Hard to test                    ✅ Easy to test
  ❌ Hard to reuse                   ✅ Easy to reuse
  ❌ Tightly coupled                 ✅ Loosely coupled

Data Access in UI                  Data Access in Data Layer
  ❌ Hard to change                  ✅ Easy to change
  ❌ Hard to mock                    ✅ Easy to mock
  ❌ Framework dependent             ✅ Framework independent

Add new feature = Modify all       Add new feature = Add new files
  ❌ High risk of breaking           ✅ Low risk of breaking
  ❌ Hard to maintain                ✅ Easy to maintain
  ❌ Test everything again           ✅ Test only new code
```

---

## 📊 File Organization

```
lib/
│
├── features/
│   └── counter/                    ← Feature folder
│       │
│       ├── data/                   ← Data Layer
│       │   ├── datasources/
│       │   │   └── counter_local_datasource.dart
│       │   ├── models/
│       │   │   └── counter_model.dart
│       │   └── repositories/
│       │       └── counter_repository_impl.dart
│       │
│       ├── domain/                 ← Domain Layer
│       │   ├── entities/
│       │   │   └── counter_entity.dart
│       │   ├── repositories/
│       │   │   └── counter_repository.dart
│       │   └── usecases/
│       │       ├── get_counter_usecase.dart
│       │       ├── increment_counter_usecase.dart
│       │       ├── decrement_counter_usecase.dart
│       │       └── reset_counter_usecase.dart
│       │
│       └── presentation/           ← Presentation Layer
│           ├── app/
│           │   └── counter_app.dart
│           ├── pages/
│           │   └── counter_page.dart
│           ├── provider/
│           │   └── counter_provider.dart
│           └── widgets/
│
├── core/                           ← Shared utilities
│
└── main.dart                       ← Entry point
```

---

## ✅ Principles Used

```
┌──────────────────────────────────────────────────────────┐
│ SOLID PRINCIPLES                                         │
├──────────────────────────────────────────────────────────┤
│ S - Single Responsibility                                │
│     Each class has one reason to change                  │
│     ✅ CounterEntity (model), CounterRepository (contract)│
│                                                          │
│ O - Open/Closed                                          │
│     Open for extension, closed for modification          │
│     ✅ Add new use cases without changing existing code  │
│                                                          │
│ L - Liskov Substitution                                  │
│     Subtypes must be substitutable for base types       │
│     ✅ Any CounterRepository impl can replace another    │
│                                                          │
│ I - Interface Segregation                                │
│     Many client-specific interfaces                      │
│     ✅ CounterRepository interface only what's needed    │
│                                                          │
│ D - Dependency Inversion                                 │
│     Depend on abstractions, not concrete details         │
│     ✅ Provider depends on abstract CounterRepository    │
└──────────────────────────────────────────────────────────┘
```

---

## 🎓 Learning Path

```
1. Start Here
   └─> QUICK_REFERENCE.md

2. Understand Structure
   └─> PROJECT_STRUCTURE.md

3. Learn Architecture
   └─> CLEAN_ARCHITECTURE.md

4. Study Code Flow
   └─> ARCHITECTURE_DIAGRAM.dart

5. Review Implementation
   └─> Read domain/ → data/ → presentation/

6. Add Tests
   └─> TESTING_EXAMPLES.dart

7. Extend It
   └─> Add new features following the pattern
```

---

## 🎯 Quick Summary

**What is Clean Architecture?**
- Separation of code into independent layers
- Each layer has specific responsibility
- Easy to test, maintain, and extend

**Why use it?**
- ✅ Code organization
- ✅ Easy testing
- ✅ Code reusability
- ✅ Easy to change implementations
- ✅ Team collaboration

**Layers:**
1. **Domain** - What needs to be done (business logic)
2. **Data** - How to get/store data (implementation)
3. **Presentation** - How to show to user (UI)

**Direction of Dependency:**
- Presentation depends on Domain
- Data depends on Domain
- Domain depends on nothing!

That's it! You now understand clean architecture! 🎉
