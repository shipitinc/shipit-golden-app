/// Golden baseline for the create-program form surface.
///
/// Renders the initial empty form (no error, idle) of `ProgramCreateScreen` as
/// the DESIGN_PENDING candidate baseline preserving current rendering at HEAD
/// (FEAT-PROGRAM-CREATE-001, PC-009). Registered as DESIGN_PENDING in
/// `goldens/goldens_registry.md`; promotion to APPROVED happens ONLY on the
/// Linux CI host via `.github/workflows/goldens-update.yml` after design/human
/// approval — macOS regeneration is prohibited. The candidate was bootstrapped
/// on a dev host only to satisfy the registry-conformance test, mirroring the
/// `program_details_golden_test.dart` conventions (`shipitLightTheme()`, real
/// Inter, idle state, `pumpAndSettle`).
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shipit_golden_app/features/programs/presentation/screens/create_program_screen.dart';
import 'package:shipit_ui/shipit_ui.dart';

void main() {
  testWidgets('golden: program create screen (initial empty form)', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: shipitLightTheme(), home: const ProgramCreateScreen()),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ProgramCreateView),
      matchesGoldenFile('goldens/program_create.png'),
    );
  });
}
