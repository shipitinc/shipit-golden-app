import 'package:serverpod/serverpod.dart';
import 'package:shipit_golden_server/src/generated/protocol.dart';

/// Shared household resolution helpers for endpoints that act on the
/// authenticated user's household (household management + program membership).
class HouseholdService {
  HouseholdService._();

  /// Finds the household owned by [ownerId], or `null` when none exists.
  static Future<Household?> findByOwner(Session session, String ownerId) async {
    final households = await Household.db.find(
      session,
      where: (h) => h.ownerId.equals(ownerId),
      limit: 1,
    );
    return households.isEmpty ? null : households.first;
  }

  /// Returns the household owned by [ownerId], creating it (with the caller as
  /// owner-member) on first access, matching `HouseholdEndpoint.getCurrent`.
  static Future<Household> getOrCreateFor(
    Session session,
    String ownerId,
  ) async {
    final existing = await findByOwner(session, ownerId);
    if (existing != null) return existing;

    final created = await Household.db.insertRow(
      session,
      Household(
        name: 'My Household',
        ownerId: ownerId,
        createdAt: DateTime.now(),
      ),
    );
    await HouseholdMember.db.insertRow(
      session,
      HouseholdMember(
        householdId: created.id.toString(),
        name: 'Owner',
        email: '',
        role: HouseholdMemberRole.owner,
        joinedAt: DateTime.now(),
      ),
    );
    return created;
  }
}
