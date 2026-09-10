# ShipIt Golden App

The canonical reference implementation proving the standard ShipIt product architecture.

**This is NOT a production product.** It is a thin vertical slice demonstrating the preferred architecture, conventions, testing strategy, monorepo structure, design-system integration, state management, backend architecture, Flutter-version management, and local development workflow.

## Repository Purpose

This repository demonstrates:
- Flutter ↔ Serverpod generated client communication
- Serverpod ↔ PostgreSQL
- Authentication architecture
- shipit_ui usage
- BLoC + Freezed state management
- Immutable application state
- Responsive web/mobile layout
- Structured error handling
- Testing (unit, widget, golden, accessibility, integration, E2E)
- Local startup with Docker Compose
- Data seeding and health checking
- Melos orchestration
- FVM-pinned Flutter toolchain
- Serverpod code generation workflow

## Relationship to Upstream

- **Agentic Engineering Framework (AEF):** Authoritative governance — https://github.com/shipitinc/agentic-engineering-framework.git
- **shipit_ui:** Authoritative design system — https://github.com/shipitinc/shipit-ui.git (v0.1.0)

## Monorepo Structure

```
/
├── .github/                 # CI workflows (qa.yml)
├── apps/
│   ├── app/                 # End-user Flutter application
│   └── server/              # Serverpod backend
├── packages/
│   └── app_client/          # Serverpod generated client
├── docs/
│   ├── architecture/
│   ├── design/
│   └── qa/
├── pubspec.yaml          # Workspace + melos: scripts (Melos 8)
├── product.yaml
├── .fvmrc
├── AGENTS.md
├── README.md
└── compose.yaml
```

## Prerequisites

- **FVM** (Flutter Version Management) — `dart pub global activate fvm`
- **Melos** — `dart pub global activate melos`
- **Docker & Docker Compose** — for PostgreSQL
- **Serverpod CLI** — `dart pub global activate serverpod_cli`

## Quick Start

```bash
# 1. Install pinned Flutter SDK
fvm install

# 2. Install dependencies
melos bootstrap

# 3. Start local infrastructure (PostgreSQL)
docker compose up -d

# 4. Generate code (Serverpod, Freezed, JSON)
melos run generate

# 5. Start development servers (server applies migrations automatically)
melos run dev
```

This starts:
- Serverpod on `http://localhost:8080` (migrations auto-applied via `applyMigrations`)
- Flutter web on `http://localhost:8081` (API at `http://localhost:8080`)

## Commands

All commands run from repository root via Melos:

| Command | Description |
|---------|-------------|
| `melos bootstrap` | Install all dependencies |
| `melos run generate` | Generate all code (Serverpod, Freezed, JSON) |
| `melos run generate:server` | Serverpod generate (server output + client package) |
| `melos run generate:client` | Serverpod generate (same as `generate:server`; Serverpod has no client-only mode) |
| `melos run generate:freezed` | Freezed/JSON generation only |
| `melos run generate:check` | Drift gate (tracked diff + generated-manifest hash) |
| `melos run generate:manifest` | Re-snapshot `.generated_manifest.json` after model changes |
| `melos run format` | Format all code |
| `melos run analyze` | Analyze all code |
| `melos run test` | Run all non-integration tests |
| `melos run test:unit` | Dart unit tests (app_client) |
| `melos run test:server` | Serverpod server tests |
| `melos run test:flutter` | Flutter app tests (unit + widget + accessibility; golden pixel comparisons run only via `test:golden`) |
| `melos run test:integration` | Flutter integration tests (requires live server + device) |
| `melos run qa` | Full QA pipeline (analyze + test; integration is opt-in) |
| `melos run dev` | Start dev servers (server + app) |
| `melos run dev:server` | Start Serverpod only |
| `melos run dev:app` | Start Flutter web only (development flavor) |
| `melos run dev:app:qa` | Start Flutter web only (qa flavor) |
| `melos run dev:app:production` | Start Flutter web only (production flavor) |
| `melos run run:android` | Run app on Android (development flavor) |
| `melos run run:ios` | Run app on iOS simulator (development flavor) |
| `melos run build:web` | Build Flutter web release (development flavor) |
| `melos run build:android:development` | Build Android release APK (development) |
| `melos run build:android:qa` | Build Android release APK (qa) |
| `melos run build:android:production` | Build Android release APK (production) |
| `melos run build:ios:development` | Build iOS (no codesign) (development) |
| `melos run build:ios:qa` | Build iOS (no codesign) (qa) |
| `melos run build:ios:production` | Build iOS (no codesign) (production) |

## Environments (Flavors)

The app targets the three standard environments, resolved from the `FLAVOR`
dart-define (defaults to `development`):

| Flavor       | Android appId                    | iOS bundleId                       | App name                 |
|--------------|----------------------------------|------------------------------------|--------------------------|
| `development`| `io.letsshipit.golden`           | `io.letsshipit.golden`             | `[Dev] ShipIt Golden App`|
| `qa`         | `io.letsshipit.golden.qa`        | `io.letsshipit.golden.qa`          | `[QA] ShipIt Golden App` |
| `production` | `io.letsshipit.golden.production`| `io.letsshipit.golden.production`  | `ShipIt Golden App`      |

