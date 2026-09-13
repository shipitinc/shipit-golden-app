/// Golden baseline for the program-details joined state.
///
/// Renders the loaded + **joined** detail surface of `ProgramDetailsView`
/// (AC-11 / P2 gap #1 closure: `_MembershipCard` shows `Joined · <name>`, the
/// `JOINED` badge, and the `Cancel Membership` CTA) as the DESIGN_PENDING
/// candidate baseline preserving current rendering at HEAD
/// (FEAT-PROGRAM-CREATE-001). It sits beside the existing not-joined
/// `program_details.png`. Registered as DESIGN_PENDING in
/// `goldens/goldens_registry.md`; promotion to APPROVED happens ONLY on the
/// Linux CI host via `.github/workflows/goldens-update.yml` after design/human
/// approval — macOS regeneration is prohibited. The candidate was bootstrapped
/// on a dev host only to satisfy the registry-conformance test and follows the
/// exact `program_details_golden_test.dart` conventions (`shipitLightTheme()`,
/// real Inter, stubbed repository, loaded+joined state, `pumpAndSettle`).
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_details_bloc.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_details_event.dart';
import 'package:shipit_golden_app/features/programs/data/programs_repository.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';
import 'package:shipit_golden_app/features/programs/presentation/screens/program_details_screen.dart';
import 'package:shipit_ui/shipit_ui.dart';

class _MockProgramsRepository extends Mock implements ProgramsRepository {}

void main() {
  testWidgets('golden: program details screen (loaded, joined)', (
    tester,
  ) async {
    final repository = _MockProgramsRepository();
    when(() => repository.getProgramById('1')).thenAnswer(
      (_) async => Result.success(
        Program(
          id: '1',
          name: 'Summer Camp',
          description: 'Annual summer camp for the whole household.',
          startDate: DateTime(2026, 6, 15),
          endDate: DateTime(2026, 8, 15),
          status: 'active',
        ),
      ),
    );
    when(
      () => repository.isJoined('1'),
    ).thenAnswer((_) async => Result.success(true));

    await tester.pumpWidget(
      MaterialApp(
        theme: shipitLightTheme(),
        home: BlocProvider(
          create: (_) =>
              ProgramDetailsBloc(programId: '1', repository: repository)
                ..add(const ProgramDetailsStarted()),
          child: const ProgramDetailsView(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ProgramDetailsView),
      matchesGoldenFile('goldens/program_details_joined.png'),
    );
  });
}
