import 'package:serverpod/serverpod.dart';
import 'package:shipit_golden_server/src/generated/protocol.dart';

import '../services/household_service.dart';

/// Programs endpoint backed by PostgreSQL.
///
/// Programs are global (not scoped to a household) while membership is
/// household-scoped: each household joins a program at most once, and the
/// authenticated user's household is auto-created on first join.
class ProgramsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns all programs.
  Future<List<Program>> getAll(Session session) async {
    return Program.db.find(session);
  }

  /// Returns a single program by [programId], or `null` when it does not
  /// exist.
  Future<Program?> getById(Session session, int programId) async {
    return Program.db.findById(session, programId);
  }

  /// Joins the authenticated user's household to [programId], auto-creating
  /// the household on first membership. Idempotent: joining again returns the
  /// existing membership.
  ///
  /// Rejects an unknown [programId] with a 400 ([ProgramNotFoundException]).
  Future<ProgramMember> joinProgram(Session session, int programId) async {
    await _requireProgram(session, programId);
    final household = await _getOrCreateHousehold(session);

    final existing = await _findMembership(session, household, programId);
    if (existing != null) return existing;

    return ProgramMember.db.insertRow(
      session,
      ProgramMember(
        programId: programId,
        householdId: household.id!,
        joinedAt: DateTime.now(),
      ),
    );
  }

  /// Returns the authenticated user's household membership for [programId],
  /// or `null` when the household does not exist or is not joined.
  Future<ProgramMember?> getMembership(Session session, int programId) async {
    final ownerId = session.authenticated!.userIdentifier;
    final household = await HouseholdService.findByOwner(session, ownerId);
    if (household == null) return null;
    return _findMembership(session, household, programId);
  }

  /// Removes the authenticated user's household membership from [programId].
  /// A no-op when the household is not joined.
  Future<void> cancelMembership(Session session, int programId) async {
    final household = await _getOrCreateHousehold(session);
    await ProgramMember.db.deleteWhere(
      session,
      where: (m) =>
          m.programId.equals(programId) & m.householdId.equals(household.id),
    );
  }

  Future<ProgramMember?> _findMembership(
    Session session,
    Household household,
    int programId,
  ) async {
    final memberships = await ProgramMember.db.find(
      session,
      where: (m) =>
          m.programId.equals(programId) & m.householdId.equals(household.id),
      limit: 1,
    );
    return memberships.isEmpty ? null : memberships.first;
  }

  /// Throws a 400 when no program with [programId] exists.
  Future<void> _requireProgram(Session session, int programId) async {
    final program = await Program.db.findById(session, programId);
    if (program == null) {
      throw ProgramNotFoundException();
    }
  }

  Future<Household> _getOrCreateHousehold(Session session) async {
    final ownerId = session.authenticated!.userIdentifier;
    return HouseholdService.getOrCreateFor(session, ownerId);
  }
}
