import 'package:serverpod/serverpod.dart' show InvalidParametersException;
import 'package:shipit_golden_server/src/endpoints/programs_endpoint.dart';
import 'package:shipit_golden_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/test_server_config.dart';

void main() {
  group('Programs endpoint (DB-backed) — createProgram', () {
    withServerpod(
      'Given an authenticated user without a household',
      (sessionBuilder, endpoints) {
        late TestSessionBuilder authed;

        setUp(() {
          authed = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              'create-program-owner',
              const {},
            ),
          );
        });

        test('then createProgram persists the program and auto-joins the '
            "creator's household", () async {
          final start = DateTime(2026, 6, 15);
          final end = DateTime(2026, 8, 15);
          final created = await endpoints.programs.createProgram(
            authed,
            '  Summer Camp 2026  ',
            'Annual summer camp for families',
            start,
            end,
          );

          expect(created.id, isNotNull);
          expect(created.name, 'Summer Camp 2026');
          expect(created.description, 'Annual summer camp for families');
          expect(created.createdBy, 'create-program-owner');
          expect(created.startDate.year, 2026);
          expect(created.startDate.month, 6);
          expect(created.startDate.day, 15);
          expect(created.endDate.year, 2026);
          expect(created.endDate.month, 8);
          expect(created.endDate.day, 15);

          final session = authed.build();
          try {
            final stored = await Program.db.findById(session, created.id!);
            expect(stored?.name, 'Summer Camp 2026');
            expect(stored?.createdBy, 'create-program-owner');
            expect(stored?.id, created.id);

            final households = await Household.db.find(
              session,
              where: (h) => h.ownerId.equals('create-program-owner'),
            );
            expect(households, hasLength(1));
            final household = households.single;

            final memberships = await ProgramMember.db.find(
              session,
              where: (m) => m.programId.equals(created.id!),
            );
            expect(memberships, hasLength(1));
            expect(memberships.single.householdId, household.id);
            expect(memberships.single.programId, created.id);
          } finally {
            await session.close();
          }
        });

        test(
          'then participating in a second program keeps one household',
          () async {
            final first = await endpoints.programs.createProgram(
              authed,
              'First Program',
              '',
              DateTime(2026, 6, 15),
              DateTime(2026, 8, 15),
            );
            final second = await endpoints.programs.createProgram(
              authed,
              'Second Program',
              '',
              DateTime(2026, 10, 1),
              DateTime(2026, 11, 30),
            );

            final session = authed.build();
            try {
              final households = await Household.db.find(
                session,
                where: (h) => h.ownerId.equals('create-program-owner'),
              );
              expect(households, hasLength(1));

              final memberships = await ProgramMember.db.find(
                session,
                where: (m) => m.householdId.equals(households.single.id!),
              );
              expect(memberships.map((m) => m.programId).toSet(), {
                first.id,
                second.id,
              });
            } finally {
              await session.close();
            }
          },
        );

        test('then status is derived from the date range vs now', () async {
          final completed = await endpoints.programs.createProgram(
            authed,
            'Past Program',
            '',
            DateTime(2000, 1, 1),
            DateTime(2001, 1, 1),
          );
          expect(completed.status, ProgramStatus.completed);

          final upcoming = await endpoints.programs.createProgram(
            authed,
            'Future Program',
            '',
            DateTime(2030, 1, 1),
            DateTime(2030, 12, 31),
          );
          expect(upcoming.status, ProgramStatus.upcoming);

          final active = await endpoints.programs.createProgram(
            authed,
            'Active Program',
            '',
            DateTime.now().subtract(const Duration(days: 1)),
            DateTime.now().add(const Duration(days: 1)),
          );
          expect(active.status, ProgramStatus.active);
        });

        test('then blank names and non-strict date ranges are rejected with a '
            'plain 400', () async {
          // The serverpod_test harness collapses InvalidParametersException
          // into a StateError, so the endpoint method is invoked directly to
          // assert the framework 400 type and message.
          final session = authed.build();
          final endpoint = ProgramsEndpoint();

          expect(
            () => endpoint.createProgram(
              session,
              '   ',
              'description',
              DateTime(2026, 6, 1),
              DateTime(2026, 8, 1),
            ),
            throwsA(
              isA<InvalidParametersException>().having(
                (e) => e.message,
                'message',
                'Program name is required.',
              ),
            ),
          );

          expect(
            () => endpoint.createProgram(
              session,
              'Name',
              'description',
              DateTime(2026, 8, 1),
              DateTime(2026, 8, 1),
            ),
            throwsA(
              isA<InvalidParametersException>().having(
                (e) => e.message,
                'message',
                'End date must be after the start date.',
              ),
            ),
          );

          expect(
            () => endpoint.createProgram(
              session,
              'Name',
              'description',
              DateTime(2026, 8, 1),
              DateTime(2026, 6, 1),
            ),
            throwsA(
              isA<InvalidParametersException>().having(
                (e) => e.message,
                'message',
                'End date must be after the start date.',
              ),
            ),
          );
        });

        test('then missing dates are rejected with a plain 400', () async {
          expect(
            () => validateProgramInputs(
              name: 'Valid',
              startDate: null,
              endDate: DateTime(2026, 8, 1),
            ),
            throwsA(
              isA<InvalidParametersException>().having(
                (e) => e.message,
                'message',
                'Select a start date.',
              ),
            ),
          );

          expect(
            () => validateProgramInputs(
              name: 'Valid',
              startDate: DateTime(2026, 6, 1),
              endDate: null,
            ),
            throwsA(
              isA<InvalidParametersException>().having(
                (e) => e.message,
                'message',
                'Select an end date.',
              ),
            ),
          );
        });

        test('then unauthenticated calls are rejected', () async {
          expect(
            () => endpoints.programs.createProgram(
              sessionBuilder,
              'Name',
              'description',
              DateTime(2026, 6, 1),
              DateTime(2026, 8, 1),
            ),
            throwsA(isA<ServerpodUnauthenticatedException>()),
          );
        });
      },
      configOverride: useEphemeralApiPort(),
    );
  });

  group(
    'Programs endpoint (DB-backed) — concurrent createProgram for one owner',
    () {
      withServerpod(
        'Given five simultaneous create calls share a first-time owner',
        (sessionBuilder, endpoints) {
          late TestSessionBuilder authed;
          late String ownerId;

          setUp(() {
            ownerId =
                'concurrent-owner-${DateTime.now().millisecondsSinceEpoch}';
            authed = sessionBuilder.copyWith(
              authentication: AuthenticationOverride.authenticationInfo(
                ownerId,
                const {},
              ),
            );
          });

          test('then exactly five programs, one household and five memberships '
              'are persisted', () async {
            const concurrentCreates = 5;

            final created = await Future.wait([
              for (var i = 0; i < concurrentCreates; i++)
                endpoints.programs.createProgram(
                  authed,
                  'Concurrent Program $i',
                  'created concurrently',
                  DateTime(2026, 6, 15),
                  DateTime(2026, 8, 15),
                ),
            ]);

            final createdIds = created.map((p) => p.id!).toSet();
            expect(createdIds, hasLength(concurrentCreates));
            for (final program in created) {
              expect(program.createdBy, ownerId);
            }

            final session = authed.build();
            try {
              final programs = await Program.db.find(
                session,
                where: (p) => p.id.inSet(createdIds),
              );
              expect(programs, hasLength(concurrentCreates));

              final households = await Household.db.find(
                session,
                where: (h) => h.ownerId.equals(ownerId),
              );
              expect(households, hasLength(1));
              final householdId = households.single.id!;

              final memberships = await ProgramMember.db.find(
                session,
                where: (m) => m.programId.inSet(createdIds),
              );
              expect(memberships, hasLength(concurrentCreates));
              expect(memberships.map((m) => m.householdId).toSet(), {
                householdId,
              });
              for (final program in created) {
                expect(
                  memberships.where((m) => m.programId == program.id),
                  hasLength(1),
                );
              }
            } finally {
              await session.close();
            }
          });
        },
        rollbackDatabase: RollbackDatabase.disabled,
        configOverride: useEphemeralApiPort(),
      );
    },
  );
}
