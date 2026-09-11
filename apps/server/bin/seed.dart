import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:shipit_golden_server/src/generated/endpoints.dart';
import 'package:shipit_golden_server/src/generated/protocol.dart';

/// Seeds the database with reference data for the golden app.
///
/// Idempotent — everything is guarded by an existence check, so it is safe to
/// run on every boot/deploy. Serverpod 3.4.13 has no built-in seed command; the
/// canonical pattern (see serverpod/serverpod discussion #5403) is a one-off
/// maintenance-style entry point.
///
/// Run with:
/// ```bash
/// melos run seed
/// # or, from apps/server:
/// serverpod run seed
/// ```
Future<void> main(List<String> args) async {
  final pod = Serverpod(args, Protocol(), Endpoints());
  await pod.start();

  final session = await pod.createSession();
  try {
    await seedHousehold(session);
    await seedPrograms(session);
  } finally {
    await session.close();
  }

  stdout.writeln('Seeding complete.');
  await pod.shutdown();
}

/// Fixed owner identifier for the seeded reference household. Real users get a
/// UUID from the auth system; this only identifies the seed data.
const seedOwnerId = '00000000-0000-0000-0000-000000000001';

/// Inserts the reference household + members if none exists for [seedOwnerId].
Future<void> seedHousehold(Session session) async {
  final existing = await Household.db.findFirstRow(
    session,
    where: (h) => h.ownerId.equals(seedOwnerId),
  );
  if (existing != null) return;

  final household = await Household.db.insertRow(
    session,
    Household(
      name: 'Demo Household',
      ownerId: seedOwnerId,
      createdAt: DateTime.now(),
    ),
  );

  await HouseholdMember.db.insert(session, [
    HouseholdMember(
      householdId: household.id.toString(),
      name: 'John Doe',
      email: 'john@example.com',
      role: HouseholdMemberRole.owner,
      joinedAt: DateTime.now(),
    ),
    HouseholdMember(
      householdId: household.id.toString(),
      name: 'Jane Smith',
      email: 'jane@example.com',
      role: HouseholdMemberRole.member,
      joinedAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ]);
}

/// Inserts reference programs if the programs table is empty.
Future<void> seedPrograms(Session session) async {
  final existing = await Program.db.count(session);
  if (existing > 0) return;

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
}
