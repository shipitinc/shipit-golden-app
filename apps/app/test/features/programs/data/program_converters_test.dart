import 'package:app_client/app_client.dart' as api;
import 'package:flutter_test/flutter_test.dart';
import 'package:shipit_golden_app/features/programs/data/program_converters.dart';

void main() {
  group('programFromProtocol', () {
    test('maps protocol fields to domain program', () {
      final program = programFromProtocol(
        api.Program(
          id: 3,
          name: 'Summer Camp',
          description: 'Annual summer camp for families',
          startDate: DateTime(2026, 6, 15),
          endDate: DateTime(2026, 8, 15),
          status: 'active',
        ),
      );

      expect(program.id, '3');
      expect(program.name, 'Summer Camp');
      expect(program.description, 'Annual summer camp for families');
      expect(program.startDate, DateTime(2026, 6, 15));
      expect(program.endDate, DateTime(2026, 8, 15));
      expect(program.status, 'active');
    });

    test('falls back to empty string id when id is null', () {
      final program = programFromProtocol(
        api.Program(
          name: 'Winter',
          description: 'Winter workshop',
          startDate: DateTime(2026, 12, 1),
          endDate: DateTime(2026, 12, 20),
          status: 'upcoming',
        ),
      );

      expect(program.id, '');
    });
  });
}
