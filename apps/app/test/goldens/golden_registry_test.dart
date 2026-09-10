import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Golden registry conformance.
///
/// Host-agnostic structural checks over `goldens/goldens_registry.md`, so this
/// file is deliberately NOT tagged `golden` and runs on every host as part of
/// `melos run test:flutter`. Only the pixel comparisons in
/// `golden_policy_test.dart` are gated to the Linux CI host.
void main() {
  group('golden baseline registry conformance', () {
    test('every listed baseline exists, has a valid status, and approved '
        'baselines reference a design revision', () {
      const registryPath = 'test/goldens/goldens_registry.md';
      final registry = File(registryPath).readAsLinesSync();
      final baselineRows = registry
          .where((line) => line.startsWith('| `goldens/'))
          .toList();

      expect(
        baselineRows,
        isNotEmpty,
        reason: 'registry must list at least one baseline',
      );

      const allowedStatuses = {'DESIGN_PENDING', 'APPROVED'};
      for (final row in baselineRows) {
        final columns = row
            .split('|')
            .map((cell) => cell.trim())
            .where((cell) => cell.isNotEmpty)
            .toList();
        expect(
          columns.length,
          greaterThanOrEqualTo(4),
          reason: 'malformed registry row: $row',
        );
        final file = columns[0].replaceAll('`', '');
        final status = columns[2];
        final designRevision = columns[3];

        expect(
          allowedStatuses.contains(status),
          isTrue,
          reason:
              'unknown baseline status "$status" in:\n$row\n'
              'Expected one of: $allowedStatuses',
        );
        if (status == 'APPROVED') {
          expect(
            designRevision.isNotEmpty && designRevision != '(none)',
            isTrue,
            reason:
                'an APPROVED baseline must reference the design revision it '
                'was approved against.\n'
                'Row: $row',
          );
        }
        expect(
          File('test/goldens/$file').existsSync(),
          isTrue,
          reason: 'registry lists $file but the golden file is missing',
        );
      }
    });
  });
}
