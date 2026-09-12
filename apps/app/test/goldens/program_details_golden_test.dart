/// Golden baseline for the program-details detail surface.
///
/// Renders the owner-approved (2026-09-12) loaded detail surface (not-joined
/// membership state) as the visual contract for the program-detail screen,
/// promoted to APPROVED against `shipit_ui@c310a961aa` in
/// `goldens/goldens_registry.md`. The authoritative PNG is regenerated on the
/// Linux CI host via `.github/workflows/goldens-update.yml`; the initially
/// committed baseline was bootstrapped on a dev host only to satisfy the
/// registry conformance test — see `docs/qa/pending-actions.md` #11.
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
  testWidgets('golden: program details screen (loaded, not joined)', (
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
    ).thenAnswer((_) async => Result.success(false));

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
      matchesGoldenFile('goldens/program_details.png'),
    );
  });
}
