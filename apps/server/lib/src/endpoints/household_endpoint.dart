import 'package:serverpod/serverpod.dart';
import 'package:shipit_golden_server/src/generated/protocol.dart';

class HouseholdEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Household> getCurrent(Session session) async {
    return Household(
      name: 'Demo Household',
      ownerId: session.authenticated!.userIdentifier,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    );
  }

  Future<List<HouseholdMember>> getMembers(Session session) async {
    return [
      HouseholdMember(
        householdId: 'household_1',
        name: 'John Doe',
        email: 'john@example.com',
        role: 'owner',
        joinedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      HouseholdMember(
        householdId: 'household_1',
        name: 'Jane Smith',
        email: 'jane@example.com',
        role: 'member',
        joinedAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }

  Future<HouseholdMember> addMember(
    Session session,
    String name,
    String email,
  ) async {
    return HouseholdMember(
      householdId: 'household_1',
      name: name,
      email: email,
      role: 'member',
      joinedAt: DateTime.now(),
    );
  }

  Future<void> removeMember(Session session, String memberId) async {}
}
