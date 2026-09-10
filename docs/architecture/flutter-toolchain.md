# Flutter Toolchain

## FVM (Flutter Version Management)

### Pinned Version
- **Flutter**: 3.44.7 (stable)
- **Dart**: 3.12.2
- **FVM**: 4.1.2

### Configuration Files
```
.fvmrc           # Contains: 3.44.7
.fvm/            # FVM cache (gitignored)
```

### Usage
```bash
# Install pinned version
fvm install

# Run Flutter commands
fvm flutter --version
fvm flutter analyze
fvm flutter test
fvm flutter build web

# Run Dart commands
fvm dart --version
fvm dart analyze
fvm dart run build_runner build
```

### Global vs Pinned
| Scenario | Command |
|----------|---------|
| This repository | `fvm flutter ...` |
| Other projects | `flutter ...` (global) |
| CI/CD | `fvm flutter ...` |

**Never use global Flutter** for this repository.

## Melos + FVM Integration

### Script Execution
Melos runs commands in package directories. FVM Flutter is available because:

1. `fvm install` creates `.fvm/flutter_sdk` symlink
2. PATH includes FVM shims when `fvm` is in PATH
3. Melos inherits shell environment

### Melos Scripts (`pubspec.yaml` `melos:` section)

Scripts are defined in the workspace `pubspec.yaml` under the `melos:` key
(Melos 8). Multi-step scripts use `steps:` to compose sub-scripts:

```yaml
melos:
  scripts:
    format:
      description: Format all Dart code.
      exec: fvm dart format .

    analyze:
      description: Analyze all code.
      exec: fvm dart analyze .

    generate:
      description: Run all code generation (Serverpod, Freezed, JSON serialization).
      steps:
        - generate:server
        - generate:freezed

    test:
      description: Run all tests.
      steps:
        - test:unit
        - test:server
        - test:flutter

    qa:
      description: >-
        Run default QA pipeline (analyze + tests). Device/server-gated suites
        (integration, Patrol) are opt-in; see docs/qa/strategy.md.
      steps:
        - analyze
        - test
```

Single-step scripts use `run:` (for shell pipelines) or `exec:` (for simple
commands). The full matrix of `dev:app:*`, `run:android:*`, `run:ios:*`,
`build:web:*`, `build:android:*` and `build:ios:*` scripts lives in the
root `pubspec.yaml`.

## Flutter Upgrade Workflow

### When to Upgrade
- New stable release with needed features
- Security patches
- Compatibility with dependencies

### Process
```bash
# 1. Choose target version (check https://flutter.dev/docs/release/archive)
# 2. Update pin
echo "3.XX.X" > .fvmrc

# 3. Install new version
fvm install

# 4. Update dependencies
melos bootstrap

# 5. Regenerate code
melos run generate

# 6. Format & analyze
melos run format
melos run analyze

# 7. Run tests
melos run test
melos run qa

# 8. Build the web target
melos run build:web

# 9. Review changes
git diff

# 10. Commit
git add .fvmrc pubspec.lock  # package-level locks are gitignored (melos/bootstrap-managed)
git commit -m "chore: upgrade Flutter to 3.XX.X"
```

### Validation Checklist
- [ ] `fvm flutter --version` shows new version
- [ ] `melos run analyze` passes (0 issues)
- [ ] `melos run test` passes (all green)
- [ ] `melos run build:web` succeeds
- [ ] No deprecated API usage warnings
- [ ] Dependencies compatible (check `flutter pub outdated`)

## Build Targets

> Web, Android, and iOS are all scaffolded (`product.yaml`). Each runs under the
> three standard flavors (`development` / `qa` / `production`), resolved from the
> `FLAVOR` dart-define. Entry point is `lib/app/bootstrap/app_bootstrap.dart`.

### Web
```bash
fvm flutter build web --release --dart-define=FLAVOR=development
# Output: build/web/
```

### Android (per flavor)
```bash
fvm flutter build apk --flavor development --dart-define=FLAVOR=development \
  --target=lib/app/bootstrap/app_bootstrap.dart
# Output: build/app/outputs/flutter-apk/app-development-release.apk
```

