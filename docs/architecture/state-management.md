# State Management Architecture

## BLoC + Freezed Pattern

The Golden App uses **BLoC (Business Logic Component)** with **Freezed** for immutable state management.

## Principles

1. **Feature-scoped BLoCs** — One BLoC per feature domain
2. **Immutable events & states** — Freezed sealed classes
3. **Unidirectional data flow** — Events in, States out
4. **No mutable state** — All state transitions create new instances
5. **Business logic in BLoCs** — Not in widgets

## BLoC Responsibilities

| BLoC | Responsibility |
|------|----------------|
| AuthenticationBloc | Auth state, login, logout, token refresh |
| HouseholdBloc | Current household, members, CRUD operations |
| ProgramsBloc | Program listing, filtering |

## Event Naming Convention

```dart
// Good: Descriptive, intent-revealing
AuthenticationLoginRequested
HouseholdRefreshRequested
HouseholdMemberAdded
ProgramsRefreshRequested

// Avoid: Vague, implementation-focused
Login
Refresh
DoSave
Update
```

## State Naming Convention

```dart
@freezed
sealed class FeatureState with _$FeatureState {
  const factory FeatureState.initial() = FeatureInitial;
  const factory FeatureState.loading() = FeatureLoading;
  const factory FeatureState.loaded({required Data data}) = FeatureLoaded;
  const factory FeatureState.failure({required AppFailure failure}) = FeatureFailure;
}
```

## State Transitions

```
initial → loading → loaded
              ↘ failure

loaded → loading → loaded (refresh)
loaded → failure (error during operation)
```

## Repository Pattern

```dart
abstract class FeatureRepository {
  Future<Result<Data>> getData();
  Future<Result<Data>> createData(CreateDataInput input);
  Future<Result<void>> deleteData(String id);
}

// Implementation
class FeatureRepositoryImpl implements FeatureRepository {
  final ServerpodClientProvider _clientProvider;

  Future<Result<Data>> getData() async {
    return _runCatching(() async {
      // Call the Serverpod generated client endpoint, then map protocol → domain.
      ...
    });
  }
}
```

Repositories never expose raw exceptions to the UI: fetch/call errors are routed
through `mapAppFailure` (`core/errors/error_translator.dart`) into a typed
`AppFailure`, and widgets render `failure.userMessage`. Exception `toString()`
and stack traces are never shown to users.

## BLoC Testing

```dart
blocTest<FeatureBloc, FeatureState>(
  'emits [loading, loaded] when refresh succeeds',
  build: () => FeatureBloc(repository: mockRepository),
  act: (bloc) => bloc.add(const FeatureRefreshRequested()),
  expect: () => [
    isA<FeatureLoading>(),
    isA<FeatureLoaded>(),
  ],
);
```

## Dependency Injection

```dart
// In app.dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => AuthenticationBloc()),
    BlocProvider(create: (_) => HouseholdBloc()),
    BlocProvider(create: (_) => ProgramsBloc()),
  ],
  child: AppView(),
)
```

## What Does NOT Need BLoC

- Transient UI state (hover, focus, animation)
- Simple form field state
- Ephemeral presentation state
- Use `StatefulWidget` or `StateProvider` for these

## Anti-Patterns to Avoid

1. **Global ApplicationBloc** — Don't put unrelated state together
2. **Mutable state** — Never modify state after emission
3. **Business logic in widgets** — Widgets only render and dispatch
4. **Exposing repositories to UI** — UI talks to BLoC only
5. **Events as commands** — Events represent occurrences, not commands