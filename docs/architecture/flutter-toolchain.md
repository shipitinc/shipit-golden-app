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
```yaml
scripts:
  analyze: melos exec -- dart analyze
  test: melos exec -- flutter test
  build:web: melos exec --scope=shipit_golden_app -- flutter build web --release
  generate:freezed: melos exec --scope=shipit_golden_app -- fvm dart run build_runner build --delete-conflicting-outputs
  test:unit: melos exec --scope=app_client -- fvm dart test
  test:server: melos exec --scope=shipit_golden_server -- fvm dart test
  test:flutter: melos exec --scope=shipit_golden_app -- fvm flutter test
```

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

> Only the **web** target is scaffolded in this baseline (`product.yaml`). There
> is no Android project (no Gradle build) and no iOS project (no `Runner.xcodeproj`),
> so `build:android` / `build:ios` do not exist. Add platforms deliberately in a
> later Phase.

### Web
```bash
fvm flutter build web --release
# Output: build/web/
```

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
- `*.freezed.dart` — Freezed unions (committed)
- `apps/server/lib/src/generated/` — Serverpod server protocol/endpoints (committed)
- `packages/app_client/lib/src/protocol/` — Serverpod client protocol/endpoints (committed)

> Serverpod generates plain Dart serialization (HTTP/JSON) — NOT gRPC. The
> `*.grpc.dart` ignore pattern in `apps/app/.gitignore` / `packages/app_client/.gitignore`
> is defensive only; no gRPC artifacts exist in this repo. Generated code is
> committed by design (see root `.gitignore`); never delete it for CI.
> Run `melos run generate:check` to verify committed baselines match a fresh generate.

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