# Frontend Architecture

## Application Structure

```
apps/app/lib/
├── app/
│   ├── app.dart              # Root widget with BLoC providers
│   ├── bootstrap/
│   │   └── app_bootstrap.dart
│   └── routing/
│       └── app_router.dart   # GoRouter configuration
├── core/
│   ├── errors/
│   │   └── app_failure.dart  # Standardized failure types
│   ├── networking/
│   │   └── api_client.dart   # HTTP client with error handling
│   └── shared/
│       └── extensions.dart   # BuildContext extensions
└── features/
    ├── authentication/
    │   ├── bloc/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── household/
    │   ├── bloc/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── programs/
        ├── bloc/
        ├── data/
        ├── domain/
        └── presentation/
```

## Key Patterns

### 1. Feature-First Organization
Each feature is self-contained with:
- `bloc/`: State management (events, states, bloc)
- `data/`: Repository implementations
- `domain/`: Pure Dart models (Freezed)
- `presentation/`: Widgets and screens

### 2. BLoC Pattern
```
Widget dispatches Event
        ↓
    BLoC receives Event
        ↓
    BLoC calls Repository
        ↓
    Repository calls ApiClient
        ↓
    ApiClient calls Serverpod
        ↓
    Response → Repository → Result
        ↓
    BLoC emits new State
        ↓
    Widget rebuilds with new State
```

### 3. Immutable State (Freezed)
```dart
@freezed
sealed class HouseholdState with _$HouseholdState {
  const factory HouseholdState.initial() = HouseholdInitial;
  const factory HouseholdState.loading() = HouseholdLoading;
  const factory HouseholdState.loaded({
    required Household household,
    required List<HouseholdMember> members,
  }) = HouseholdLoaded;
  const factory HouseholdState.failure({
    required AppFailure failure,
  }) = HouseholdFailure;
}
```

### 4. Repository Pattern
- Abstracts data sources
- Returns `Result<T>` (success/failure)
- Testable with mocks

### 5. Error Handling
```dart
@freezed
sealed class AppFailure with _$AppFailure {
  const factory AppFailure.network({required String message, String? code}) = NetworkFailure;
  const factory AppFailure.authentication({required String message, String? code}) = AuthenticationFailure;
  const factory AppFailure.authorization({required String message, String? code}) = AuthorizationFailure;
  const factory AppFailure.validation({required String message, Map<String, String>? fields}) = ValidationFailure;
  const factory AppFailure.server({required String message, int? statusCode}) = ServerFailure;
  const factory AppFailure.unavailable({required String message}) = UnavailableFailure;
  const factory AppFailure.unknown({required String message, Object? cause}) = UnknownFailure;
}
```

## UI Layer

### shipit_ui Integration
- All components from `package:shipit_ui/shipit_ui.dart`
- Theme via `AppTheme` wrapper
- Responsive via `AppLayout` and breakpoints
- No custom Material widgets for common controls

### Responsive Design
```dart
// BuildContext extensions
context.isMobile    // < 600px
context.isTablet    // 600px - 1200px
context.isDesktop   // > 1200px
```

### Navigation
- GoRouter for declarative routing
- Routes defined in `AppRouter`
- Authentication redirects in router redirect

## Dependency Injection
- Constructor injection for repositories/services
- BLoCs receive repositories via constructor
- `flutter_bloc` BlocProvider for widget tree

## Testing Strategy

### Unit Tests
- BLoC tests with `bloc_test`
- Repository tests with mocked ApiClient
- Pure domain logic tests

### Widget Tests
- Screen rendering with BLoC providers
- User interaction simulation
- State verification

### Golden Tests
- Key screens/components
- Approved baselines in `test/goldens/`
- `flutter test --update-goldens` requires design approval

### Accessibility Tests
- Semantics verification
- Contrast checking
- Keyboard navigation