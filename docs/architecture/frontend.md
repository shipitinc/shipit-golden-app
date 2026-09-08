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
│   │   ├── app_failure.dart          # Standardized failure types
│   │   └── error_translator.dart     # Maps exceptions to user-safe failures
│   ├── networking/
│   │   └── serverpod_client_provider.dart  # Shared Serverpod client/session
│   └── shared/
│       └── extensions.dart   # Immutability helpers
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
    Repository calls Serverpod generated client (via ServerpodClientProvider)
        ↓
    Serverpod client calls Serverpod
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
  const factory AppFailure.auth({required String message, String? code}) = AuthFailure;
  const factory AppFailure.authorization({required String message, String? code}) = AuthorizationFailure;
  const factory AppFailure.validation({required String message, Map<String, String>? fields}) = ValidationFailure;
  const factory AppFailure.server({required String message, int? statusCode}) = ServerFailure;
  const factory AppFailure.unavailable({required String message}) = UnavailableFailure;
  const factory AppFailure.unknown({required String message, Object? cause}) = UnknownFailure;
}
```

Repositories catch exceptions and route them through `mapAppFailure` (in
`core/errors/error_translator.dart`) so users only ever see safe, human-readable
messages — never `Exception.toString()` or stack traces. `userMessage` on
`AppFailure` adds a stable prefix per failure type for dialogs/state views.

## UI Layer

### shipit_ui Integration
- All components from `package:shipit_ui/shipit_ui.dart`
- Theme via `shipitLightTheme()` / `shipitDarkTheme()` from shipit_ui
- Responsive via `AppBreakpoints` and `AppLayout` helpers (static utility class:
  `pageConstraints`, `centeredPage`, `responsivePageWidth`, `hStack`, `vStack`)
- No custom Material widgets for common controls

### Responsive Design
```dart
// shipit_ui tokens: mobile 360 / tablet 600 / desktop 1024 / wide 1440
final type = AppLayoutType? ...;  // see AppBreakpoints.getLayoutType / AppLayoutType

AppBreakpoints.isMobile(context)   // width >= 360
AppBreakpoints.isTablet(context)   // width >= 600
AppBreakpoints.isDesktop(context)  // width >= 1024
AppBreakpoints.isWide(context)     // width >= 1440

// Or the BuildContext extension:
context.isMobileLayout / context.isTabletLayout / context.isDesktopLayout
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
- Repository tests with mocked `ServerpodClientProvider`
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