The active flavor is compiled in via `--dart-define=FLAVOR=<flavor>` and drives
`FlavorConfig` (app name shown in the browser tab / login screen and per-flavor
API URL). Native app IDs and display names come from the Android product flavors
and iOS schemes/build configs. See `docs/architecture/flutter-toolchain.md`.

## Flutter Version Management

Flutter SDK is pinned via FVM (`.fvmrc` = `3.44.7`). All Flutter/Dart commands use the pinned version:

```bash
fvm flutter --version   # 3.44.7
fvm dart --version      # 3.12.2
```

**Never use a global Flutter installation** for this repository.

### Flutter Upgrade Workflow

```bash
# 1. Choose target stable version
# 2. Update .fvmrc
# 3. fvm install
# 4. melos bootstrap
# 5. melos run generate
# 6. melos run format
# 7. melos run analyze
# 8. melos run test
# 9. melos run qa
# 10. Build all targets
# 11. Review and commit
```

## Architecture Overview

### Frontend (apps/app)
- Flutter with BLoC + Freezed state management
- Feature-oriented structure (`features/{auth,household,programs}`)
- shipit_ui for all UI components
- Serverpod generated client for API communication

### Backend (apps/server)
- Serverpod with PostgreSQL
- Real email authentication: registration with verification code (dev console), login, JWT access + refresh tokens via Serverpod Auth
- Protected endpoints (household, programs) require a valid JWT, enforced server-side with `requireLogin`
- Generated client package in `packages/app_client`

### Client ↔ Server (generated contract)
- `packages/app_client` holds the Serverpod-generated client + protocol models
- App repositories call `api.Client` (from `app_client`); protocol models are mapped to feature domain models via dedicated converters
- Serverpod generated contracts are authoritative for client/server communication

### State Management
- Feature-scoped BLoCs (AuthenticationBloc, HouseholdBloc, ProgramsBloc)
- Immutable Freezed events/states
- Repository pattern for data access

## Design Authority

- Approved Penpot designs → shipit_ui → product UI
- No approved design = `DESIGN_PENDING` marker
- Upstream UI gaps reported as `UPSTREAM_UI_GAP`

## Current DESIGN_PENDING Areas

- Program detail screen
- Program creation flow
- Household settings screen
- Member invitation flow
- Password recovery / forgot-password

## Testing

QA is orchestrated through Melos scripts (unit, server, Flutter, integration) in
`melos run test` / `melos run qa`. Coverage includes:
- **Server** — DB-backed integration tests for the auth flow (register → verify
  → login), protected-endpoint enforcement, and JWT refresh (`apps/server/test/integration/`)
- **app_client** — generated protocol serialization round-trips
- **app** — repository converters, feature BLoCs, `Result`/`AppFailure` core,
  auth UI journey widget tests (redirect guard + safe failure dialog)
- **Golden baselines** — `test/goldens/` with a policy-enforced registry
  (see `docs/qa/strategy.md`); the login baselines are `APPROVED` against
  `shipit_ui@18d1a5d6` (re-approved 2026-09-10), the rest are `DESIGN_PENDING`
- **Accessibility semantics** — `test/accessibility/`
- **Integration / E2E** — real-server journey in `apps/app/integration_test/`;
  requires a live server and a device (not executed in the default `melos run test`)

> `melos run qa` runs analyze + tests. The integration suite and Patrol require
> a running server and device; they are opt-in (see `product.yaml` and
> `docs/qa/strategy.md` for gating).

## Known Limitations

- **Web sessions are in-memory only** — page reload silently discards JWT tokens; the user appears logged out. See `docs/architecture/frontend.md` (Session Persistence).
- Verification codes are logged to the server console in development (no email provider configured); `config/` email SMTP is a DEV_PENDING integration
- No real-time features
- No offline support
- Patrol E2E skeleton only (`integration_test_patrol/`), not yet in the standard QA pipeline

## Documentation

- `docs/architecture/overview.md` — System overview
- `docs/architecture/frontend.md` — Flutter architecture
- `docs/architecture/backend.md` — Serverpod architecture
- `docs/architecture/state-management.md` — BLoC + Freezed patterns
- `docs/architecture/monorepo.md` — Melos workspace structure
- `docs/architecture/flavors.md` — Environments and native flavor wiring
- `docs/architecture/flutter-toolchain.md` — FVM + Melos integration
- `docs/design/design-authority.md` — Design governance
- `docs/design/loading-states.md` — Loading/mutation feedback guidance
- `docs/design/upstream-ui-gaps.md` — Reported shipit_ui gaps
- `docs/qa/strategy.md` — QA strategy and coverage
- `docs/qa/pending-actions.md` — Open/informational action items

## License

Proprietary — ShipIt internal reference implementation.