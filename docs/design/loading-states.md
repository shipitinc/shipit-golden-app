# Loading & Mutation States (Agent Guidance)

How and when to show loading feedback in shipit-style Flutter apps, using the
Golden App as the canonical reference.

## When to show a progress indication

A network-backed state change has three telltale phases an agent must model,
in order:

| Phase                    | What the user should see                     | Reference implementation                              |
|--------------------------|----------------------------------------------|-------------------------------------------------------|
| Initial content load     | `AppSkeleton` shimmer of the final layout    | `household_screen.dart` loading branch (`AppSkeleton.card`) |
| In-flight mutation (add/remove/save) | `AppSkeleton` shimmer on the affected surface | `member_list.dart` `_MembersTableShimmer` (`isMutating`) |
| Initial-load failure     | Failure branch with `AppInlineAlert.error` + Retry | `household_screen.dart` failure branch          |
| Settled mutation failure | `AppInlineAlert.error` (dismissible) inline, content stays loaded | `household_screen.dart` / `program_details_screen.dart` loaded branch (`mutationError`) |

## Rules

1. **Never blank out loaded content mid-operation.** If the user can already
   see a table/list/card, keep it rendered and shimmer the rows while the
   mutation is awaited. Blanking to a spinner or an empty surface looks broken
   and loses context.
2. **Never use a spinner when a skeleton is possible.** Skeletons are the
   default for loading and mutating content areas. Spinners are reserved for
   compact, non-content interactions (e.g. a button's busy state,
   `AppButtonState.loading`).
3. **The mutation must be a distinct state.** A BLoC feature that mutates data
   must emit an explicit in-flight state (e.g. `HouseholdState.loaded(
   isMembersMutating: true)`) before awaiting the repository call, then emit
   the settled state. The widget layer decides between shimmering the mutation
   or the settled content from a single `BlocBuilder` pass — no ambient state.
   On failure the mutation settles **back onto the loaded state** carrying the
   error (`loaded(mutationError: failure)`), never into a full failure state
   that would blank the content the user already sees.
4. **Show the empty state, not a shimmer, when there is nothing to load.**
   `AppEmptyState` after a successful load with zero rows; shimmer only while
   awaiting.
5. **Skeleton shape mirrors final layout.** Use `AppSkeleton.line` /
   `AppSkeleton.circle` / `AppSkeleton.block` composed under a single
   `AppSkeleton.shimmer` so all placeholders animate together and match the
   content that will appear.
6. **No shimmer for errors.** A failed **initial load** resolves to
   `AppInlineAlert.error` (with a Retry action) on the failure branch — never
   an eternally-pulsing skeleton. Keep a static skeleton underneath as the
   awaiting layout only when a retry will re-enter loading. A failed
   **mutation** resolves to `AppInlineAlert.error` rendered inline on the
   kept-loaded state (dismissible, no Retry that would re-run the mutation it
   did not re-queue).

## Pattern to copy

The members table in `member_list.dart` is the canonical mutation-shimmer:

```dart
// BLoC: explicit in-flight state so the UI never blanks mid-mutation.
if (state is HouseholdLoaded) {
  emit(state.copyWith(isMembersMutating: true)); // or a matching loaded state
  final result = await repository.removeMember(event.memberId);
  // ... emit settled loaded state
}

// Widget: shimmer the table while mutating, keep the "Members (N)" header.
if (isMutating)
  AppSkeleton.shimmer(child: /* row-shaped skeleton lines */)
else
  AppDataTable(...);
```

Mutation failure stays inline: emit the error on the loaded state and render a
dismissible alert above the content, reserving the full failure branch for
initial loads.

```dart
// BLoC: settle the failed mutation back onto loaded, carrying the error.
failure: (failure) => emit(
  HouseholdState.loaded(
    household: state.household,
    members: state.members,
    mutationError: failure,
  ),
),
// Widget: alert above the still-loaded content; dismiss clears the error.
if (mutationError != null)
  AppInlineAlert.error(
    title: 'Error',
    message: mutationError.userMessage,
    onDismiss: () => context.read<Bloc>().add(const ...MutationErrorDismissed()),
  ),
```

## Reference files

- `apps/app/lib/features/household/bloc/household_bloc.dart`
- `apps/app/lib/features/household/presentation/widgets/member_list.dart`
- `apps/app/lib/features/household/presentation/screens/household_screen.dart`
- `apps/app/lib/features/programs/bloc/program_details_bloc.dart`
- `apps/app/lib/features/programs/presentation/screens/program_details_screen.dart`