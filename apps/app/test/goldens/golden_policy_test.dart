import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:shipit_golden_app/features/authentication/presentation/screens/login_screen.dart';

/// Golden baseline policy.
///
/// These baselines are CANDIDATE DESIGN_PENDING baselines: they preserve the
/// current rendered output so future visual changes are intentional and
/// reviewable. They are NOT approved product baselines yet.
///
/// Per AEF + AGENTS.md, approved golden baselines must never be silently
/// regenerated. Regenerating a baseline REQUIRES design/human approval:
///   - restore the golden (`git checkout -- <file>` or re-copy from the PR),
///   - update `test/goldens/goldens_registry.md` to record the change, and
///   - note the DESIGN_PENDING -> APPROVED transition (or keep DESIGN_PENDING).
///
/// To (re)generate candidate baselines locally:
///
///     fvm flutter test test/goldens --update-goldens
void main() {
  group('golden baseline registry conformance', () {
    test('every listed baseline exists and is DESIGN_PENDING', () {
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
      for (final row in baselineRows) {
        expect(
          row,
          contains('DESIGN_PENDING'),
          reason:
              'no baseline may be silently promoted to APPROVED without '
              'design/human approval; update the registry deliberately.\n'
              'Row: $row',
        );
      }

      final listedFiles = baselineRows
          .map((row) => RegExp('`(goldens/[^`]+)`').firstMatch(row)!.group(1)!)
          .toList();
      for (final file in listedFiles) {
        expect(
          File('test/goldens/$file').existsSync(),
          isTrue,
          reason: 'registry lists $file but the golden file is missing',
        );
      }
    });
  });

  group('candidate DESIGN_PENDING golden baselines', () {
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
