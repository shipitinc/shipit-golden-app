import 'package:app_client/app_client.dart' as api;
import 'package:flutter_test/flutter_test.dart';
import 'package:shipit_golden_app/features/household/data/household_converters.dart';

void main() {
  group('householdFromProtocol', () {
    test('maps protocol fields to domain household', () {
      final protocolHousehold = api.Household(
        id: 42,
        name: 'Test Household',
        ownerId: 'user_1',
        createdAt: DateTime(2026, 1, 1),
      );

      final household = householdFromProtocol(protocolHousehold);

      expect(household.id, '42');
      expect(household.name, 'Test Household');
      expect(household.ownerId, 'user_1');
      expect(household.createdAt, DateTime(2026, 1, 1));
    });

    test('falls back to empty string id when id is null', () {
      final household = householdFromProtocol(
        api.Household(
          name: 'No Id',
          ownerId: 'user_1',
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      expect(household.id, '');
    });
  });

  group('householdMemberFromProtocol', () {
    test('maps protocol fields to domain household member', () {
      final member = householdMemberFromProtocol(
        api.HouseholdMember(
          id: 7,
          householdId: 'h_1',
          name: 'Jane Smith',
          email: 'jane@example.com',
          role: api.HouseholdMemberRole.member,
          joinedAt: DateTime(2026, 2, 1),
        ),
      );

      expect(member.id, '7');
      expect(member.householdId, 'h_1');
      expect(member.name, 'Jane Smith');
      expect(member.email, 'jane@example.com');
      expect(member.role, 'member');
      expect(member.joinedAt, DateTime(2026, 2, 1));
    });
  });
}
