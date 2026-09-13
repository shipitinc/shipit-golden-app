import 'package:serverpod/serverpod.dart';
import 'package:shipit_golden_server/src/generated/protocol.dart';

import '../services/household_service.dart';

/// Programs endpoint backed by PostgreSQL.
///
/// Programs are global (not scoped to a household) while membership is
/// household-scoped: each household joins a program at most once, and the
/// authenticated user's household is auto-created on first join —
/// automatically at create time ([createProgram]) and on demand when joining
/// an existing program ([joinProgram]).
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

  /// Creates a program owned by the authenticated caller and auto-joins the
  /// caller's household to it in one atomic transaction.
  ///
  /// Validation (in order, each surfacing as a plain 400 via the Serverpod
  /// framework [InvalidParametersException]): [name] trimmed non-blank,
  /// [startDate] present, [endDate] present, and strictly
  /// `endDate.isAfter(startDate)`.
  ///
  /// [status] is derived ([deriveProgramStatus]) from the date range vs
  /// now; [createdBy] records the authenticated caller's
  /// `userIdentifier`. The program insert, the creator household resolution
  /// ([HouseholdService.getOrCreateFor]) and the creator's [ProgramMember]
  /// insert all run inside ONE caller-owned database transaction, so a failing
  /// membership step rolls the created program back with it.
  Future<Program> createProgram(
    Session session,
    String name,
    String description,
    DateTime startDate,
    DateTime endDate,
  ) async {
    validateProgramInputs(name: name, startDate: startDate, endDate: endDate);

    final createdBy = session.authenticated!.userIdentifier;
    final normalizedName = name.trim();

    return session.db.transaction<Program>((transaction) async {
      final program = await Program.db.insertRow(
        session,
        Program(
          name: normalizedName,
          description: description,
          createdBy: createdBy,
          startDate: startDate,
          endDate: endDate,
          status: deriveProgramStatus(startDate: startDate, endDate: endDate),
        ),
        transaction: transaction,
      );

      final household = await HouseholdService.getOrCreateFor(
        session,
        createdBy,
        transaction: transaction,
      );

      await ProgramMember.db.insertRow(
        session,
        ProgramMember(
          programId: program.id!,
          householdId: household.id!,
          joinedAt: DateTime.now(),
        ),
        transaction: transaction,
      );

      return program;
    });
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

/// Validates [createProgram] inputs, failing fast in order on the first
/// violation with a user-meaningful [InvalidParametersException] message.
///
/// Dates are nullable so the "missing date" rejections are expressible here;
/// through the typed endpoint connector a non-nullable [DateTime] parameter
/// can never arrive null (the Serverpod dispatcher already rejects a missing
/// parameter with its own [InvalidParametersException] before this is
/// reached).
void validateProgramInputs({
  required String name,
  required DateTime? startDate,
  required DateTime? endDate,
}) {
  if (name.trim().isEmpty) {
    throw InvalidParametersException('Program name is required.');
  }
  if (startDate == null) {
    throw InvalidParametersException('Select a start date.');
  }
  if (endDate == null) {
    throw InvalidParametersException('Select an end date.');
  }
  if (!endDate.isAfter(startDate)) {
    throw InvalidParametersException('End date must be after the start date.');
  }
}

/// Status auto-derivation for created programs (PD-2 / Design D-4): the status
/// is never a form field — it is derived at create time from the submitted
/// date range vs now at `Date` precision:
///
/// - `endDate < now` → [ProgramStatus.completed]
/// - `startDate > now` → [ProgramStatus.upcoming]
/// - otherwise (`startDate <= now <= endDate`) → [ProgramStatus.active]
ProgramStatus deriveProgramStatus({
  required DateTime startDate,
  required DateTime endDate,
}) {
  final now = DateTime.now();
  if (endDate.isBefore(now)) return ProgramStatus.completed;
  if (startDate.isAfter(now)) return ProgramStatus.upcoming;
  return ProgramStatus.active;
}
