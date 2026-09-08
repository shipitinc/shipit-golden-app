import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

/// Deterministic font loading for golden tests.
///
/// Without a bundled font, Flutter's test binding falls back to a
/// platform-default box font whose antialiasing differs between CI
/// (Linux) and golden-generation hosts (macOS), producing small but
/// stable pixel diffs. Loading one concrete TTF (golden_toolkit's
/// Roboto) makes glyph rasterization byte-identical across hosts.
///
/// UPSTREAM_UI_GAP: shipit_ui requests `Inter` (AppTypography.fontFamily)
/// but does not bundle the TTF. We pin the family to golden_toolkit's
/// Roboto in tests so candidates stay reviewable and deterministic.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadAppFonts();
  final interFont = FontLoader('Inter')
    ..addFont(
      rootBundle.load('packages/golden_toolkit/fonts/Roboto-Regular.ttf'),
    );
  await interFont.load();
  await testMain();
}