import 'package:shipit_golden_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Generated protocol models', () {
    test('Household round-trips through Protocol serialization', () {
      final original = Household(
        id: 1,
        name: 'Demo Household',
        ownerId: 'user_1',
        createdAt: DateTime.utc(2026, 1, 15),
      );

      final json = original.toJsonForProtocol();
      final restored = Protocol().deserialize<Household>(json);

      expect(restored.id, 1);
      expect(restored.name, 'Demo Household');
      expect(restored.ownerId, 'user_1');
      expect(restored.createdAt, DateTime.utc(2026, 1, 15));
    });

    test('HouseholdMember round-trips through Protocol serialization', () {
      final original = HouseholdMember(
        id: 7,
        householdId: 'household_1',
        name: 'Jane Smith',
        email: 'jane@example.com',
        role: HouseholdMemberRole.member,
        joinedAt: DateTime.utc(2026, 2, 1),
      );

      final json = original.toJsonForProtocol();
      final restored = Protocol().deserialize<HouseholdMember>(json);

      expect(restored.id, 7);
      expect(restored.householdId, 'household_1');
      expect(restored.name, 'Jane Smith');
      expect(restored.role, HouseholdMemberRole.member);
      expect(restored.joinedAt, DateTime.utc(2026, 2, 1));
    });

    test('Program round-trips through Protocol serialization', () {
      final original = Program(
        id: 3,
        name: 'Summer Camp',
        description: 'Annual summer camp for families',
        startDate: DateTime.utc(2026, 6, 15),
        endDate: DateTime.utc(2026, 8, 15),
        status: ProgramStatus.active,
      );

      final json = original.toJsonForProtocol();
      final restored = Protocol().deserialize<Program>(json);

      expect(restored.id, 3);
      expect(restored.name, 'Summer Camp');
      expect(restored.status, ProgramStatus.active);
      expect(restored.startDate, DateTime.utc(2026, 6, 15));
      expect(restored.endDate, DateTime.utc(2026, 8, 15));
    });
  });
}
