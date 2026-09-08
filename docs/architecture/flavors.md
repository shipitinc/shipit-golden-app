# Environments (Flavors) — Golden App Standard

The Golden App ships as one codebase across **web, Android, and iOS** under the
three standard environments. This page is the canonical reference for how a
flavor is threaded through the whole stack. It is governed by
`app/lib/core/config/flavor_config.dart` and `product.yaml`; those are the
source of truth. This page only explains the pattern so future features follow
it without drift.

## The Three Environments

| Flavor       | Android appId                   | iOS bundleId                         | App name                 |
|--------------|--------------------------------|--------------------------------------|--------------------------|
| `development`| `io.letsshipit.golden`          | `io.letsshipit.golden`               | `[Dev] ShipIt Golden App`|
| `qa`         | `io.letsshipit.golden.qa`       | `io.letsshipit.golden.qa`            | `[QA] ShipIt Golden App` |
| `production` | `io.letsshipit.golden.production`| `io.letsshipit.golden.production`    | `ShipIt Golden App`      |

Rules that MUST hold:

- App IDs follow `io.letsshipit.golden` with `.qa` / `.production` suffixes.
- App **names are prefix-tagged** (`[Dev]` / `[QA]`) for development and QA so a
  user (or screenshot) can identify the environment at a glance. Production uses
  the plain product name.
- The **default flavor is `development`**. A build without any flavor
  configuration behaves as development, so `flutter run`/`melos run dev` still
  work for newcomers.

## How the Flavor is Resolved

The active flavor is a **compile-time constant**, read from the `FLAVOR`
dart-define in `FlavorConfig`:

```dart
const value = String.fromEnvironment('FLAVOR');
return AppFlavor.values.asNameMap()[value] ?? AppFlavor.development;
```

`FlavorConfig.appName` feeds `MaterialApp.title` (the browser tab and the web
title) and is also surfaced at runtime in the login screen. `FlavorConfig.serverUrl`
defaults per flavor (development → `http://localhost:8080`) and can be overridden
by an `API_BASE_URL` dart-define.

### Native wiring per platform

- **Web** — no native flavor concept; the `FLAVOR` dart-define alone drives
  `FlavorConfig`. Static shell (`web/index.html`, `web/manifest.json`) carries the
  neutral product name; the runtime tab title reflects the active flavor via
  `MaterialApp.title`.
- **Android** — Gradle product flavors `development` / `qa` / `production`, each
  with its own `applicationId`, `src/<flavor>/res/values/strings.xml` (app_name)
  and `src/<flavor>/res/mipmap-*/ic_launcher.png` icon source-set. Running with
  `--flavor <name>` selects it.
- **iOS** — per-flavor build configurations (`Debug/Profile/Release-<flavor>`)
  plus shared Xcode schemes `development` / `qa` / `production`. Each config sets
  `PRODUCT_BUNDLE_IDENTIFIER`, `APP_DISPLAY_NAME` (read by `Info.plist` through
  `$(APP_DISPLAY_NAME)`), base64 `DART_DEFINES` (so Xcode runs pass `FLAVOR` to
  Dart), `FLUTTER_TARGET` (the shared `lib/app/bootstrap/app_bootstrap.dart`
  entry point) and a per-flavor `ASSETCATALOG_COMPILER_APPICON_NAME`.

  The default `Runner.xcscheme` (plain Debug/Release/Profile, no `--flavor`)
  builds `io.letsshipit.shipitGoldenApp` and reads `FLAVOR` as development.

## Runtime use / display

- `Text(FlavorConfig.appName)` — login screen header.
- `MaterialApp.title: FlavorConfig.appName` — browser tab / web title.
- Per-flavor icons: Android launcher icons and iOS `AppIcon-<flavor>` catalogs
  (placeholder artwork — final assets require design approval, see AGENTS.md).

## Tooling / CI

- All run/build/test commands go through Melos from the repository root; there
  is a per-flavor script for every common operation:
  - `dev:app[:development|:qa|:production]` — Flutter web
  - `run:android[:development|:qa|:production]` — Android
  - `run:ios[:development|:qa|:production]` — iOS simulator
  - `build:web[:development|:qa|:production]` — web release
  - `build:android:development|:qa|:production` — Android APK
  - `build:ios:development|:qa|:production` — iOS (no codesign)
- Never invoke `flutter build` ad hoc with a global SDK; always `fvm` + Melos.

## Adding a Flavor to a New Feature

1. Read `FlavorConfig.current` / `FlavorConfig.appName` where a per-environment
   string is needed. Do not hard-code a fourth flavor name in feature code.
2. If the feature needs a per-flavor URL/constant, add it to `FlavorConfig`
   (compile-time) rather than to runtime state.
3. If it is a **visual** difference (icon, branding), follow the design authority
   process — placeholders are never shipped as final.