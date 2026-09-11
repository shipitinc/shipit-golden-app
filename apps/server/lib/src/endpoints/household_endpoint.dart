import 'package:serverpod/serverpod.dart';
import 'package:shipit_golden_server/src/generated/protocol.dart';

/// Household endpoint backed by PostgreSQL.
///
/// Each authenticated user owns exactly one household, created automatically on
/// first access. Any authenticated member can add or remove members.
class HouseholdEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns the household owned by the authenticated user, creating one
  /// (with the caller as owner-member) if it does not yet exist.
  Future<Household> getCurrent(Session session) async {
    final ownerId = session.authenticated!.userIdentifier;
    final household = await _findHouseholdByOwner(session, ownerId);
    if (household != null) return household;

    // First access — auto-create household and add the owner as a member.
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
        role: 'owner',
        joinedAt: DateTime.now(),
      ),
    );
    return created;
  }

  /// Returns all members of the authenticated user's household.
  Future<List<HouseholdMember>> getMembers(Session session) async {
    final household = await _requireHousehold(session);
    return HouseholdMember.db.find(
      session,
      where: (m) => m.householdId.equals(household.id.toString()),
    );
  }

  /// Adds a member to the authenticated user's household.
  Future<HouseholdMember> addMember(
    Session session,
    String name,
    String email,
  ) async {
    final household = await _requireHousehold(session);
    return HouseholdMember.db.insertRow(
      session,
      HouseholdMember(
        householdId: household.id.toString(),
        name: name,
        email: email,
        role: 'member',
        joinedAt: DateTime.now(),
      ),
    );
  }

  /// Removes a member from the authenticated user's household by member ID.
  ///
  /// Rejects non-numeric [memberId] with a 400
  /// ([InvalidMemberIdException]) rather than a 500 from `int.parse`.
  Future<void> removeMember(Session session, String memberId) async {
    final household = await _requireHousehold(session);
    final memberIdInt = int.tryParse(memberId);
    if (memberIdInt == null) {
      throw InvalidMemberIdException();
    }
    await HouseholdMember.db.deleteWhere(
      session,
      where: (m) =>
          m.id.equals(memberIdInt) &
          m.householdId.equals(household.id.toString()),
    );
  }

  /// Finds the household owned by [ownerId], or `null` if none exists.
  Future<Household?> _findHouseholdByOwner(
    Session session,
    String ownerId,
  ) async {
    final households = await Household.db.find(
      session,
      where: (h) => h.ownerId.equals(ownerId),
      limit: 1,
    );
    return households.isEmpty ? null : households.first;
  }

  /// Returns the authenticated user's household, throwing if none exists.
  Future<Household> _requireHousehold(Session session) async {
    final ownerId = session.authenticated!.userIdentifier;
    final household = await _findHouseholdByOwner(session, ownerId);
    if (household == null) {
      throw StateError(
        'No household found for user $ownerId. '
        'Call getCurrent first to auto-create.',
      );
    }
    return household;
  }
}
