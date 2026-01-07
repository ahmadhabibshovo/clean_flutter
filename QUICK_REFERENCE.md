# Quick Reference Guide - Clean Architecture Counter App

## What Was Created

A complete Flutter counter app following **Clean Architecture** principles with three distinct layers:

### 📦 Three Main Layers

```
PRESENTATION → DOMAIN → DATA
   (UI)      (Logic)  (Storage)
```

---

## File List

### Domain Layer (Business Logic)
```
lib/features/counter/domain/
├── entities/
│   └── counter_entity.dart
├── repositories/
│   └── counter_repository.dart
└── usecases/
    ├── get_counter_usecase.dart
    ├── increment_counter_usecase.dart
    ├── decrement_counter_usecase.dart
    └── reset_counter_usecase.dart
```

### Data Layer (Implementation)
```
lib/features/counter/data/
├── datasources/
│   └── counter_local_datasource.dart
├── models/
│   └── counter_model.dart
└── repositories/
    └── counter_repository_impl.dart
```

### Presentation Layer (UI)
```
lib/features/counter/presentation/
├── app/
│   └── counter_app.dart
├── pages/
│   └── counter_page.dart
└── provider/
    └── counter_provider.dart
```

---

## How to Use

### 1. Run the App
```bash
cd /Volumes/Extarnal-512/Home/Documents/clean
flutter pub get
flutter run
```

### 2. Features Available
- ✅ **Increment**: Tap green button to increase counter
- ✅ **Decrement**: Tap red button to decrease counter (NEW!)
- ✅ **Reset**: Tap orange button to reset to 0
- ✅ **Display**: Circular badge shows current value

---

## Quick Understanding

### What Each Layer Does

**Domain Layer** → "WHAT business logic exists?"
- Defines entities (CounterEntity)
- Defines repository contracts (CounterRepository)
- Defines use cases (Increment, Decrement, etc.)

**Data Layer** → "HOW do we get/store data?"
- Implements repositories (CounterRepositoryImpl)
- Provides data sources (CounterLocalDataSource)
- Converts models to entities

**Presentation Layer** → "HOW does user interact?"
- Manages UI state (CounterProvider)
- Displays UI (CounterPage)
- Handles user input

---

## Code Flow Example

**User clicks Increment button:**
```
CounterPage (UI)
  → calls counterProvider.increment()
    → IncrementCounterUseCase().call()
      → CounterRepository.increment()
        → CounterLocalDataSource.increment()
          → Returns new CounterModel
        → Converts to CounterEntity
      → Returns CounterEntity
    → Updates provider state
      → notifyListeners()
        → UI rebuilds with new value
```

---

## Dependency Injection

Setup in `counter_app.dart`:
```dart
// 1. Create datasource
final datasource = CounterLocalDataSourceImpl();

// 2. Create repository
final repository = CounterRepositoryImpl(datasource: datasource);

// 3. Create use cases
final getUseCase = GetCounterUseCase(repository: repository);
final incrementUseCase = IncrementCounterUseCase(repository: repository);
final decrementUseCase = DecrementCounterUseCase(repository: repository);
final resetUseCase = ResetCounterUseCase(repository: repository);

// 4. Provide to widgets via Provider
ChangeNotifierProvider(
  create: (_) => CounterProvider(
    getCounterUseCase: getUseCase,
    incrementCounterUseCase: incrementUseCase,
    decrementCounterUseCase: decrementUseCase,
    resetCounterUseCase: resetUseCase,
  ),
)
```

---

## Why Clean Architecture?

| Benefit | Explanation |
|---------|-------------|
| **Testable** | Each layer can be tested independently |
| **Maintainable** | Clear structure, easy to understand |
| **Scalable** | Easy to add new features |
| **Reusable** | Domain layer doesn't depend on Flutter |
| **Flexible** | Easy to swap implementations (e.g., local → API) |

---

## Adding New Features

### Example: Add Multiply by 2 Button

1. **Domain**: Create `multiply_counter_usecase.dart`
2. **Data**: Add to `CounterLocalDataSource` and impl
3. **Presentation**: Add method to `CounterProvider`
4. **UI**: Add button to `CounterPage`

That's it! No changes needed to existing code.

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  provider: ^6.0.0  # State management
```

---

## Project Files Reference

| File | Purpose |
|------|---------|
| `main.dart` | App entry point |
| `CLEAN_ARCHITECTURE.md` | Detailed architecture explanation |
| `PROJECT_STRUCTURE.md` | Complete file structure |
| `ARCHITECTURE_DIAGRAM.dart` | Visual architecture diagram |
| `pubspec.yaml` | Dependencies (updated with provider) |

---

## Common Questions

**Q: Where is data stored?**  
A: Currently in memory (static variable). Easy to replace with SharedPreferences, Firebase, etc.

**Q: Why three layers?**  
A: Separation of concerns - Domain (business), Data (storage), Presentation (UI).

**Q: Can I skip a layer?**  
A: No - each layer has a specific purpose in Clean Architecture.

**Q: How do I test this?**  
A: Mock each layer independently - test domain logic, data access, and UI separately.

**Q: Can I use BLoC instead of Provider?**  
A: Yes! The domain and data layers don't care about state management. Just update the presentation layer.

---

## Next Steps

1. ✅ Understand the three-layer architecture
2. ✅ Run the app and test all features
3. ✅ Review each file to understand the flow
4. ✅ Try adding a new feature (e.g., double counter)
5. ✅ Consider adding persistence (SharedPreferences)

Enjoy your clean architecture project! 🎉
