/// Approved golden baseline policy.
///
/// Baselines carry a status in `goldens/goldens_registry.md`:
///   - `APPROVED` — reviewed and approved against an approved design revision
///     (login screens, promoted 2026-09-08). These are the visual contract.
///   - `DESIGN_PENDING` — candidate baselines preserving current rendered
///     output so future visual changes are intentional and reviewable on their
///     way to design approval.
///
/// The pixel comparisons in this file are tagged `golden` through the library
/// annotation below and are enforced via `melos run test:golden` on the Linux
/// CI host (the platform of record for approved baselines). `melos run
/// test:flutter` excludes them (`--exclude-tags golden`) so a fresh dev machine
/// — macOS renders text ~1% differently — is never red "by design". See
/// docs/qa/strategy.md.
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
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:shipit_golden_app/features/authentication/presentation/screens/login_screen.dart';
import 'package:shipit_ui/shipit_ui.dart';

void main() {
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
