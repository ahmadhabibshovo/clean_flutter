# Clean Architecture Folder Structure - Complete Overview

## Project Tree

```
lib/
│
├── features/
│   └── counter/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── counter_local_datasource.dart
│       │   │       ├── CounterLocalDataSource (interface)
│       │   │       └── CounterLocalDataSourceImpl (implementation)
│       │   │
│       │   ├── models/
│       │   │   └── counter_model.dart
│       │   │       └── CounterModel (extends CounterEntity)
│       │   │
│       │   └── repositories/
│       │       └── counter_repository_impl.dart
│       │           └── CounterRepositoryImpl (implements CounterRepository)
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── counter_entity.dart
│       │   │       └── CounterEntity (domain model)
│       │   │
│       │   ├── repositories/
│       │   │   └── counter_repository.dart
│       │   │       └── CounterRepository (abstract interface)
│       │   │
│       │   └── usecases/
│       │       ├── get_counter_usecase.dart
│       │       ├── increment_counter_usecase.dart
│       │       ├── decrement_counter_usecase.dart
│       │       └── reset_counter_usecase.dart
│       │
│       └── presentation/
│           ├── app/
│           │   └── counter_app.dart
│           │       └── CounterApp (main app with DI setup)
│           │
│           ├── pages/
│           │   └── counter_page.dart
│           │       └── CounterPage (UI page)
│           │
│           ├── provider/
│           │   └── counter_provider.dart
│           │       └── CounterProvider (state management)
│           │
│           └── widgets/
│               └── (Reusable UI components)
│
├── core/
│   └── (Common utilities and core functionality)
│
└── main.dart
    └── Entry point of the application
```

## File Descriptions

### Data Layer

| File | Class | Purpose |
|------|-------|---------|
| `counter_local_datasource.dart` | `CounterLocalDataSource` | Abstract interface for local data operations |
| `counter_local_datasource.dart` | `CounterLocalDataSourceImpl` | Concrete implementation with static counter storage |
| `counter_model.dart` | `CounterModel` | Data model extending CounterEntity for serialization |
| `counter_repository_impl.dart` | `CounterRepositoryImpl` | Concrete repository implementation using datasources |

### Domain Layer

| File | Class | Purpose |
|------|-------|---------|
| `counter_entity.dart` | `CounterEntity` | Domain model representing counter business logic |
| `counter_repository.dart` | `CounterRepository` | Abstract repository interface (contract) |
| `get_counter_usecase.dart` | `GetCounterUseCase` | Encapsulates logic to get counter value |
| `increment_counter_usecase.dart` | `IncrementCounterUseCase` | Encapsulates logic to increment counter |
| `decrement_counter_usecase.dart` | `DecrementCounterUseCase` | Encapsulates logic to decrement counter |
| `reset_counter_usecase.dart` | `ResetCounterUseCase` | Encapsulates logic to reset counter |

### Presentation Layer

| File | Class | Purpose |
|------|-------|---------|
| `counter_app.dart` | `CounterApp` | Sets up DI and routes to CounterPage |
| `counter_page.dart` | `CounterPage` | UI page with counter display and buttons |
| `counter_provider.dart` | `CounterProvider` | State management using ChangeNotifier |

## Layer Responsibilities

### Domain Layer (Pure Business Logic)
- **No External Dependencies**: Framework-agnostic
- **Entities**: Represent core business models
- **Repositories**: Define contracts for data operations
- **Use Cases**: Encapsulate specific business rules

### Data Layer (Implementation Details)
- **Models**: Convert data to/from domain entities
- **Data Sources**: Actual data retrieval/storage
- **Repositories**: Implement domain repository contracts

### Presentation Layer (UI & State)
- **Pages**: Full screen UI components
- **Widgets**: Reusable UI components
- **Providers**: State management and business logic orchestration
- **App**: Root widget and dependency injection

## Installation & Setup

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

## Architecture Pattern Used

- **Pattern**: Clean Architecture
- **State Management**: Provider (ChangeNotifier)
- **Data Storage**: In-memory (static variable)
- **Design Principles**: SOLID principles

## Key Features

✅ **Increment Counter**: Increase value by 1  
✅ **Decrement Counter**: Decrease value by 1 (NEW)  
✅ **Get Counter**: Retrieve current value  
✅ **Reset Counter**: Set value to 0  

## UI Components

- **Counter Display**: Circular badge showing current value
- **Increment Button**: Green button with + icon
- **Decrement Button**: Red button with - icon (NEW)
- **Reset Button**: Orange button with refresh icon
- **Loading Indicator**: Shows during operations
- **Error Display**: Shows any operation errors

## Extending the Architecture

### Adding a New Feature (e.g., Save Counter)

1. **Domain**: Create `save_counter_usecase.dart`
2. **Data**: Update `CounterLocalDataSource` and implementation
3. **Presentation**: Add method to `CounterProvider`
4. **UI**: Add button to `CounterPage`

This structure makes it easy to add features without affecting existing code!
