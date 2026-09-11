import 'package:shipit_golden_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/test_server_config.dart';

/// Behavioral tests for the PostgreSQL-backed household and programs endpoints
/// (previously in-memory stubs). Sessions are authenticated directly via
/// [AuthenticationOverride.authenticationInfo], bypassing the email IDP so the
/// default per-test database rollback applies.
void main() {
  group('Household endpoint (DB-backed)', () {
    withServerpod(
      'Given an authenticated user without a household',
      (sessionBuilder, endpoints) {
        late AuthenticationOverride authenticated;
        late TestSessionBuilder authed;

        setUp(() {
          authenticated = AuthenticationOverride.authenticationInfo(
            'household-owner-1',
            const {},
          );
          authed = sessionBuilder.copyWith(authentication: authenticated);
        });

        test('then getCurrent auto-creates a household for the user', () async {
          final household = await endpoints.household.getCurrent(authed);

          expect(household.ownerId, 'household-owner-1');
          expect(household.name, 'My Household');
          expect(household.id, isNotNull);
        });

        test('then getCurrent is stable across calls', () async {
          final first = await endpoints.household.getCurrent(authed);
          final second = await endpoints.household.getCurrent(authed);

          expect(second.id, first.id);
          expect(second.ownerId, first.ownerId);
        });

        test(
          'then a fresh household starts with the owner as member',
          () async {
            final household = await endpoints.household.getCurrent(authed);
            final members = await endpoints.household.getMembers(authed);

            expect(members, hasLength(1));
            final owner = members.first;
            expect(owner.name, 'Owner');
            expect(owner.role, HouseholdMemberRole.owner);
            expect(owner.householdId, household.id.toString());
          },
        );

        test('then addMember persists and getMembers returns it', () async {
          await endpoints.household.getCurrent(authed);
          final added = await endpoints.household.addMember(
            authed,
            'Jane Smith',
            'jane@example.com',
          );

          expect(added.role, HouseholdMemberRole.member);
          expect(added.id, isNotNull);

          final members = await endpoints.household.getMembers(authed);
          expect(members.map((m) => m.email), contains('jane@example.com'));
        });

        test('then removeMember removes an added member', () async {
          await endpoints.household.getCurrent(authed);
          final added = await endpoints.household.addMember(
            authed,
            'To Remove',
            'remove@example.com',
          );

          await endpoints.household.removeMember(authed, added.id.toString());

          final members = await endpoints.household.getMembers(authed);
          expect(
            members.map((m) => m.email),
            isNot(contains('remove@example.com')),
          );
        });

        test(
          'then removeMember rejects a non-numeric member id with a 400',
          () async {
            await endpoints.household.getCurrent(authed);

            expect(
              () => endpoints.household.removeMember(authed, 'not-a-number'),
              throwsA(isA<InvalidMemberIdException>()),
            );
          },
        );
      },
      configOverride: useEphemeralApiPort(),
    );
  });

  group('Programs endpoint (DB-backed)', () {
    withServerpod(
      'Given programs exist in the database',
      (sessionBuilder, endpoints) {
        late TestSessionBuilder authed;

        setUp(() {
          authed = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              'programs-user-1',
              const {},
            ),
          );
        });

        test('then getAll returns every program', () async {
          final session = authed.build();
          try {
            await Program.db.insert(session, [
              Program(
                name: 'Summer Camp 2024',
                description: 'Annual summer camp for families',
                startDate: DateTime(2024, 6, 15),
                endDate: DateTime(2024, 8, 15),
                status: ProgramStatus.active,
              ),
              Program(
                name: 'Winter Workshop',
                description: 'Creative winter activities',
                startDate: DateTime(2024, 12, 1),
                endDate: DateTime(2024, 12, 20),
                status: ProgramStatus.upcoming,
              ),
            ]);

            final programs = await endpoints.programs.getAll(authed);
            expect(
              programs.map((p) => p.name),
              containsAll(['Summer Camp 2024', 'Winter Workshop']),
            );
          } finally {
            await session.close();
          }
        });
      },
      configOverride: useEphemeralApiPort(),
    );
  });
}