### iOS (per flavor, no codesign)
```bash
fvm flutter build ios --no-codesign --flavor development \
  --dart-define=FLAVOR=development --target=lib/app/bootstrap/app_bootstrap.dart
# Output: build/ios/iphoneos/Runner.app
```

## Flavor Configuration

App IDs and display names are split per flavor across the native projects:

- **Dart/behavior** — `apps/app/lib/core/config/flavor_config.dart` reads the
  `FLAVOR` dart-define (`String.fromEnvironment`, default `development`);
  `FlavorConfig.appName` / `FlavorConfig.serverUrl` drive the tab title and API URL.
- **Android** — product flavors (`development`/`qa`/`production`) in
  `apps/app/android/app/build.gradle.kts`, each with a distinct `applicationId` and a per-flavor
  `src/<flavor>/res/values/strings.xml` (`app_name`) and `src/<flavor>/res/mipmap-*/ic_launcher.png`
  icon source-set.
- **iOS** — per-flavor build configurations (`Debug/Profile/Release-<flavor>`) and shared schemes
  (`development`/`qa`/`production`). Each config sets `PRODUCT_BUNDLE_IDENTIFIER`,
  `APP_DISPLAY_NAME` (consumed by `Info.plist` `$(APP_DISPLAY_NAME)`),
  `DART_DEFINES` (base64 `FLAVOR=<flavor>`), `FLUTTER_TARGET`, and a per-flavor
  `ASSETCATALOG_COMPILER_APPICON_NAME` (`AppIcon-<flavor>` catalog).

Apple device vs account naming: use the Melos scripts in the root `pubspec.yaml`
to run/build per flavor rather than invoking `flutter` ad hoc.

## Development Workflow

### Hot Reload / Restart
```bash
# Web
fvm flutter run -d web-server --web-port=8080
```

### Device Selection
```bash
fvm flutter devices
fvm flutter emulators
```

## Code Generation

### build_runner
```bash
# Watch mode (development)
fvm dart run build_runner watch --delete-conflicting-outputs

# One-time (CI)
fvm dart run build_runner build --delete-conflicting-outputs
```

### Generated Files
- `*.freezed.dart` / `*.g.dart` — Freezed / json_serializable (gitignored)
- `apps/server/lib/src/generated/` — Serverpod server protocol/endpoints (gitignored)
- `packages/app_client/lib/src/protocol/` — Serverpod client protocol/endpoints (gitignored)

> Serverpod generates plain Dart serialization (HTTP/JSON) — NOT gRPC. The
> `*.grpc.dart` ignore pattern in `apps/app/.gitignore` / `packages/app_client/.gitignore`
> is defensive only; no gRPC artifacts exist in this repo. Generated code is not
> committed (see root `.gitignore` and AGENTS.md); run `melos run generate` (or
> `generate:server` / `generate:freezed`) after changing models, state classes,
> or endpoints so `analyze` and `test` can run on fresh checkouts.

## IDE Configuration

### VS Code
```json
// .vscode/settings.json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk",
  "dart.sdkPath": ".fvm/flutter_sdk/bin/cache/dart-sdk"
}
```

### IntelliJ/Android Studio
- Flutter SDK: `.fvm/flutter_sdk`
- Dart SDK: `.fvm/flutter_sdk/bin/cache/dart-sdk`

## Troubleshooting

### FVM Not Found
```bash
dart pub global activate fvm
export PATH="$PATH:$HOME/.pub-cache/bin"
```

### Version Mismatch
```bash
fvm use 3.44.7
fvm flutter clean
melos bootstrap
```

### Build Failures
```bash
fvm flutter clean
rm -rf .dart_tool
melos bootstrap
melos run generate
```

## Performance

### Build Cache
- `.dart_tool/` — Dart package cache
- `build/` — Build outputs
- FVM caches SDKs in `~/.fvm/versions/`

### Incremental Builds
- `fvm flutter build` uses incremental compilation
- `build_runner` tracks file changes
- Clean only when necessary