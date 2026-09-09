import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:shipit_ui/shipit_ui.dart';

/// Deterministic, real-Inter font loading for golden tests.
///
/// shipit_ui bundles the Inter TTFs and resolves every `AppTextTokens` style to
/// the packaged family [AppTheme.light.font.resolvedFamily]
/// (`packages/shipit_ui/Inter`). Load the actual bundled TTFs under both the
/// plain and resolved family names so candidates rasterize with the same glyphs
/// the running app shows, deterministically on every host (closes GAP-009).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadAppFonts();
  const ttfAssets = [
    'assets/fonts/Inter-Regular.ttf',
    'assets/fonts/Inter-Medium.ttf',
    'assets/fonts/Inter-SemiBold.ttf',
    'assets/fonts/Inter-Bold.ttf',
  ];
  for (final family in ['Inter', AppTheme.light.font.resolvedFamily]) {
    final loader = FontLoader(family);
    for (final asset in ttfAssets) {
      loader.addFont(rootBundle.load('packages/shipit_ui/$asset'));
    }
    await loader.load();
  }
  await testMain();
}
