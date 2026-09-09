import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

/// Deterministic font loading for golden tests.
///
/// shipit_ui bundles the Inter TTFs and resolves every `AppTypography` style to
/// the packaged family `packages/shipit_ui/Inter`. Approved golden baselines
/// were captured with golden_toolkit's Roboto, so tests keep pinning the
/// resolved families to Roboto: candidates stay byte-deterministic across
/// hosts and approved baselines remain reviewable.
///
/// Pending migration (GAP-009 / shipit-ui #8): register the real bundled Inter
/// TTFs here and regenerate the golden baselines on Linux with design/human
/// approval. See `docs/design/upstream-ui-gaps.md`.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadAppFonts();
  final roboto = rootBundle.load(
    'packages/golden_toolkit/fonts/Roboto-Regular.ttf',
  );
  for (final family in ['Inter', 'packages/shipit_ui/Inter']) {
    await (FontLoader(family)..addFont(roboto)).load();
  }
  await testMain();
}
