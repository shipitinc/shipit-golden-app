# AGENTS.md — ShipIt Golden App

This repository is the **canonical reference implementation** proving the standard ShipIt
product architecture. It is NOT a production product.

## Authority Order

**Engineering Governance:**
Agentic Engineering Framework (AEF) → Golden App AGENTS.md → feature/task instructions

**Visual Implementation:**
Approved Penpot design revision → shipit_ui → Golden App product UI

**Application/Server Contracts:**
Serverpod model/endpoint definitions → Serverpod generated client contracts → Flutter application usage

**State Management:**
Feature/business requirements → immutable BLoC contract → Flutter presentation

**Flutter Toolchain:**
Repository-pinned FVM Flutter version → Melos commands → local/CI/worker Flutter execution

Lower-authority artifacts must not silently contradict higher-authority sources.

## Repository Structure

```
/ (repository root)
├── .fvm/                    # FVM configuration (not committed)
├── apps/
│   ├── app/                 # End-user Flutter application
│   └── server/              # Serverpod backend
├── packages/
│   └── app_client/          # Serverpod generated client package
├── infrastructure/          # Docker Compose, local infrastructure
├── docs/
│   ├── architecture/
│   ├── design/
│   └── qa/
├── scripts/
├── melos.yaml               # Melos workspace configuration
├── pubspec.yaml             # Workspace pubspec
├── product.yaml             # Product manifest
├── .fvmrc                   # Pinned Flutter version
├── AGENTS.md                # This file
├── README.md
└── compose.yaml             # Docker Compose for local infrastructure
```

## Invariants

- **AEF is authoritative governance** — this AGENTS.md must not contradict AEF
- **Runnable applications belong under `/apps`** — `apps/app` (Flutter), `apps/server` (Serverpod)
- **Reusable product packages belong under `/packages`** — `packages/app_client` for generated client
- **Common commands execute through Melos from repository root** — never `cd` into subdirectories for routine operations
- **Flutter SDK version is pinned by FVM** — `.fvmrc` contains the exact version (3.44.7)
- **Agents must not use arbitrary/global Flutter SDK versions** — all Flutter/Dart commands via `fvm flutter` / `fvm dart`
- **Flutter upgrades are explicit repository changes** — update `.fvmrc`, run migration workflow, commit
- **Flutter product UI uses shipit_ui** — import from `package:shipit_ui/shipit_ui.dart`
- **Substantial UI changes require design authority** — no inventing consequential UX
- **Approved golden baselines cannot be silently regenerated** — changed goldens require design/human approval per AEF
- **BLoC + Freezed is the standard feature/application state-management pattern**
- **Application state is immutable** — no mutable collections exposed from state objects
- **Business logic does not belong in widgets** — widgets render state, dispatch events; BLoCs coordinate transitions
- **Serverpod generated contracts are authoritative for client/server communication**
- **Package boundaries must not be bypassed for convenience** — no direct dependency on implementation libraries hidden behind shipit_ui
- **Upstream shipit_ui gaps should be reported rather than reimplemented inconsistently** — document as UPSTREAM_UI_GAP
- **Normal implementation agents do not gain production deployment authority**

## Commands (run from repository root)

```bash
# Setup
fvm install                          # Install pinned Flutter SDK
melos bootstrap                      # Install all dependencies

# Development
melos run dev                        # Start server + Flutter web
melos run dev:server                 # Start Serverpod only
melos run dev:app                    # Start Flutter web only

# Code Generation
melos run generate                   # All generation (Serverpod, Freezed, JSON)
melos run generate:server            # Serverpod generate only
melos run generate:client            # Client package generation only
melos run generate:freezed           # Freezed/JSON generation only

# Quality
melos run format                     # Format all code
melos run analyze                    # Analyze all code
melos run test                       # Run all tests
melos run test:unit                  # Dart unit tests
melos run test:flutter               # Flutter tests
melos run test:server                # Serverpod tests
melos run qa                         # Full QA pipeline (analyze + test + integration)
melos run test:integration           # Flutter integration tests

# Build
melos run build:web                  # Flutter web release build
melos run build:android              # Android app bundle
melos run build:ios                  # iOS release build (macOS only)
```

## Feature Organization (apps/app/lib)

```
lib/
├── app/
│   ├── app.dart
│   ├── routing/
│   └── bootstrap/
├── core/
│   ├── errors/
│   ├── networking/
│   └── shared/
└── features/
    ├── authentication/
    │   ├── bloc/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── household/
    │   ├── bloc/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── programs/
        ├── bloc/
        ├── data/
        ├── domain/
        └── presentation/
```

## Dependency Rules

- `apps/app` may depend on: `shipit_ui`, `packages/app_client`, approved Dart/Flutter packages
- `apps/server` must NOT depend on `apps/app`
- Reusable packages must not depend on runnable applications
- Avoid circular dependencies
- UI/presentation code must not contain server/database implementation logic
- Business logic must not live in shipit_ui
- shipit_ui must remain product-agnostic

## Upstream References

- AEF revision inspected: `main` branch at https://github.com/shipitinc/agentic-engineering-framework.git
- shipit_ui revision consumed: `main` branch at https://github.com/shipitinc/shipit-ui.git (version 0.1.0)
- FVM version: 4.1.2
- Flutter SDK pinned: 3.44.7 (stable, Dart 3.12.2)
- Serverpod version: 3.4.13
- Melos version: 8.6.0