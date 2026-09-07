import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:shipit_golden_app/features/authentication/presentation/screens/login_screen.dart';

/// Accessibility semantics tests (see `product.yaml` -> `qa.accessibility`).
///
/// These assert machine-checkable semantics: labeled form fields, sufficiently
/// large tap targets, and meaningful button labels. They do NOT replace
/// human/manual accessibility review.
void main() {
  late AuthenticationBloc bloc;

  setUp(() {
    bloc = AuthenticationBloc();
  });

  tearDown(() => bloc.close());

  Widget wrap(Widget child) {
    return MaterialApp(
      theme: shipitLightTheme(),
      darkTheme: shipitDarkTheme(),
      home: child,
    );
  }

  testWidgets('email and password fields expose labels to assistive tech', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(LoginScreen(authBloc: bloc)));
    await tester.pumpAndSettle();

    final appTextFields = find.byType(AppTextField);
    expect(appTextFields, findsNWidgets(2));

    final emailSemantics = tester.getSemantics(appTextFields.at(0));
    expect(emailSemantics.label, contains('Email'));

    final passwordSemantics = tester.getSemantics(appTextFields.at(1));
    expect(passwordSemantics.label, contains('Password'));
  });

  testWidgets('sign-in button meets minimum touch target size', (tester) async {
    await tester.pumpWidget(wrap(LoginScreen(authBloc: bloc)));
    await tester.pumpAndSettle();

    final box = tester.getSize(find.byType(AppButton));
    expect(
      box.height,
      greaterThanOrEqualTo(40),
      reason: 'tap target below the 40dp accessibility minimum (Material).',
    );

    final semantics = tester.getSemantics(find.byType(AppButton));
    expect(semantics.label, contains('Sign In'));
  });
}
