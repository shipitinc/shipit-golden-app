import 'package:shipit_golden_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/test_server_config.dart';

/// Behavioral tests for household-scoped program membership: join, cancel and
/// membership lookup. Sessions are authenticated directly via
/// [AuthenticationOverride.authenticationInfo].
void main() {
  group('Programs endpoint membership (DB-backed)', () {
    withServerpod(
      'Given authenticated users and seeded programs',
      (sessionBuilder, endpoints) {
        late TestSessionBuilder authed;
        late TestSessionBuilder other;

        setUp(() {
          authed = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              'programs-member-1',
              const {},
            ),
          );
          other = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              'programs-member-2',
              const {},
            ),
          );
        });

        Future<List<Program>> seedPrograms() async {
          final session = authed.build();
          try {
            return Program.db.insert(session, [
              Program(
                name: 'Summer Camp 2026',
                description: 'Annual summer camp for families',
                startDate: DateTime(2026, 6, 15),
                endDate: DateTime(2026, 8, 15),
                status: 'active',
              ),
              Program(
                name: 'Winter Workshop 2026',
                description: 'Creative winter activities',
                startDate: DateTime(2026, 12, 1),
                endDate: DateTime(2026, 12, 20),
                status: 'upcoming',
              ),
            ]);
          } finally {
            await session.close();
          }
        }

        test(
          'then getById returns the program and null for unknown ids',
          () async {
            final programs = await seedPrograms();
            final programId = programs.first.id!;

            final found = await endpoints.programs.getById(authed, programId);
            expect(found?.name, 'Summer Camp 2026');

            final missing = await endpoints.programs.getById(authed, 999_999);
            expect(missing, isNull);
          },
        );

        test(
          'then getMembership is null before joining and present after',
          () async {
            final programId = (await seedPrograms()).first.id!;

            expect(
              await endpoints.programs.getMembership(authed, programId),
              isNull,
            );

            await endpoints.programs.joinProgram(authed, programId);
            final membership = await endpoints.programs.getMembership(
              authed,
              programId,
            );
            expect(membership, isNotNull);
            expect(membership!.programId, programId);
          },
        );

        test(
          'then joinProgram creates the household and membership once',
          () async {
            final programId = (await seedPrograms()).first.id!;

            final first = await endpoints.programs.joinProgram(
              authed,
              programId,
            );
            final second = await endpoints.programs.joinProgram(
              authed,
              programId,
            );

            expect(second.id, first.id);
            expect(second.householdId, first.householdId);
            expect(first.householdId, isNotEmpty);

            final session = authed.build();
            try {
              final memberships = await ProgramMember.db.find(
                session,
                where: (m) => m.programId.equals(programId),
              );
              expect(memberships, hasLength(1));
            } finally {
              await session.close();
            }
          },
        );

        test('then cancelMembership removes the membership', () async {
          final programId = (await seedPrograms()).first.id!;

          await endpoints.programs.joinProgram(authed, programId);
          await endpoints.programs.cancelMembership(authed, programId);

          expect(
            await endpoints.programs.getMembership(authed, programId),
            isNull,
          );

          // Cancel is a no-op when not joined.
          await endpoints.programs.cancelMembership(authed, programId);
        });

        test('then membership is isolated per household', () async {
          final programId = (await seedPrograms()).first.id!;

          await endpoints.programs.joinProgram(authed, programId);
          await endpoints.programs.joinProgram(other, programId);

          expect(
            (await endpoints.programs.getMembership(authed, programId))?.id,
            isNotNull,
          );
          expect(
            (await endpoints.programs.getMembership(other, programId))?.id,
            isNotNull,
          );

          await endpoints.programs.cancelMembership(authed, programId);
          expect(
            await endpoints.programs.getMembership(authed, programId),
            isNull,
          );
          expect(
            await endpoints.programs.getMembership(other, programId),
            isNotNull,
          );
        });

        test(
          'then joinProgram rejects an unknown program id with a 400',
          () async {
            expect(
              () => endpoints.programs.joinProgram(authed, 999_999),
              throwsA(isA<ProgramNotFoundException>()),
            );
          },
        );
      },
      configOverride: useEphemeralApiPort(),
    );
  });
}
