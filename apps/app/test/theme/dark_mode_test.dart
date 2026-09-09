import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shipit_ui/shipit_ui.dart';

/// Dark-mode regression coverage (UPSTREAM_UI_GAP-011, shipitinc/shipit-ui#10).
///
/// Guards against the prior defect where `shipitDarkTheme()` reused the static
/// light `AppColors` for surfaces while painting text white — dark mode showed
/// a light canvas with nearly invisible text, and only icon/primary bits
/// adapted. The token-tree refactor (context.color.*, `AppTheme.dark`) fixed
/// it upstream; this test keeps the golden app's consumption honest.
double _luminance(Color color) {
  double channel(double c) {
    final linear = c <= 0.03928
        ? c / 12.92
        : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
    return linear;
  }

  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}

double _contrastRatio(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final lighter = math.max(la, lb);
  final darker = math.min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('dark theme (GAP-011 regression)', () {
    Future<ThemeData> themeOf(
      WidgetTester tester,
      Brightness brightness,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: shipitLightTheme(),
          darkTheme: shipitDarkTheme(),
          themeMode: brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          home: const Scaffold(body: Center(child: Text('Sign in'))),
        ),
      );
      await tester.pumpAndSettle();
      return Theme.of(tester.element(find.byType(Scaffold)));
    }

    testWidgets('dark scaffold and body text are genuinely dark and readable', (
      tester,
    ) async {
      final dark = await themeOf(tester, Brightness.dark);

      expect(
        ThemeData.estimateBrightnessForColor(dark.scaffoldBackgroundColor),
        Brightness.dark,
        reason:
            'dark mode scaffold must use a dark surface (was light #F8FAFC)',
      );
      final textColor = dark.textTheme.bodyMedium!.color;
      expect(textColor, isNotNull);
      final ratio = _contrastRatio(textColor!, dark.scaffoldBackgroundColor);
      expect(
        ratio,
        greaterThanOrEqualTo(4.5),
        reason: 'body text vs scaffold must meet WCAG AA (was white-on-light)',
      );
    });

    testWidgets('light and dark themes expose visibly different surfaces', (
      tester,
    ) async {
      final light = await themeOf(tester, Brightness.light);
      final dark = await themeOf(tester, Brightness.dark);

      expect(
        dark.scaffoldBackgroundColor,
        isNot(light.scaffoldBackgroundColor),
        reason: 'toggling theme mode must actually repaint the canvas',
      );
      expect(
        ThemeData.estimateBrightnessForColor(light.scaffoldBackgroundColor),
        Brightness.light,
      );
    });
  });
}
