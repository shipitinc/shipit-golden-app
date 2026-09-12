import 'package:serverpod/serverpod.dart';
import 'package:shipit_golden_server/src/generated/protocol.dart';

/// Shared household resolution helpers for endpoints that act on the
/// authenticated user's household (household management + program membership).
class HouseholdService {
  HouseholdService._();

  /// Finds the household owned by [ownerId], or `null` when none exists.
  ///
  /// The optional [transaction] is forwarded to the query so callers can run
  /// the find alongside their writes atomically (see [getOrCreateFor]).
  static Future<Household?> findByOwner(
    Session session,
    String ownerId, {
    Transaction? transaction,
  }) async {
    final households = await Household.db.find(
      session,
      where: (h) => h.ownerId.equals(ownerId),
      limit: 1,
      transaction: transaction,
    );
    return households.isEmpty ? null : households.first;
  }

  /// Returns the household owned by [ownerId], creating it (with the caller as
  /// owner-member) on first access, matching `HouseholdEndpoint.getCurrent`.
  ///
  /// Creation is race-safe: read-then-create runs inside a single database
  /// transaction, and the `ownerId` unique index
  /// ([HouseholdModel.householdsOwnerIndex]) plus `ignoreConflicts: true` make
  /// concurrent first-accesses for the same owner converge on one household —
  /// a conflicting insert is silently skipped and the winning row is re-read,
  /// so a duplicate household can never be created.
  static Future<Household> getOrCreateFor(
    Session session,
    String ownerId,
  ) async {
    return session.db.transaction<Household>((transaction) async {
      final existing = await findByOwner(
        session,
        ownerId,
        transaction: transaction,
      );
      if (existing != null) return existing;

      final created = await Household.db.insert(
        session,
        [
          Household(
            name: 'My Household',
            ownerId: ownerId,
            createdAt: DateTime.now(),
          ),
        ],
        transaction: transaction,
        ignoreConflicts: true,
      );
      if (created.isEmpty) {
        // A concurrent request created the household first; return the winner.
        return (await findByOwner(session, ownerId, transaction: transaction))!;
      }

      await HouseholdMember.db.insertRow(
        session,
        HouseholdMember(
          householdId: created.first.id!,
          name: 'Owner',
          email: '',
          role: HouseholdMemberRole.owner,
          joinedAt: DateTime.now(),
        ),
        transaction: transaction,
      );
      return created.first;
    });
  }
}
