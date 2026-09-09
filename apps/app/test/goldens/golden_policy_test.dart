import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:shipit_golden_app/features/authentication/presentation/screens/login_screen.dart';

/// Golden baseline policy.
///
/// Baselines carry a status in `goldens/goldens_registry.md`:
///   - `APPROVED` — reviewed and approved against an approved design revision
///     (login screens, promoted 2026-09-08). These are the visual contract.
///   - `DESIGN_PENDING` — candidate baselines preserving current rendered
///     output so future visual changes are intentional and reviewable on their
///     way to design approval.
///
/// Per AEF + AGENTS.md, approved golden baselines must never be silently
/// regenerated. Regenerating a baseline REQUIRES design/human approval:
///   - restore the golden (`git checkout -- <file>` or re-copy from the PR),
///   - update `test/goldens/goldens_registry.md` to record the change, and
///   - note the design revision the new baseline is approved against.
///
/// To (re)generate candidate DESIGN_PENDING baselines locally:
///
///     fvm flutter test test/goldens --update-goldens
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
        expect(columns.length, greaterThanOrEqualTo(4),
            reason: 'malformed registry row: $row');
        final file = columns[0].replaceAll('`', '');
        final status = columns[2];
        final designRevision = columns[3];

        expect(
          allowedStatuses.contains(status),
          isTrue,
          reason: 'unknown baseline status "$status" in:\n$row\n'
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

  group('approved golden baselines', () {
    late AuthenticationBloc loginBloc;

    setUp(() {
      loginBloc = AuthenticationBloc();
    });

    tearDown(() => loginBloc.close());

    Widget wrap(Widget child) {
      return MaterialApp(
        theme: shipitLightTheme(),
        darkTheme: shipitDarkTheme(),
        home: child,
      );
    }

    testWidgets('golden: login screen (sign in mode)', (tester) async {
      await tester.pumpWidget(wrap(LoginScreen(authBloc: loginBloc)));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_sign_in.png'),
      );
    });

    testWidgets('golden: login screen (register mode)', (tester) async {
      await tester.pumpWidget(
        wrap(
          LoginScreen(
            authBloc: loginBloc,
            initialMode: AuthScreenMode.register,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_register.png'),
      );
    });
  });
}