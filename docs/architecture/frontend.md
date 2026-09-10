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
│   ├── config/
│   │   ├── app_flavor.dart             # AppFlavor enum (development/qa/production)
│   │   └── flavor_config.dart          # Compile-time per-flavor appName/serverUrl
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

### 0. Environment Flavoring

The app targets the standard three environments (`development`/`qa`/`production`)
and resolves the active one at compile time from the `FLAVOR` dart-define
(defaults to `development` when unset). `FlavorConfig.current` exposes the
resolved flavor; `FlavorConfig.appName` (`[Dev] ShipIt Golden App` / `[QA] ...` /
`ShipIt Golden App`) drives the `MaterialApp.title` (browser tab) and other
surfaces so a user can identify the environment at a glance. `FlavorConfig.serverUrl`
defaults per flavor and can be overridden with an `API_BASE_URL` dart-define.

Android product flavors and iOS schemes/build configs map one-to-one to these
flavors (see `flutter-toolchain.md` for the platform wiring). The native app ID
and display name come from the native project, not from Dart.

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
- Design tokens via the `AppThemeContext` extension (`context.color.*`,
  `context.space.*`, `context.text.*`, `context.breakpoint.*`, …) — no static
  token classes
- Responsive via `AppLayout` helpers (static utility class: `pageConstraints`,
  `centeredPage`, `responsivePageWidth`, `responsivePadding`, `hStack`,
  `vStack`)
- No custom Material widgets for common controls

### Responsive Design
```dart
// shipit_ui tokens: compact <360 / mobile 360 / tablet 600 / desktop 1024 /
//                   wide 1440 / pageWidth 1200
final type = context.layoutType;   // AppLayoutType.compact|mobile|tablet|desktop|wide

context.isMobileLayout    // width >= 360
context.isTabletLayout    // width >= 600
context.isDesktopLayout   // width >= 1024
context.isWideLayout      // width >= 1440
context.isDesktopOrLarger // width >= 1024
```

### Navigation
- GoRouter for declarative routing
- Routes defined in `AppRouter`
- Authentication redirects in router redirect

## Session Persistence (ServerpodClientProvider)

`ServerpodClientProvider` manages the shared Serverpod `api.Client` and
`FlutterAuthSessionManager`. Session storage is platform-dependent:

| Platform | Storage | Survives reload? |
|----------|---------|-------------------|
| Android / iOS / Desktop | `SecureClientAuthSuccessStorage` (OS keychain) | Yes |
| Web | `InMemoryAuthSuccessStorage` | **No** |

On web the browser's Secure Storage API is unavailable, so JWT access and
refresh tokens are held in memory only. A full page reload (or navigation that
destroys the Dart VM) silently discards the session — the user appears logged
out without an explicit logout event. This is a known limitation of the
Serverpod Flutter client on web; a persistent web storage adapter would need an
explicit design task per AEF to implement (e.g. `localStorage` or cookie-based
persistence with CSRF protections).

Repositories never access storage directly; they go through
`ServerpodClientProvider.shared` which owns the single client and session
manager. Tests replace `ServerpodClientProvider.shared` with an in-memory
provider so assertions do not touch the OS keychain.

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