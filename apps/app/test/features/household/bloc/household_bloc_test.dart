import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/household/bloc/household_bloc.dart';
import 'package:shipit_golden_app/features/household/bloc/household_event.dart';
import 'package:shipit_golden_app/features/household/bloc/household_state.dart';
import 'package:shipit_golden_app/features/household/data/household_repository.dart';
import 'package:shipit_golden_app/features/household/domain/household.dart';
import 'package:shipit_golden_app/features/household/domain/household_member.dart';

class MockHouseholdRepository extends Mock implements HouseholdRepository {}

void main() {
  late MockHouseholdRepository repository;
  late HouseholdBloc bloc;

  setUp(() {
    repository = MockHouseholdRepository();
    bloc = HouseholdBloc(repository: repository);
  });

  tearDown(() => bloc.close());

  group('HouseholdBloc', () {
    test('initial state is initial', () {
      expect(bloc.state, const HouseholdState.initial());
    });

    blocTest<HouseholdBloc, HouseholdState>(
      'emits loading then loaded when the household loads successfully',
      build: () {
        when(() => repository.getHousehold()).thenAnswer(
          (_) async => Result.success(
            Household(
              id: '1',
              name: 'My Household',
              ownerId: 'u1',
              createdAt: DateTime(2026, 1, 1),
            ),
          ),
        );
        when(() => repository.getMembers()).thenAnswer(
          (_) async => Result.success([
            HouseholdMember(
              id: 'm1',
              householdId: '1',
              name: 'Jane',
              email: 'jane@example.com',
              role: 'member',
              joinedAt: DateTime(2026, 1, 2),
            ),
          ]),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const HouseholdEvent.started()),
      expect: () => [
        const HouseholdState.loading(),
        HouseholdState.loaded(
          household: Household(
            id: '1',
            name: 'My Household',
            ownerId: 'u1',
            createdAt: DateTime(2026, 1, 1),
          ),
          members: [
            HouseholdMember(
              id: 'm1',
              householdId: '1',
              name: 'Jane',
              email: 'jane@example.com',
              role: 'member',
              joinedAt: DateTime(2026, 1, 2),
            ),
          ],
        ),
      ],
    );

    blocTest<HouseholdBloc, HouseholdState>(
      'emits failure when the household fetch fails',
      build: () {
        when(() => repository.getHousehold()).thenAnswer(
          (_) async => Result.failure(AppFailure.unknown(message: 'boom')),
        );
        when(
          () => repository.getMembers(),
        ).thenAnswer((_) async => Result.success(<HouseholdMember>[]));
        return bloc;
      },
      act: (bloc) => bloc.add(const HouseholdEvent.started()),
      expect: () => [
        const HouseholdState.loading(),
        HouseholdState.failure(failure: AppFailure.unknown(message: 'boom')),
      ],
    );

    blocTest<HouseholdBloc, HouseholdState>(
      'appends the added member to the loaded list',
      build: () {
        when(() => repository.addMember('Bob', 'bob@example.com')).thenAnswer(
          (_) async => Result.success(
            HouseholdMember(
              id: 'm2',
              householdId: '1',
              name: 'Bob',
              email: 'bob@example.com',
              role: 'member',
              joinedAt: DateTime(2026, 1, 3),
            ),
          ),
        );
        return bloc;
      },
      seed: () => HouseholdState.loaded(
        household: Household(
          id: '1',
          name: 'My Household',
          ownerId: 'u1',
          createdAt: DateTime(2026, 1, 1),
        ),
        members: [],
      ),
      act: (bloc) => bloc.add(
        const HouseholdEvent.memberAdded(name: 'Bob', email: 'bob@example.com'),
      ),
      expect: () => [
        HouseholdState.loaded(
          household: Household(
            id: '1',
            name: 'My Household',
            ownerId: 'u1',
            createdAt: DateTime(2026, 1, 1),
          ),
          members: <HouseholdMember>[],
          isMembersMutating: true,
        ),
        HouseholdState.loaded(
          household: Household(
            id: '1',
            name: 'My Household',
            ownerId: 'u1',
            createdAt: DateTime(2026, 1, 1),
          ),
          members: [
            HouseholdMember(
              id: 'm2',
              householdId: '1',
              name: 'Bob',
              email: 'bob@example.com',
              role: 'member',
              joinedAt: DateTime(2026, 1, 3),
            ),
          ],
        ),
      ],
    );

    blocTest<HouseholdBloc, HouseholdState>(
      'removes the member from the loaded list',
      build: () {
        when(
          () => repository.removeMember('m1'),
        ).thenAnswer((_) async => const Result.success(null));
        return bloc;
      },
      seed: () => HouseholdState.loaded(
        household: Household(
          id: '1',
          name: 'My Household',
          ownerId: 'u1',
          createdAt: DateTime(2026, 1, 1),
        ),
        members: [
          HouseholdMember(
            id: 'm1',
            householdId: '1',
            name: 'Jane',
            email: 'jane@example.com',
            role: 'member',
            joinedAt: DateTime(2026, 1, 2),
          ),
        ],
      ),
      act: (bloc) =>
          bloc.add(const HouseholdEvent.memberRemoved(memberId: 'm1')),
      expect: () => [
        HouseholdState.loaded(
          household: Household(
            id: '1',
            name: 'My Household',
            ownerId: 'u1',
            createdAt: DateTime(2026, 1, 1),
          ),
          members: [
            HouseholdMember(
              id: 'm1',
              householdId: '1',
              name: 'Jane',
              email: 'jane@example.com',
              role: 'member',
              joinedAt: DateTime(2026, 1, 2),
            ),
          ],
          isMembersMutating: true,
        ),
        HouseholdState.loaded(
          household: Household(
            id: '1',
            name: 'My Household',
            ownerId: 'u1',
            createdAt: DateTime(2026, 1, 1),
          ),
          members: [],
        ),
      ],
    );

    blocTest<HouseholdBloc, HouseholdState>(
      'add-member failure stays loaded and surfaces an inline mutation error',
      build: () {
        when(() => repository.addMember('Bob', 'bob@example.com')).thenAnswer(
          (_) async => Result.failure(AppFailure.network(message: 'offline')),
        );
        return bloc;
      },
      seed: () => HouseholdState.loaded(
        household: Household(
          id: '1',
          name: 'My Household',
          ownerId: 'u1',
          createdAt: DateTime(2026, 1, 1),
        ),
        members: [],
      ),
      act: (bloc) => bloc.add(
        const HouseholdEvent.memberAdded(name: 'Bob', email: 'bob@example.com'),
      ),
      expect: () => [
        HouseholdState.loaded(
          household: Household(
            id: '1',
            name: 'My Household',
            ownerId: 'u1',
            createdAt: DateTime(2026, 1, 1),
          ),
          members: <HouseholdMember>[],
          isMembersMutating: true,
        ),
        HouseholdState.loaded(
          household: Household(
            id: '1',
            name: 'My Household',
            ownerId: 'u1',
            createdAt: DateTime(2026, 1, 1),
          ),
          members: <HouseholdMember>[],
          mutationError: AppFailure.network(message: 'offline'),
        ),
      ],
    );

    blocTest<HouseholdBloc, HouseholdState>(
      'remove-member failure stays loaded and surfaces an inline mutation error',
      build: () {
        when(() => repository.removeMember('m1')).thenAnswer(
          (_) async => Result.failure(AppFailure.network(message: 'offline')),
        );
        return bloc;
      },
      seed: () => HouseholdState.loaded(
        household: Household(
          id: '1',
          name: 'My Household',
          ownerId: 'u1',
          createdAt: DateTime(2026, 1, 1),
        ),
        members: [
          HouseholdMember(
            id: 'm1',
            householdId: '1',
            name: 'Jane',
            email: 'jane@example.com',
            role: 'member',
            joinedAt: DateTime(2026, 1, 2),
          ),
        ],
      ),
      act: (bloc) =>
          bloc.add(const HouseholdEvent.memberRemoved(memberId: 'm1')),
      expect: () => [
        HouseholdState.loaded(
          household: Household(
            id: '1',
            name: 'My Household',
            ownerId: 'u1',
            createdAt: DateTime(2026, 1, 1),
          ),
          members: [
            HouseholdMember(
              id: 'm1',
              householdId: '1',
              name: 'Jane',
              email: 'jane@example.com',
              role: 'member',
              joinedAt: DateTime(2026, 1, 2),
            ),
          ],
          isMembersMutating: true,
        ),
        HouseholdState.loaded(
          household: Household(
            id: '1',
            name: 'My Household',
            ownerId: 'u1',
            createdAt: DateTime(2026, 1, 1),
          ),
          members: [
            HouseholdMember(
              id: 'm1',
              householdId: '1',
              name: 'Jane',
              email: 'jane@example.com',
              role: 'member',
              joinedAt: DateTime(2026, 1, 2),
            ),
          ],
          mutationError: AppFailure.network(message: 'offline'),
        ),
      ],
    );

    blocTest<HouseholdBloc, HouseholdState>(
      'dismissing the mutation error clears it and keeps the loaded state',
      build: () {
        when(() => repository.addMember('Bob', 'bob@example.com')).thenAnswer(
          (_) async => Result.failure(AppFailure.network(message: 'offline')),
        );
        return bloc;
      },
      seed: () => HouseholdState.loaded(
        household: Household(
          id: '1',
          name: 'My Household',
          ownerId: 'u1',
          createdAt: DateTime(2026, 1, 1),
        ),
        members: [],
      ),
      act: (bloc) async {
        bloc.add(
          const HouseholdEvent.memberAdded(
            name: 'Bob',
            email: 'bob@example.com',
          ),
        );
        await bloc.stream.firstWhere(
          (s) => s is HouseholdLoaded && s.mutationError != null,
        );
        bloc.add(const HouseholdEvent.mutationErrorDismissed());
      },
      expect: () => [
        HouseholdState.loaded(
          household: Household(
            id: '1',
            name: 'My Household',
            ownerId: 'u1',
            createdAt: DateTime(2026, 1, 1),
          ),
          members: <HouseholdMember>[],
          isMembersMutating: true,
        ),
        HouseholdState.loaded(
          household: Household(
            id: '1',
            name: 'My Household',
            ownerId: 'u1',
            createdAt: DateTime(2026, 1, 1),
          ),
          members: <HouseholdMember>[],
          mutationError: AppFailure.network(message: 'offline'),
        ),
        HouseholdState.loaded(
          household: Household(
            id: '1',
            name: 'My Household',
            ownerId: 'u1',
            createdAt: DateTime(2026, 1, 1),
          ),
          members: <HouseholdMember>[],
        ),
      ],
    );
  });
}
