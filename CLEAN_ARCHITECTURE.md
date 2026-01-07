# Clean Architecture Project Structure

This Flutter project implements **Clean Architecture** with a counter app that includes increment and decrement functionality.

## Architecture Overview

The project is organized into three main layers:

### 1. **Presentation Layer** (`presentation/`)
Handles UI and state management. Uses Provider for state management.

```
presentation/
├── app/
│   └── counter_app.dart          # Main app widget with DI setup
├── pages/
│   └── counter_page.dart         # Counter UI page
├── provider/
│   └── counter_provider.dart     # State management using ChangeNotifier
└── widgets/                      # Reusable UI widgets
```

**Key Components:**
- `CounterPage`: The main UI page displaying counter value and action buttons
- `CounterProvider`: ChangeNotifier for managing counter state and use cases

---

### 2. **Domain Layer** (`domain/`)
Contains business logic and interfaces. Independent of frameworks and external dependencies.

```
domain/
├── entities/
│   └── counter_entity.dart       # Counter business model
├── repositories/
│   └── counter_repository.dart   # Abstract repository interface
└── usecases/
    ├── get_counter_usecase.dart
    ├── increment_counter_usecase.dart
    ├── decrement_counter_usecase.dart
    └── reset_counter_usecase.dart
```

**Key Components:**
- `CounterEntity`: Represents the counter data in the domain layer
- `CounterRepository`: Abstract interface for data operations
- `UseCases`: Encapsulate specific business operations (Get, Increment, Decrement, Reset)

---

### 3. **Data Layer** (`data/`)
Implements domain repositories and handles data sources.

```
data/
├── datasources/
│   └── counter_local_datasource.dart  # Local data operations
├── models/
│   └── counter_model.dart             # Data transfer objects
└── repositories/
    └── counter_repository_impl.dart   # Repository implementation
```

**Key Components:**
- `CounterLocalDataSource`: Handles local data operations
- `CounterModel`: Extends CounterEntity, used for data mapping
- `CounterRepositoryImpl`: Implements the abstract repository interface

---

## Dependency Flow

```
Presentation Layer (CounterPage/CounterProvider)
        ↓
   Use Cases (GetCounter, Increment, Decrement, Reset)
        ↓
Domain Repository Interface (CounterRepository)
        ↓
Data Layer (CounterRepositoryImpl)
        ↓
Data Sources (CounterLocalDataSource)
```

---

## File Structure

```
lib/
├── features/
│   └── counter/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── app/
│           ├── pages/
│           ├── provider/
│           └── widgets/
├── core/                         # Core utilities and common code
└── main.dart                     # App entry point
```

---

## Features Implemented

### Counter App Features:
1. **Get Counter**: Retrieve current counter value
2. **Increment**: Increase counter by 1
3. **Decrement**: Decrease counter by 1 (new feature)
4. **Reset**: Reset counter to 0

### UI Features:
- Circular display of counter value
- Increment button (green)
- Decrement button (red)
- Reset button (orange)
- Loading states
- Error handling

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  provider: ^6.0.0
```

---

## How to Run

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

---

## Key Design Principles

1. **Separation of Concerns**: Each layer has a specific responsibility
2. **Dependency Inversion**: High-level modules don't depend on low-level modules; both depend on abstractions
3. **Single Responsibility**: Each class has one reason to change
4. **Open/Closed Principle**: Open for extension, closed for modification
5. **Testability**: Each layer can be tested independently
6. **Maintainability**: Easy to add new features without modifying existing code

---

## Adding New Features

To add a new feature (e.g., multiply counter):

1. **Domain Layer**: Create `multiply_counter_usecase.dart`
2. **Data Layer**: Add multiplication logic to datasource
3. **Presentation Layer**: Add button and handler in `counter_provider.dart` and `counter_page.dart`

No changes needed in the repository interface since the logic stays the same!

---

## Testing Strategy

Each layer can be tested independently:
- **Domain**: Test use cases in isolation
- **Data**: Mock datasources and test repository logic
- **Presentation**: Mock providers and test UI interactions

---

## Best Practices Followed

✅ Entity vs Model separation  
✅ Repository pattern for data access  
✅ Use cases for business logic  
✅ Provider for state management  
✅ Dependency injection in app setup  
✅ Clear folder structure  
✅ Type safety with strong typing  
✅ Error handling  
✅ Loading states  
