# QA Strategy

This document reflects the ACTUAL test surface of the ShipIt Golden App. It is
kept in sync with `product.yaml` (the QA manifest) and `melos.yaml` scripts.
Status fields in `product.yaml` are the source of truth; some suites (Patrol)
are declared but not yet in the standard pipeline.

## Test Pyramid

```
         ┌─────────────┐
         │   E2E       │  ← Patrol skeleton (integration_test_patrol/) — NOT in pipeline
        ┌┴─────────────┴┐
        │  Integration  │  ← apps/app/integration_test (real server, opt-in) + server integration
       ┌┴───────────────┴┐
       │   Golden        │  ← test/goldens (DESIGN_PENDING candidate baselines)
      ┌┴─────────────────┴┐
      │    Widget         │  ← auth UI journey widget tests (redirect + failure dialog)
     ┌┴───────────────────┴┐
     │      Unit           │  ← BLoCs, converters, Result/AppFailure (most)
     └─────────────────────┘
```

## What Actually Exists

### apps/app/test/

```
test/
├── core/
│   └── result_test.dart
├── features/
│   ├── authentication/
│   │   ├── bloc/authentication_bloc_test.dart
│   │   └── presentation/authentication_flow_widget_test.dart
│   ├── household/
│   │   ├── bloc/household_bloc_test.dart
│   │   └── data/household_converters_test.dart
│   └── programs/
│       ├── bloc/programs_bloc_test.dart
│       └── data/program_converters_test.dart
├── goldens/
│   ├── golden_policy_test.dart     # registry conformance + candidate baselines
│   └── goldens_registry.md         # baseline list + DESIGN_PENDING/APPROVED status
└── accessibility/
    └── accessibility_semantics_test.dart
```

### apps/app/integration_test/ (real-server journey, opt-in)

`app_journey_test.dart` verifies the redirect guard and server-backed safe
failure dialog. Requires `docker compose up` + `melos run dev:server` and a
device. NOT executed in `melos run test` (see gating).

### apps/app/integration_test_patrol/ (skeleton only)

`smoke_test.dart` documents the future Patrol structure. `product.yaml` sets
`qa.patrol: false`; running Patrol requires Patrol CLI + a device and is a
documented pending integration.

### apps/server/test/

```
test/
├── dart_test.yaml                       # registers the integration tag
├── protocol_test.dart
└── integration/
    ├── test_tools/serverpod_test_tools.dart  # generated DB-backed wrappers
    └── auth_flow_test.dart              # registration/login/protection/JWT
```

## Running Tests (`melos run *`, from repository root)

| Command | Scope | Notes |
|---------|-------|-------|
| `melos run analyze` | all | `fvm dart analyze .` |
| `melos run test:unit` | app_client | generated protocol round-trips |
| `melos run test:server` | apps/server | DB-backed integration, tag `integration` |
| `melos run test:flutter` | apps/app | unit + widget + golden + accessibility |
| `melos run test` | unit+server+flutter | default non-integration suite |
| `melos run test:integration` | apps/app integration_test | requires live server + device |
| `melos run qa` | analyze + test | integration/Patrol are opt-in |

`generate:check` (= `melos run generate && git diff --exit-code`) guards against
silent regeneration of committed generated/migration baselines. NOTE: with a
repo that has zero commits (all files untracked), `git diff` cannot detect
drift until a baseline exists in a commit — the guard becomes effective once
the initial baseline is committed.

## Unit Tests

Feature BLoCs are tested with `bloc_test` + `mocktail` (mock repositories).
Converters map generated protocol models ↔ domain models, and `Result`/
`AppFailure` core semantics are covered. Repositories are thin wrappers over the
shared Serverpod client; their network interactions are validated by the server
integration tests and the real live failure-injection checks.

## Widget Tests

`authentication_flow_widget_test.dart` covers the real UI:

- unauthenticated user on a protected route is redirected to `/login`
- failed login surfaces a safe, human-readable `AppDialog` (never raw exception
  text — semantic error handling via `ErrorTranslator` + `AppFailure.userMessage`)
- successful login navigates away from `/login`

## Golden Policy

See `apps/app/test/goldens/goldens_registry.md`. Baselines are
`DESIGN_PENDING` candidate baselines (currently `login_sign_in.png`,
`login_register.png`). `golden_policy_test.dart` enforces that every listed
baseline exists and remains `DESIGN_PENDING` — no baseline may be silently
promoted to `APPROVED` or silently regenerated.

Regenerating a baseline requires design/human approval:

1. Restore the baseline (`git checkout -- <file>` or re-copy from the PR).
2. Update `goldens_registry.md` describing the change.
3. Note the `DESIGN_PENDING` → `APPROVED` transition against an approved Penpot
   revision (or keep `DESIGN_PENDING`).

> These PNG baselines cannot be reviewed by an automated agent (image input is
> not available), so they remain `DESIGN_PENDING` pending design review.

## Accessibility

`accessibility_semantics_test.dart` asserts machine-checkable semantics:
labeled email/password fields and a sign-in `AppButton` at/above the 40dp
minimum touch target. These complement (not replace) manual screen-reader and
keyboard review.

## Integration Testing (real server)

### Server (DB-backed, `melos run test:server`)

`auth_flow_test.dart` exercises the full flow against PostgreSQL
(`shipit_golden_test`) via the generated `serverpod_test_tools.dart` harness
(with `RollbackDatabase.disabled` for the email IDP):

- register → verify → login issues tokens
- `hasAccount` is false for unauthenticated sessions (no account leakage)
- wrong password → `EmailAccountLoginException` (typed 400)
- `household`/`programs` reject unauthenticated calls →
  `ServerpodUnauthenticatedException` (`requireLogin`)

### App (real server, opt-in)

`apps/app/integration_test/app_journey_test.dart` verifies the redirect guard
and the server-backed safe failure dialog. It requires a live server
(`docker compose up` + `melos run dev:server`) and a device; it is documented
but not run in the default suite because no headless device is available in
this environment.

## Live Failure-Injection Checks (manual reference)

With the dev server running, the following have been validated by direct HTTP
and are the canonical references for error translation:

| Probe | Expected |
|-------|----------|
| wrong credentials → `/auth/login` | HTTP 400, `EmailAccountLoginException(reason: invalidCredentials)` |
| unauth GET `/household/getCurrent` | HTTP 401 (`requireLogin`) |
| garbage Bearer token | HTTP 401 |
| valid access JWT on protected endpoint | HTTP 200 |
| valid refresh token → `/jwtTokens/refreshAccessToken` | new `AuthSuccess` |
| garbage refresh token | typed `RefreshTokenMalformedException` |

These map to the app's `ErrorTranslator` (e.g. unauthorized → `session_expired`).

## Patrol (Skeleton)

`apps/app/integration_test_patrol/smoke_test.dart` documents the intended E2E
structure. It is disabled in the standard pipeline (`product.yaml`
`qa.patrol: false`) pending Patrol CLI + device/CI integration.

## CI Pipeline

No CI workflow is committed yet. The recommended first minimal workflow runs
`melos run analyze`, `melos run test`, and `melos run generate:check` on a
Ubuntu runner with a PostgreSQL service for `test:server`. Integration and
Patrol suites are opt-in and device-gated.

## Failure Classification

Per AEF QA Governance, every failure is classified exactly once:
- `IMPLEMENTATION_DEFECT` — code bug
- `DESIGN_DEFECT` — design does not match requirements
- `REQUIREMENT_GAP` — missing/unclear requirement
- `ENVIRONMENT_DEFECT` — CI/environment issue
