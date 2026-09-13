/// Golden baseline for the ProgramsScreen empty state.
///
/// Renders the empty-programs state of `ProgramsView` (message `Programs you
/// create will appear here.` + `Create program` CTA + app-bar actions incl. the
/// create action) as the DESIGN_PENDING candidate baseline preserving current
/// rendering at HEAD (FEAT-PROGRAM-CREATE-001, PC-009). Registered as
/// DESIGN_PENDING in `goldens/goldens_registry.md`; promotion to APPROVED
/// happens ONLY on the Linux CI host via `.github/workflows/goldens-update.yml`
/// after design/human approval — macOS regeneration is prohibited. The
/// candidate was bootstrapped on a dev host only to satisfy the
/// registry-conformance test, mirroring the `program_details_golden_test.dart`
/// conventions (`shipitLightTheme()`, real Inter, stubbed repository,
/// `pumpAndSettle`).
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/bloc/programs_bloc.dart';
import 'package:shipit_golden_app/features/programs/bloc/programs_event.dart';
import 'package:shipit_golden_app/features/programs/data/programs_repository.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';
import 'package:shipit_golden_app/features/programs/presentation/screens/programs_screen.dart';
import 'package:shipit_ui/shipit_ui.dart';

class _MockProgramsRepository extends Mock implements ProgramsRepository {}

void main() {
  testWidgets('golden: programs screen (empty state)', (tester) async {
    final repository = _MockProgramsRepository();
    when(() => repository.getPrograms()).thenAnswer(
      (_) async => Result.success(<Program>[]),
    );

    final bloc = ProgramsBloc(repository: repository);
    addTearDown(bloc.close);

    await tester.pumpWidget(
      MaterialApp(
        theme: shipitLightTheme(),
        home: BlocProvider.value(value: bloc, child: const ProgramsView()),
      ),
    );

    // The bloc roundtrip must run in the real async zone: an awaited mocktail
    // answer never completes inside the widget binding's fake zone (same
    // pattern as `programs_screen_test.dart` `loadPrograms`).
    await tester.runAsync(() async {
      bloc.add(const ProgramsStarted());
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(ProgramsView),
      matchesGoldenFile('goldens/programs_empty.png'),
    );
  });
}