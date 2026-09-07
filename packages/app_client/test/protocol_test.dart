import 'package:app_client/app_client.dart' as api;
import 'package:test/test.dart';

void main() {
  group('app_client generated protocol', () {
    test('Household round-trips through Protocol serialization', () {
      final original = api.Household(
        id: 1,
        name: 'Demo Household',
        ownerId: 'user_1',
        createdAt: DateTime.utc(2026, 1, 15),
      );

      final json = original.toJson();
      final restored = api.Protocol().deserialize<api.Household>(json);

      expect(restored.id, 1);
      expect(restored.name, 'Demo Household');
      expect(restored.ownerId, 'user_1');
      expect(restored.createdAt, DateTime.utc(2026, 1, 15));
    });

    test('Program round-trips through Protocol serialization', () {
      final original = api.Program(
        id: 3,
        name: 'Summer Camp',
        description: 'Annual summer camp',
        startDate: DateTime.utc(2026, 6, 15),
        endDate: DateTime.utc(2026, 8, 15),
        status: 'active',
      );

      final json = original.toJson();
      final restored = api.Protocol().deserialize<api.Program>(json);

      expect(restored.id, 3);
      expect(restored.name, 'Summer Camp');
      expect(restored.status, 'active');
    });
  });
}
