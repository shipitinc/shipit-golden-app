# Monorepo Architecture

## Melos Workspace

The repository uses **Melos** for monorepo management.

## Package Layout

```
/
├── apps/
│   ├── app/                 # Flutter application (runnable)
│   └── server/              # Serverpod backend (runnable)
├── packages/
│   └── app_client/          # Serverpod generated client (library)
└── pubspec.yaml             # Workspace root pubspec + melos: scripts (Melos 8)
```

## Package Types

### Runnable Applications (`apps/`)
- `apps/app` — Flutter app (web, Android, and iOS targets scaffolded, each under the standard `development`/`qa`/`production` flavors)
- `apps/server` — Serverpod server executable

### Libraries (`packages/`)
- `packages/app_client` — Generated Serverpod client
- Shared Dart/Flutter packages (if needed)

## Dependency Rules

```
apps/app
  ├── shipit_ui (external)
  ├── app_client (internal)
  └── approved packages

apps/server
  ├── serverpod packages
  ├── postgres driver
  └── NO apps/app

packages/app_client
  ├── serverpod_client
  └── NO apps/*
```

## Melos Commands

### Root-Level Operations
All commands run from repository root:

```bash
# Setup
melos bootstrap          # Install deps for all packages

# Development
melos run dev            # Start server + app
melos run dev:server     # Server only
melos run dev:app        # App only

# Generation
melos run generate       # All generation
melos run generate:server
melos run generate:client
melos run generate:freezed

# Quality
melos run format         # dart format all
melos run analyze        # dart analyze all
melos run test           # All tests
melos run qa             # Full pipeline

# Build
melos run build:web
```

## Version Management

### Workspace Versioning
- All packages versioned together (0.1.0)
- Single `pubspec.yaml` at root for workspace config
- Individual `pubspec.yaml` per package

### Dependency Overrides
```yaml
# Workspace package globs (root pubspec.yaml `workspace:` section)
packages:
  - apps/*
  - packages/*

# Root pubspec.yaml dev_dependencies:
dev_dependencies:
  melos: ^8.6.0
```

## Code Generation Flow

```
1. Serverpod YAML + endpoint annotations (apps/server/lib/)
         │
         ▼
2. melos run generate:server     (cd apps/server && serverpod generate)
         │
         ├── Generates Dart models/endpoints in apps/server/lib/src/generated/  (committed)
         └── Regenerates the client in packages/app_client/lib/src/protocol/    (committed)
                    │
                    ▼
3. melos run generate:freezed    (Freezed/JSON build_runner in apps/app)
         │
         ▼
4. All generated code ready for use
```

Generated output is **committed by design** so `analyze`, `test`, and fresh
checkouts work without a prior generate step; see root `.gitignore` and
`apps/server/.gitignore`. `melos run generate:check` regenerates and fails if
committed baseline drift is detected (`generate && git diff --exit-code`).

## FVM Integration

### Flutter Version Pinning
- `.fvmrc` at root: `3.44.7`
- All Flutter commands via `fvm flutter` or `fvm dart`
- Melos scripts use FVM-managed SDK

### Melos Script Integration (`pubspec.yaml` `melos:` section)
```yaml
scripts:
  analyze: melos exec -- dart analyze
  test: melos exec -- flutter test
  generate:freezed: melos exec --scope=app -- dart run build_runner build
```

The `melos exec` command runs in each package directory with the FVM Flutter SDK available.

## CI/CD Integration

### GitHub Actions Example
```yaml
- name: Install FVM
  run: dart pub global activate fvm

- name: Install Flutter
  run: fvm install

- name: Bootstrap
  run: melos bootstrap

- name: Generate
  run: melos run generate

- name: QA
  run: melos run qa
```

## Adding New Packages

1. Create under `packages/` or `apps/`
2. Add `pubspec.yaml`
3. Run `melos bootstrap`
4. Update the `workspace:` globs or `melos:` scripts in the root `pubspec.yaml` if new command scope needed

## Path Ownership

Per AEF governance:
- Each package has clear ownership
- No circular dependencies
- Implementation agents declare `OWNED_PATHS`