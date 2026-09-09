import 'package:serverpod/serverpod.dart';
import 'package:shipit_golden_server/src/generated/protocol.dart';

class HouseholdEndpoint extends Endpoint {
  static int _nextId = 3;

  /// In-memory member store for the dev stub so that id-based add/remove
  /// operations are stable within a server process lifetime.
  static final List<HouseholdMember> _members = [
    HouseholdMember(
      id: 1,
      householdId: 'household_1',
      name: 'John Doe',
      email: 'john@example.com',
      role: 'owner',
      joinedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    HouseholdMember(
      id: 2,
      householdId: 'household_1',
      name: 'Jane Smith',
      email: 'jane@example.com',
      role: 'member',
      joinedAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

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
    return List.unmodifiable(_members);
  }

  Future<HouseholdMember> addMember(
    Session session,
    String name,
    String email,
  ) async {
    await _simulateNetworkLatency();
    final member = HouseholdMember(
      id: _nextId++,
      householdId: 'household_1',
      name: name,
      email: email,
      role: 'member',
      joinedAt: DateTime.now(),
    );
    _members.add(member);
    return member;
  }

  Future<void> removeMember(Session session, String memberId) async {
    await _simulateNetworkLatency();
    _members.removeWhere((m) => m.id.toString() == memberId);
  }

  /// Deliberately mimics the latency of a real backend so loading/shimmer
  /// states (e.g. the members-table shimmer) are visible while developing
  /// against the local stub.
  Future<void> _simulateNetworkLatency() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }
}
