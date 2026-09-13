# QA Contract — c0b70155-b400-424e-b52b-00b09254c082

<!--
  TEMPLATE: QA Contract
  Created by QA Architect per QA_GOVERNANCE.md
  Required BEFORE implementation completion (parallel with Design Contract).
  Status lifecycle: DRAFT → UNDER_REVIEW → APPROVED → FROZEN → SUPERSEDED
-->

## Provenance

| Field | Value |
|-------|-------|
| Feature | FEAT-PROGRAM-CREATE-001 (Program Creation) |
| Branch | `main` |
| Base SHA | `488ceff` (`488ceffd23b864cdbe2e3d93605badd5c5c206f6`) |
| Head SHA | `488ceff` (`488ceffd23b864cdbe2e3d93605badd5c5c206f6`) |
| Design Contract freeze commit | `488ceff` "docs(design): freeze FEAT-PROGRAM-CREATE-001 design contract (Gate D4/D5)" |

This QA Contract is authored **against the frozen Design Contract
`8D9E1F3C-77CC-45C1-9F2B-47987EC9B8BD`** (approved design revision
`77ccf5c1-9f2b-4798-87ec-c9b8bd7fb2e3`, risk level 2). Implementation has not
yet started for this feature; this contract is produced in parallel with the
design lane per AEF and is FROZEN as of the Gate Q1/Q2 pass the README above.
Frozen on 2026-09-13T02:34:00Z by the engineering-manager (Gate Q2).

## Metadata

| Field | Value |
|-------|-------|
| `contract_id` | c0b70155-b400-424e-b52b-00b09254c082 |
| `design_contract_ref` | 8D9E1F3C-77CC-45C1-9F2B-47987EC9B8BD |
| `version` | 1.0.1 (semver) |
| `status` | FROZEN |
| `created_by` | qa-architect-feat-program-create-001 (QA Architect) |
| `created_at` | 2026-09-13T02:17:14Z (ISO8601) |
| `reviewed_by` | independent-engineering-reviewer (Gate Q1) |
| `reviewed_at` | 2026-09-13T02:32:00Z (ISO8601) |
| `approved_by` | engineering-manager (Gate Q2 freeze; no human approval required by QA_GOVERNANCE for this risk level — reviewer-approved at Gate Q1) |
| `approved_at` | 2026-09-13T02:34:00Z (ISO8601) |

## Reference Documents

- **Design authority:** `docs/design/contracts/FEAT-PROGRAM-CREATE-001-design-contract.md`
  (contract_id `8D9E1F3C-77CC-45C1-9F2B-47987EC9B8BD`, frozen 2026-09-13T00:28:00Z, head_sha `f2c0760`).
- **Full design detail:** `docs/design/revisions/FEAT-PROGRAM-CREATE-001/design-revision-001.md`
  (revision_id `77ccf5c1-9f2b-4798-87ec-c9b8bd7fb2e3`) + `design-revision-001-metadata.yaml`.
- **Requirements:** `docs/features/FEAT-PROGRAM-CREATE-001-requirements.md` (PC-001..PC-010, PD-1/2/3, P2 gaps #1/#2).
- **QA policy:** `docs/qa/strategy.md`, `apps/app/test/goldens/goldens_registry.md`, AEF `QA_GOVERNANCE.md`.
- **Execution grounding:** `melos:` scripts in the workspace root `pubspec.yaml` (Melos 8); `product.yaml`.

## Acceptance Criteria

Each AC-QA traces 1:1 to a requirements-doc acceptance criterion (PC-001..PC-010)
or to Design Brief AC-11 (P2 gap #1 closure). The "Maturity Category" places the
criterion in the QA pyramid (unit/widget, integration, contract, e2e, visual,
human). Test methods follow `QA_GOVERNANCE.md`.

### AC-QA-001 (PC-001): Entry points — app-bar action and empty-state CTA, no FAB
- **Description**: An authenticated user opens the creation flow from the
  Programs surface through exactly two entry points and no other affordance:
  (1) primary — an `AppIconButton(icon: Icons.add, tooltip: 'Create program',
  semanticLabel: Key('programs_create_action'))` as the **first** action in the
  `ProgramsScreen` app-bar actions (order: Create, Refresh, Sign out); (2)
  secondary — in `ProgramsLoaded(programs: [])`, the `AppEmptyState` renders
  `actionLabel: 'Create program'`, `onAction`, `semanticLabel:
  Key('programs_empty_create')`, and message `'Programs you create will appear
  here.'`. A `FloatingActionButton` is NOT rendered on the Programs surface.
  Both entry points push `/programs/create` via the shared `_openCreate`
  helper.
- **Traceability**: Requirements: PC-001. Design: Design Contract "Bound
  Design — Entry points (PC-001)"; revision §D-1, §4.1.
- **Test Method**: AUTOMATED (widget)
- **Maturity Category**: unit/widget
- **Pass Criteria**: Widget test on ProgramsScreen asserts the app-bar create
  action (key `programs_create_action`) is present and precedes the Refresh and
  Sign-out actions; the empty-state branch renders an `AppEmptyState` with
  `actionLabel 'Create program'`, `semanticLabel Key('programs_empty_create')`,
  and message `'Programs you create will appear here.'`; `find.byType(
  FloatingActionButton)` finds nothing on the surface; tapping each entry point
  pushes the route named `program-create`.

### AC-QA-002 (PC-002): Form anatomy and validation — required fields, strict `endDate > startDate`, status NOT a form field
- **Description**: The create form is the exact shipit_ui composition
  (`Scaffold(AppBar('Create Program'))` → Center → SingleChildScrollView →
  `ConstrainedBox(context.layout.maxWidth.form)` → `AppCard` → `Form`). Fields:
  name (required, `'Program name is required.'` on blank), description
  (optional, `maxLines: 3`, blank maps to `''`), start date (required,
  `'Select a start date.'` on null), end date (required, single-mode,
  per-field errors: `'Select an end date.'` on null, `'Select a start date
  first.'` when start is null, and `'End date must be after the start date.'`
  when `!endDate.isAfter(startDate)` — strict, equal dates fail). Errors are
  attributed to the failing field only. **`status` is NOT a form field** (no
  input control; server auto-derives upcoming/active/completed from the date
  range vs now per PD-2/D-4).
- **Traceability**: Requirements: PC-002, PD-2. Design: "Bound Design — Form
  anatomy (PC-002, PD-2)"; design contract "Status is NOT a form field";
  revision §D-3 (per-field validator spec), §D-4 (auto-derivation).
- **Test Method**: AUTOMATED (widget + server integration)
- **Maturity Category**: unit/widget + integration
- **Pass Criteria**: Widget test: submitting an empty form shows `'Program name
  is required.'` under the name field only; with both dates null but name set,
  `'Select a start date.'` renders under start and `'Select an end date.'`
  under end; with `endDate == startDate` or `endDate < startDate`,
  `'End date must be after the start date.'` renders under end only; with end
  set and start null, `'Select a start date first.'` renders under end only;
  description blank passes and the dispatched value is `''`; no status control
  exists in the form (`find.byType(AppSelect)` and any status chip/key are
  absent). Server integration: `createProgram` derives and persists a
  `ProgramStatus` exactly from the date range vs now — dates fully in the past
  → `completed`; start ≤ now ≤ end → `active`; start after now → `upcoming`
  (3-row table, date precision per D-4).

### AC-QA-003 (PC-003): Success round-trip — pop(true) → ProgramsRefreshRequested → list shows the program
- **Description**: A valid submit persists via a server round-trip. On success
  the create screen pops `true`; the lead-in helper dispatches
  `ProgramsRefreshRequested`; the Programs list refreshes from the server and
  the new program's card appears. Cancel (back arrow) pops without a result —
  no refresh.
- **Traceability**: Requirements: PC-003. Design: "Bound Design — Success
  (PC-003)"; revision §D-2, §D-7, §4.1.
- **Test Method**: AUTOMATED (server integration + widget)
- **Maturity Category**: integration + unit/widget
- **Pass Criteria**: Server integration (DB-backed): `createProgram` with valid
  input returns a Program with a non-null id, and a subsequent `getAll`
  readback contains the created name. Widget test: on `pop(true)` the screen
  dispatches `ProgramsRefreshRequested` and the list renders a card for the
  created name; a push result of `null` (cancel) dispatches nothing.

### AC-QA-004 (PC-004): Server rejects invalid input — plain 400 → AppFailure.validation, no new protocol model
- **Description**: `createProgram` validates name non-blank, both dates present,
  and `endDate.isAfter(startDate)` strictly; on violation it throws the
  Serverpod framework class `InvalidParametersException(message)`, which
  surfaces as a plain HTTP 400. The client rethrows that as
  `ServerpodClientBadRequest`, which the **existing** `error_translator.dart`
  case maps to `AppFailure.validation` with the user-safe message. Zero new
  protocol models, zero exception classes for create, and **no
  `error_translator.dart` change**. `ProgramNotFoundException` is never used for
  validation (wrong typed-lookup semantics).
- **Traceability**: Requirements: PC-004. Design: "Bound Design — Server
  validation/errors (PC-004/PC-005)"; revision §5-2, §5-3, `error_translator.dart`.
- **Test Method**: AUTOMATED (server integration + unit + contract)
- **Maturity Category**: integration + unit + contract
- **Pass Criteria**: Server integration: each invalid payload — blank/whitespace
  name, missing startDate, missing endDate, `endDate == startDate`,
  `endDate < startDate` — throws `throwsA(isA<InvalidParametersException>())`
  and the HTTP surface is observed as plain 400 (no typed protocol exception).
  Unit: `mapAppFailure(ServerpodClientBadRequest())` returns an
  `AppFailure.validation` with message `'The request was not valid. Please
  check your input.'`. Contract: no new protocol model class exists for the
  create surface and `error_translator.dart` is unchanged (drift gate clean).

### AC-QA-005 (PC-005): Creator identity — `createdBy` equals the caller
- **Description**: After a successful create, the persisted Program's
  `createdBy` field equals the authenticated caller identity
  (`session.authenticated!.userIdentifier`), the value the endpoint writes.
  The field is an additive `createdBy: String` on `program.yaml` (SAFE
  migration) carried through server + regenerated client.
- **Traceability**: Requirements: PC-005, PD-1 (decision `0C250F09-…`). Design:
  "Bound Design — Server validation/errors (PC-004/PC-005)"; revision §5-1, §5-2.
- **Test Method**: AUTOMATED (server integration)
- **Maturity Category**: integration
- **Pass Criteria**: Server integration (DB-backed, session authenticated as
  `creator-1`): after `createProgram`, the read-back Program row has
  `createdBy == 'creator-1'`; a second caller (`creator-2`) produces a program
  with `createdBy == 'creator-2'`.

### AC-QA-006 (PC-006): Settled failure — form kept + dismissible inline error, NO Retry
- **Description**: On a settled submit failure the BLoC settles back onto a
  kept-form state carrying `submitError`; the form content is never cleared or
  blanked (BLoC never holds field text, so content survives every state by
  construction). An `AppInlineAlert.error` renders above the fields
  (`title: 'Could not create program'`, `message: submitError.userMessage`),
  is dismissible via `onDismiss` → `ProgramCreateErrorDismissed`, and carries
  **no Retry/actionLabel** (mutation failures never offer Retry).
- **Traceability**: Requirements: PC-006. Design: "Bound Design — Loading/
  failure (PC-006/PC-008)"; revision §D-3 step 1, §D-5, §4.2.
- **Test Method**: AUTOMATED (bloc + widget)
- **Maturity Category**: unit/widget
- **Pass Criteria**: Bloc test: `ProgramCreateSubmitted` failure emits the
  settled failure state with `submitError` (form retained), bypassing loading;
  `ProgramCreateErrorDismissed` clears it back to the idle form state; field
  text is never stored on the bloc. Widget test: after a failed submit the
  entered name/description/dates remain visible in the fields; the inline
  alert with title `'Could not create program'` is present with a dismiss
  control (component-static `inline_alert_dismiss`) and no `'Retry'`
  text/actionLabel; dismissing removes the alert and leaves the form editable.

### AC-QA-007 (PC-007): Route registration and auth guard
- **Description**: `GoRoute(path: '/programs/create', name: 'program-create')`
  is registered **inside** the programs `StatefulShellBranch`, declared before
  `/programs/:id`. The existing authenticated-shell redirect guard
  (unauthenticated → `/login`) covers the route with no change, and the
  endpoint keeps `requireLogin => true`.
- **Traceability**: Requirements: PC-007. Design: "Bound Design — Route (PC-001/
  PC-007)"; revision §D-2; `app_router.dart` redirect guard; `ProgramsEndpoint.requireLogin`.
- **Test Method**: AUTOMATED (widget + server integration)
- **Maturity Category**: unit/widget + integration
- **Pass Criteria**: Router test: a route named `program-create` with path
  `/programs/create` exists, sits in the programs shell branch, and is declared
  before the `:id` route. Widget: navigating to `/programs/create` while
  unauthenticated lands on `/login`. Server integration:
  `endpoints.programs.createProgram(...)` without a session throws
  `ServerpodUnauthenticatedException` (endpoint `requireLogin` true).

### AC-QA-008 (PC-008): Loading — button loading only on submit; skeleton on refresh; no content spinners
- **Description**: Submit in flight swaps the submit `AppButton` to
  `AppButtonState.loading` (disables it, in-button spinner, announces
  `'Create Program, loading'`); fields stay editable. List refresh on return
  uses the existing `AppSkeleton.card` loading branch. No content spinners, no
  content blanking anywhere in the flow.
- **Traceability**: Requirements: PC-008. Design: "Bound Design — Loading/
  failure (PC-006/PC-008)"; revision §D-3 (submit), §D-5 (list refresh).
- **Test Method**: COMBINED (widget AUTOMATED + VISUAL)
- **Maturity Category**: unit/widget + visual
- **Pass Criteria**: Widget test: while submitting, the submit button reports
  `AppButtonState.loading` with semantics `'Create Program, loading'` and is
  disabled; no `CircularProgressIndicator` exists outside the button; a
  Programs refresh renders `AppSkeleton.card` and no spinner. Visual: the new
  `program_create.png` and `programs_empty.png` baselines render the idle
  create form and empty state per the frozen design composition (2 registration).

### AC-QA-009 (PC-009): Create-flow golden registrations (DESIGN_PENDING → APPROVED)
- **Description**: New goldens for the create-flow surfaces —
  `program_create.png` (ProgramCreateScreen, initial empty form, no error) and
  `programs_empty.png` (ProgramsScreen empty state with message + `Create
  program` CTA + app-bar actions incl. create) — are registered with status
  **DESIGN_PENDING** at implementation time, then promoted to **APPROVED**
  after design/human approval. macOS regeneration is prohibited. Promotion
  mechanics: `goldens-update.yml` performs Linux-CI PNG regeneration/re-
  affirmation ONLY (it never flips the registry STATUS cell); the
  DESIGN_PENDING → APPROVED status transition is recorded by the **QA
  Architect** in the same promotion commit (registry status cell + design
  revision reference + approval authority) once the 0-pixel-diff Linux CI
  result and design/human sign-off exist.
- **Traceability**: Requirements: PC-009. Design: "Bound Design — Goldens
  (PC-009, AC-11)"; revision §D-8 rows 1-2, §5-6.
- **Test Method**: COMBINED (VISUAL + AUTOMATED registry conformance)
- **Maturity Category**: visual + contract
- **Pass Criteria**: Both PNGs exist under `apps/app/test/goldens/` with
  `goldens_registry.md` rows carrying status `DESIGN_PENDING` and a design
  revision reference; **`golden_registry_test.dart` (registry conformance —
  untagged, runs on any host as part of `melos run test:flutter`) passes**;
  the ORDERED promotion sequence is met: (1) implementing SHA passes
  `melos run test:golden` on the Linux CI host with **0 pixel diffs** against
  the DESIGN_PENDING PNGs, (2) `goldens-update.yml` regenerates/re-affirms the
  PNGs on Linux CI under an approved `design_revision` + `reviewer` (it appends
  the re-approval marker but does NOT change STATUS), (3) after design/human
  approval the **QA Architect records** the DESIGN_PENDING → APPROVED status
  transition (registry STATUS cell + design-revision reference + approval
  authority, e.g. the Human Decision id) in the SAME promotion commit.
  `golden_policy_test.dart` / `melos run test:golden` remain reserved for the
  Linux-CI pixel gate against the resulting APPROVED baselines. **This contract
  never declares these baselines APPROVED.**

### AC-QA-010 (PC-010): Auto-join concurrency — one transaction, exactly one household and one membership per program
- **Description**: `createProgram` performs create-Program + `getOrCreateFor`
  + insert-ProgramMember in **ONE caller-owned database transaction**, with
  `getOrCreateFor` gaining `{Transaction? transaction}` (mirroring
  `findByOwner`) and forwarding it to the inner queries/inserts so a nested
  call cannot open a second pool connection. N concurrent creates for ONE
  owner converge to exactly one household, one membership per program, and N
  programs (this is the P2 gap #2 deterministic regression — closes
  `requirements.md` P2 gaps).
- **Traceability**: Requirements: PC-010, PD-3 (decision `1231D220-…`), P2 gap
  #2. Design: "Bound Design — Auto-join (PD-3, PC-010)"; revision §D-7, §5-2;
  `household_service.dart getOrCreateFor`.
- **Test Method**: AUTOMATED (server integration — concurrency)
- **Maturity Category**: integration
- **Pass Criteria**: DB-backed `withServerpod` test (PostgreSQL via
  `melos run test:server`): fire **N = 5** concurrent `createProgram` calls for
  one authenticated owner using `Future.wait` against the generated endpoint
  harness (`apps/server/test/integration/test_tools/serverpod_test_tools.dart`).
  After quiescence: `Household.db.find(ownerId)` length == **1**;
  `Program.db.find(name in created set)` length == **N**; `ProgramMember.db`
  has **exactly one membership per program** and N memberships total, all on
  the single household; each program's `createdBy` == the owner. A failing
  member step rolls back the whole transaction (no orphan program, no partial
  household).

### AC-QA-011 (AC-11 / P2 gap #1): Program-details joined-state golden
- **Description**: `program_details_joined.png` — ProgramDetailsScreen loaded
  + **joined** state (`_MembershipCard` showing `Joined · <name>`, `JOINED`
  badge, `Cancel Membership` CTA) — is registered as a new
  **DESIGN_PENDING** baseline closing P2 gap #1, sitting beside the existing
  not-joined `program_details.png`. No redesign of the details screen; the
  joined state simply becomes reachable immediately after create (PD-3).
- **Traceability**: Requirements: P2 gaps #1 (no PC counterpart by design);
  Design: Design Contract AC-11, "Bound Design — Goldens (PC-009, AC-11)";
  revision §D-7, §D-8 row 3, §4.3.
- **Test Method**: VISUAL
- **Maturity Category**: visual
- **Pass Criteria**: PNG exists under `apps/app/test/goldens/` with a
  `goldens_registry.md` row of status `DESIGN_PENDING` (updated design
  revision ref) adjacent to the not-joined `program_details.png` row; rendered
  with the same conventions as `program_details_golden_test.dart`
  (`shipitLightTheme()`, real Inter, loaded+joined state, `pumpAndSettle`);
  registry conformance (`golden_registry_test.dart`, any host) passes; the
  **QA Architect records** the DESIGN_PENDING → APPROVED status transition
  (registry STATUS cell + design-revision reference + approval authority) in
  the promotion commit after `goldens-update.yml` Linux-CI PNG
  regeneration/re-affirmation (0 pixel diffs) and design/human approval —
  promotion is never performed by the workflow itself and never declared
  in-contract.

## Test Strategy

### Unit Tests
- **Scope**: `ProgramCreateBloc` state/event transitions (initial → submitting →
  failure(submitError) → completed; error-dismissed), `ProgramsBloc`
  refresh-after-create dispatch, `ErrorTranslator` mapping
  (`ServerpodClientBadRequest` → `AppFailure.validation`; negative cases for
  `ServerpodClientUnauthorized`/network drift), `ProgramsRepository.createProgram`
  argument marshalling (trim, description blank → `''`, date pass-through, error
  translation), and any converter change for the additive `createdBy` passthrough
  through `programFromProtocol`. BLoCs tested with mock repositories; no network.
- **Coverage Target**: 100% of new BLoC state/event transitions and new
  translator/repository branches introduced by this feature.
- **Tools**: `fvm flutter test` via `melos run test:flutter` (unit+widget,
  goldens excluded), `bloc_test`, `mocktail`, Freezed. BLoC files: `apps/app/test/features/programs/bloc/`.
- **Required**: REQUIRED

### Integration Tests
- **Scope**: Server (DB-backed, `apps/server/test/integration/`, PostgreSQL via
  `docker compose`):
  - create happy path (round-trip persistence; returned Program; `getAll`
    readback contains it);
  - validation rejections (blank name, missing start/end, `endDate <= startDate`)
    → `InvalidParametersException` → plain 400;
  - `createdBy` == caller identity per authenticated session;
  - derived `status` mapping table (past → completed, spanning now → active,
    future → upcoming);
  - auto-join atomicity — create + `getOrCreateFor` + insert-ProgramMember in
    ONE caller-owned transaction; a forced membership-step failure rolls back
    the program insert (no orphan program / partial household);
  - **PC-010 concurrency**: N = 5 concurrent creates for ONE owner via
    `Future.wait` → exactly one household, N programs, one membership per
    program (closes P2 gap #2);
  - auth: unauthenticated `createProgram` → `ServerpodUnauthenticatedException`.
- **Service Boundaries**: `ProgramsEndpoint.createProgram` →
  `Program.db` / `HouseholdService.getOrCreateFor(transaction:)` /
  `ProgramMember.db`, all inside one caller-owned `session.db.transaction`.
  The endpoint is the only seam; the app repository is validated by unit tests
  + the opt-in e2e journey.
- **Tools**: `melos run test:server` (serial `-j 1`), `serverpod_test` +
  generated `apps/server/test/integration/test_tools/serverpod_test_tools.dart`,
  `AuthenticationOverride.authenticationInfo` sessions, PostgreSQL 16
  service, `useEphemeralApiPort`.
- **Required**: REQUIRED — PC-010 concurrency is a hard gate (see Gate Criteria).

### Contract Tests
- **Scope**: Serverpod generated client/server contract for the create surface:
  `createProgram` signature parity across generated server endpoints and
  `packages/app_client` client; the additive `createdBy` field present in the
  protocol (model + generated output) with no breaking schema change (SAFE
  migration); validation failures surface as **plain** HTTP 400
  (`ServerpodClientBadRequest`) with **no new typed protocol exception** for
  create (no `ProgramNotFoundException`-style model); `.generated_manifest.json`
  re-snapshotted with the model change.
- **Consumer-Driven Contracts**: Serverpod generated client is the contract
  consumer; `ProgramsRepository.createProgram` marshals through
  `programFromProtocol`. Regression baseline: existing protocol round-trip
  suite (`apps/server/test/protocol_test.dart`) stays green.
- **Schema Validation**: No schema assertion beyond additive `createdBy`; the
  `generate:check` drift gate is the schema-change detector for this
  gitignore/`generated_manifest` repository.
- **Tools**: `melos run generate:check` (in CI evidence), `melos run generate`
  + `generate:manifest` for the legitimate model change, `melos run test:unit`
  (app_client protocol round-trips), server integration status-code telemetry.
- **Required**: REQUIRED

### End-to-End Tests
- **Critical User Flows**: Real-server journey addition to
  `apps/app/integration_test/app_journey_test.dart`: authenticated navigate
  `/programs` → tap create (app-bar or empty-state CTA) → fill and submit the
  form → return to a list containing the created program → open the card and
  observe the joined state.
- **Environments**: Local dev — PostgreSQL via `docker compose up`, Serverpod
  via `melos run dev:server`, device/web-server via `melos run dev:app`.
  NOTE `docs/qa/pending-actions.md` #2: the golden dev server in this
  environment runs on `8099` with runtime env overrides; the journey must point
  `API_BASE_URL` at the live server.
- **Tools**: `flutter integration_test`, `melos run test:integration`.
- **Required**: OPTIONAL — **NOT_IN_DEFAULT_PIPELINE**. Documented, device-
  gated, and excluded from `melos run qa` / `product.yaml` default pipeline
  (no headless device in this environment). The journey addition is specified
  here and goes onto `melos run test:integration` if/when the environment
  allows; if the environment blocks it, the gate is marked `NOT_APPLICABLE`
  and the gap flagged rather than silently skipped. Widget-level equivalents
  of every journey step are REQUIRED in the unit/widget gates, so e2e absence
  never leaves a criterion uncovered.

### Visual Tests
- **Pages/Components**: ProgramCreateScreen (idle empty form, no error);
  ProgramsScreen empty state (title + message + CTA + app-bar create action);
  ProgramDetailsScreen loaded + joined state (`JOINED` badge, Cancel
  Membership CTA). Excluded from pixel testing: anything the design contract
  keeps modal/test-free — no golden is defined for the loading or settled-
  failure variants of the create form (those are widget-asserted only).
- **Baseline References**: NEW — `program_create.png`, `programs_empty.png`,
  `program_details_joined.png` (DESIGN_PENDING at implementation; APPROVED
  never in-contract). EXISTING APPROVED (regression coverage, regenerated
  only per policy): `login_sign_in.png`, `login_register.png`,
  `program_details.png`.
- **Tolerance Thresholds**: 0 pixel diffs on the Linux CI host (platform of
  record). macOS renders text ~1% differently — a local diff is expected, is
  **not** a failure, and is never "fixed" by `--update-goldens` on a dev host.
- **Tools**: `melos run test:golden` (`--tags golden`, Linux CI — hosts
  `golden_policy_test.dart`, the APPROVED-baseline pixel comparisons only);
  `golden_registry_test.dart` (registry conformance, untagged, runs on any host
  inside `melos run test:flutter` via `--exclude-tags golden`);
  `.github/workflows/goldens-update.yml` for Linux-CI PNG
  regeneration/re-affirmation only (QA Architect records the
  DESIGN_PENDING → APPROVED status transition in the promotion commit).
- **Required**: REQUIRED (Linux CI host only; approved-baseline pixel tests are
  excluded from `melos run test:flutter` via `--exclude-tags golden`).

### Human QA
- **Exploratory Charters**: (C1) entry-points — app-bar create vs empty-state
  CTA across desktop/tablet/mobile shell widths and dark mode; (C2) full create
  journey including date-picker calendar entry and per-field error recovery;
  (C3) failure path — server unreachable / validation rejection: form kept,
  inline alert, dismiss, resubmit; (C4) post-create joined state — open the new
  program's card, confirm `JOINED` badge + Cancel Membership CTA.
- **Usability Tasks**: Complete the create journey end-to-end from both entry
  points; correct a validation mistake using only on-field errors; dismiss the
  failure alert and resubmit; cancel the flow via the back arrow.
- **Accessibility Standards**: WCAG AA — token-only contrast, interactive
  targets ≥ 44px, semantics labels + live-region error announcement
  (component-static `text_field_error`, `date_picker_error`, inline alert
  live region), initial focus on the name field, first-invalid-field focus on
  failed `Form.validate()`. Known upstream gap (documented, NOT to be re-fixed
  in-app): `AppDatePicker`'s ~20px `date_picker_clear` tap target —
  `UPSTREAM_UI_GAP`/DCR to shipit_ui. Human QA must verify the gap is reported
  and does not regress.
- **Required**: REQUIRED — WCAG AA + exploratory. Human QA initiation is a
  separate **HUMAN_DECISION gate (Q5)**; this contract establishes the scope,
  and the executor/manager trigger Q5 per `QA_GOVERNANCE.md`.

## Evidence Standards

- **Deterministic Evidence Required**: YES — automated results are authoritative
  over reviewer opinion; every gate resolves on reproducible commands
  (`melos run test:server`, `test:flutter`, `test:golden`, `generate:check`).
- **Revision Pinning Required**: YES — every QA Result and artifact is tied to
  the exact code SHA under test. For this feature the implementing SHA is the
  revision under test, and the **generated-code drift gate** is part of the
  required evidence: `melos run generate:check` must be clean (no tracked
  diff + `.generated_manifest.json` hash match) at the exact SHA, because
  generated output is gitignored and a model/endpoint change is invisible to
  a tracked-only diff.
- **Artifact Retention Policy**: test reports (JSON/JUnit), CI logs and QA
  Result YAML retained in the repository (QA Result artifacts under
  `docs/qa/results/` as created by the executor) plus GitHub Actions logs;
  golden PNGs + `goldens_registry.md` are Git-committed; baseline promotion
  markers recorded in the registry. Retention ≥ 90 days; golden history
  versioned in Git for audit and rollback comparison.

## Golden Baselines

| Baseline ID | Source Revision | Component/Page | Approval Status | Approved By | Approved At |
|---|---|---|---|---|---|
| `goldens/login_sign_in.png` | HEAD `488ceff` (existing, unchanged) | LoginScreen (sign in) | APPROVED | Human QA (tariq) via goldens-update.yml | 2026-09-12 (recorded in registry) |
| `goldens/login_register.png` | HEAD `488ceff` (existing, unchanged) | LoginScreen (register) | APPROVED | Human QA (tariq) via goldens-update.yml | 2026-09-12 (recorded in registry) |
| `goldens/program_details.png` | HEAD `488ceff` (existing, unchanged) | ProgramDetailsScreen (loaded, not joined) | APPROVED | Human QA (tariq) via goldens-update.yml | 2026-09-12 (recorded in registry) |
| `goldens/program_create.png` | HEAD `488ceff` (source of this contract) — NEW | ProgramCreateScreen (idle empty form) | DESIGN_PENDING | _promotion pending Linux CI + design/human approval_ | _pending_ |
| `goldens/programs_empty.png` | HEAD `488ceff` (source of this contract) — NEW | ProgramsScreen empty state | DESIGN_PENDING | _promotion pending Linux CI + design/human approval_ | _pending_ |
| `goldens/program_details_joined.png` | HEAD `488ceff` (source of this contract) — NEW | ProgramDetailsScreen (loaded, joined) | DESIGN_PENDING | _promotion pending Linux CI + design/human approval_ | _pending_ |

Governance per `QA_GOVERNANCE.md` §Golden Baseline Governance and the registry
policy: no existing APPROVED baseline is regenerated by this feature; the three
NEW baselines are DESIGN_PENDING candidates that preserve the implementing
rendering and are promoted to APPROVED only with design/human approval
recorded in `goldens_registry.md`. The promotion mechanics are: (1)
`goldens-update.yml` (Linux CI host) regenerates/re-affirms the PNGs under an
approved `design_revision` + `reviewer` — it appends the `[re-approved …]`
marker to the notes cell but NEVER flips the registry STATUS cell; (2) the
**QA Architect** records the DESIGN_PENDING → APPROVED status transition in
the SAME promotion commit: registry STATUS cell updated to `APPROVED`, the
design revision the baseline was approved against, and the approval authority
(directive/human decision id + reviewer). Implementation agents cannot approve
changed baselines, and the workflow alone never promotes a baseline.

## Regression Test Requirements

- **New Regressions Must Add Regression Tests**: YES — every regression
  requires a regression test referencing the originating `failure_id` before
  re-verification, per `QA_GOVERNANCE.md` Regression Policy.
- **Regression Test Traceability**: Each regression test must reference the
  original `failure_id` and is added in the same remediation that fixes its
  class (CORRECTION / DCR / REQUIREMENTS_CLARIFICATION / INFRA_REMEDIATION);
  the QA Result records `regression_test_added: true` +
  `regression_test_ref`. A regression in PC-010 (concurrency) re-runs the
  `Future.wait` integration test; a visual regression re-runs the affected
  golden comparison on Linux CI.
- This contract's required suite **already includes** the two P2-gap regressions
  that motivated the feature: the PC-010 concurrency regression (P2 gap #2)
  and the joined-state golden (P2 gap #1) — both encode pre-existing coverage
  gaps as first-class tests.

## Gate Criteria

| Gate | Pass Threshold |
|------|----------------|
| Unit/Widget | All pass — **0 failures** (`melos run test:flutter`; goldens excluded by tag). New BLoC/translator/repository/widget tests all green. |
| Integration | All pass — **0 failures** (`melos run test:server`, PostgreSQL-backed), **including the PC-010 concurrency test** (N programs, exactly one household, one membership per program). |
| Contract | `melos run generate:check` clean (no tracked diff + manifest hash match) at the tested SHA; protocol round-trips green; `ServerpodClientBadRequest` → `AppFailure.validation` confirmed; no new protocol model. |
| E2E | NOT_IN_DEFAULT_PIPELINE — opt-in/device-gated. If the live-server journey runs, it must pass; otherwise flagged, never silently asserted. |
| Visual | **0 pixel diffs** on the Linux CI host (`melos run test:golden`, `golden_policy_test.dart` pixel gate); registry conformance (`golden_registry_test.dart`) green on any host; no baseline promoted without Linux-CI regeneration/re-affirmation + design/human approval, with the DESIGN_PENDING → APPROVED status transition recorded by the QA Architect in the promotion commit. macOS diffs are informational, not failures. |
| Human | REQUIRED (WCAG AA + exploratory, Q5 gate). Findings classified exactly once and routed: `IMPLEMENTATION_DEFECT` → CORRECTION, `DESIGN_DEFECT` → DCR, `REQUIREMENT_GAP` → HUMAN_DECISION, `ENVIRONMENT_DEFECT` → INFRA_REMEDIATION. No unresolved CRITICAL/HIGH findings at verdict. |

**Overall gate entry (Gate Q6 / QA Verdict)**: all applicable gates PASS →
`READY_FOR_MERGE`; any required-gate failure with unclassified failures →
`BLOCKED`; human-initiation ambiguity → `HUMAN_DECISION_REQUIRED`.

## Constraints Enforced by This Contract

- Golden baselines are **never silently regenerated**; macOS is **never** used
  for golden regeneration (`--update-goldens` on a dev machine is not a fix).
- Approved-baseline pixel tests are **excluded** from `melos run test:flutter`
  (`--exclude-tags golden`) so a fresh macOS dev machine is never red by
  design; the Linux CI host is the platform of record.
- Generated code is **not committed**; the `generate:check` drift gate is part
  of the CI evidence for this feature's model/endpoint change, and
  `melos run generate:manifest` must be committed together with the
  `createdBy` model change.
- shipit_ui is the **only** visual source (shipit_ui components + `context.*`
  tokens only); there is no pixel-level golden for anything the design contract
  keeps modal/test-free (create-form loading/failure variants are widget
  assertions only).
- Server model change is additive (`createdBy`) → SAFE migration path; no new
  protocol models; no `error_translator.dart` change; no FAB; no Retry on the
  settled-failure alert.
- Integration suite is opt-in/device-gated per `product.yaml`/`strategy.md`;
  the server integration suite (`test:server`) is DB-backed and requires the
  `compose.yaml` PostgreSQL service.

## Governance — QA Architect ≠ Executor Separation (declared intent)

For the subsequent execution gates of this feature (Gates Q3-Q6):

- **QA Architect** (this artifact's author) defines strategy, owns this QA
  Contract, owns golden-baseline governance (DESIGN_PENDING registration and
  ANY promotion/rebaseline approval), reviews and classifies failures, but
  does **not** execute tests and does **not** write implementation code.
- **QA Executor** executes automated/visual/human QA per this contract, is
  read-only with respect to production code and golden baselines, preserves
  all evidence, and classifies each failure exactly once per the taxonomy.
- **Implementation lane** must not approve baseline changes, must not invent
  test strategy, and reports `IMPLEMENTED` only after the QA Contract is
  frozen (Gate Q2).
- Gate-flow commitments: Q1 (this contract reviewed by Manager + Independent
  Engineering Reviewer) → Q2 (Manager freeze, records provenance) → Q3/Q4
  (automated + visual execution by Executor) → Q5 (Human QA, HUMAN_DECISION
  initiation) → Q6 (QA Architect verdict + classification; Manager transitions
  lifecycle).
- Any contract ambiguity found during execution is routed through this
  governance chain — never resolved unilaterally by the executor or
  implementation lane.

## Discoveries (QA Architect record)

- **Task-prompt PC numbering vs authoritative requirement IDs.** The feature
  brief for this QA Contract used shorthand PC numbers that shuffle three
  criteria (loading, kept-form failure, and status derivation) relative to
  `FEAT-PROGRAM-CREATE-001-requirements.md` and the Design Contract
  traceability table. The QA Contract follows the **requirements doc +
  Design Contract numbering** (authoritative): PC-006 kept-form inline error,
  PC-007 auth guard, PC-008 loading, PC-009 goldens, PC-010 concurrency.
  Status auto-derivation (PD-2 / Design D-4) has **no standalone PC** and is
  therefore encoded inside AC-QA-002 (status NOT a form field) plus a REQUIRED
  integration assertion of the derived-status table. If the Manager prefers
  standalone traceability for D-4, a QA-Contract revision is the vehicle.
- **Provenance skew between commits.** The Design Contract records
  `head_sha: f2c0760` (the revision commit) while the freeze commit and this
  contract's working tree are at `488ceff`. Golden sources declared against
  HEAD `488ceff`; no functional impact.
- **Known upstream accessibility gap** (`AppDatePicker` `date_picker_clear`
  ~20px tap target) is inside design control boundaries, documented at §D-6/§9
  and §7 F4 of the revision. This contract does not create a baseline that
  encodes a 40px requirement for that affordance (widget/semantics assertions
  only), and Human QA verifies the gap is reported via UPSTREAM_UI_GAP/DCR.

## Knowledge Persisted

- QA Architect record persisted in `docs/qa/contracts/
  FEAT-PROGRAM-CREATE-001-qa-contract.md` (OWNED_PATH, DRAFT, v1.0.1).
- Gate Q1 revision 1.0.1 resolved findings F-001 (golden conformance test
  naming) and F-002 (DESIGN_PENDING → APPROVED promotion mechanics); the
  corrected golden-test map is a canonical QA reference for this feature.
- Decision to follow authoritative requirements/design AC numbering and to fold
  PD-2 status-derivation into AC-QA-002 + the integration strategy is recorded
  in Discoveries above for the next reviewer.
- P2 gap #1/#2 regressions are first-class, pre-registered requirements of this
  contract, so they cannot be dropped by later execution stages.

## Revision History

| Version | Revised at | Change |
|---------|-----------|--------|
| 1.0.0 | 2026-09-13T02:17:14Z | Initial DRAFT (Gate Q1 submission). |
| 1.0.1 | 2026-09-13T02:22:33Z | Gate Q1 CHANGES_REQUIRED resolved. **F-001 (MEDIUM):** corrected the golden-test map — registry conformance is `golden_registry_test.dart` (untagged, any host, inside `melos run test:flutter`); `golden_policy_test.dart` is the `@Tags(['golden'])` pixel-comparison gate, Linux-CI-authoritative via `melos run test:golden`. **F-002 (LOW):** corrected promotion mechanics — `goldens-update.yml` only regenerates/re-affirms PNGs on Linux CI and appends the `[re-approved …]` marker; it never flips the registry STATUS cell; the DESIGN_PENDING → APPROVED status transition is recorded by the QA Architect in the same promotion commit (STATUS cell + design-revision reference + approval authority). Updated AC-QA-009, AC-QA-011, Visual strategy tools, Golden Baselines governance, and Visual gate criteria accordingly. Traceability AC-QA-001..011 and numbering unchanged; contract_id and design_contract_ref unchanged. |
| 1.0.1 (frozen) | 2026-09-13T02:34:00Z | **Gate Q2: MANAGER FREEZE.** Gate Q1 re-review `QA_CONTRACT_APPROVED`; status transitioned DRAFT → FROZEN. The QA Contract is now the frozen QA target for implementation. Note carried in Gate Q1 re-review: the QA Architect lane must author the brand-new `DESIGN_PENDING` registry rows (`program_create.png`, `programs_empty.png`, `program_details_joined.png`) with design-revision refs at implementation time, since `goldens-update.yml` only iterates existing rows. |

---

## Status Ledger — Gate Execution (Q3–Q6)

| Gate | Status | Evidence basis |
|------|--------|----------------|
| Q3 Automated | **PASS** | `docs/qa/results/qa-result-q3-automated.yaml` (result `D26E7F90-CC03-4AA4-944B-70C66BCB4273`, 2026-09-13). Analyze clean; `generate:check` clean; test:server **33/33** (incl. PC-010 concurrency + rollback atomicity); test:unit 2/2; test:flutter **121/121**; registry conformance PASS. E2E marked **NOT_IN_DEFAULT_PIPELINE** — opt-in/device-gated, flagged, never silently asserted. |
| E2E Journey (App→Server) | **PASS** (live-interaction execution) | Journey added 2026-09-13 (`apps/app/integration_test/app_journey_test.dart`) and executed 2026-09-13 as the **live-interaction** equivalent against a real Serverpod + PostgreSQL stack (`docs/qa/results/qa-session-e2e-live.md`, evidence `docs/qa/results/evidence-e2e/`). All journey assertions passed: unauthenticated → `/login`; wrong-password → safe `AppInlineAlert` (server-backed 400); fresh-email registration via UI with a **pinned dev verification code** (`SERVERPOD_DEV_VERIFICATION_CODE`, honored only in development — mirrors the fixed `000000` generator in `test/integration/auth_flow_test.dart`); `/programs` with `programs_create_action`; form fill incl. calendar date entry → submit; created card in list; `View Details` → **JOINED** + Cancel Membership. DB-verified: `programs id=3` `createdBy` = the E2E user, `program_members` auto-joined same txn (PC-009). The automated `flutter test integration_test` runner is device-gated in this environment (iOS simulator hangs at loading; web unsupported) — that lane is the framework-level U-03 / agentic-engineering-framework#2 finding, resolved upstream with formal `NOT_EXECUTED` vs `SKIPPED` gate semantics; the journey itself is executed here per the product's live-interaction convention. Never silently asserted. |
| Q4 Visual (local) | **PASS (local)** | `docs/qa/results/qa-result-q4-visual-local.yaml` (result `DF338142-83FE-4ED2-BB45-9B79DE37E518`, at revision `1824dae`). Golden registry conformance (`golden_registry_test.dart`, host-agnostic) PASS. Linux-CI 0-pixel pixel gate **PENDING by design** (platform of record; macOS prohibited for golden regeneration). |
| Q5 Human QA | **ACCEPTED — PARTIAL (follow-ups NA-01..NA-05 tracked)** | `docs/qa/results/qa-result-q5-human.yaml` (result `9ef1bdf9-67f6-47bf-9311-3894c7f140c1`, LIVE_INTERACTION, executed 2026-09-13T10:56:00Z, ~24 min) + `docs/qa/results/qa-session-q5-human.md` (timestamped session, UTC 10:56–11:33) at session HEAD `8486381`, revision under test `1824dae`. Charters: **C4 PASS**; **C1/C2/C3 PARTIAL** (EVIDENCE_GAPS, no failures). Usability: correct-on-field error PASS, dismiss+resubmit PASS; both-entry-points + back-arrow PARTIAL. A11y: semantics labels PASS, initial-focus-on-name PASS; token-only contrast EVIDENCE_GAP, interactive-targets ≥44px PARTIAL, live-region PARTIAL (shipit_ui static `liveRegion:true` flags confirmed — app_text_field.dart:266-275, app_date_picker.dart:201-205, app_inline_alert.dart:111-117), first-invalid-focus PARTIAL. **UPSTREAM_GAP_VERIFIED: YES** — AppDatePicker ~20px `date_picker_clear` reported (`upstream-ui-gaps.md` UPSTREAM_UI_GAP-003; design-revision-001 F4) and NOT regressed. Findings: **F1 exactly-once** — INFORMATIONAL **ENVIRONMENT_DEFECT** (DWDS/webdev injected-client `_JsonMap` cast), lane INFRA_REMEDIATION, effect_on_product_code NONE → Human-gate threshold (:510, "No unresolved CRITICAL/HIGH findings at verdict") **MET**. PARTIAL reflects evidence-gaps with follow-ups NA-01/NA-02 (MEDIUM, C1 dark-mode + shell-width sweep) + NA-03/NA-04/NA-05 (LOW, C2/C3/A11y). **PARTIAL result formally ACCEPTED as-is** by human decision `D37D43B5-6BA8-4B3C-9FA8-95F2CF68B777` (OPTION_A, RESOLVED 2026-09-13T06:00:00Z, `.decisions/human-decision-D37D43B5-6BA8-4B3C-9FA8-95F2CF68B777.yaml`); NA-01..NA-05 tracked as non-blocking follow-ups (owner engineering-manager). Human gate **CLOSED**. |
| Q6 Verdict | **READY_FOR_MERGE** | `docs/qa/results/qa-verdict-q6.yaml` (revision 3, 2026-09-13). No product defect (unclassified 0, product_defects 0); F1 INFORMATIONAL ENVIRONMENT_DEFECT classified exactly once. All human decision gates CLOSED (D1, D4, and Q5 accept-as-PARTIAL). Q5 accepted via D37D43B5; READY_FOR_MERGE; pixel gate + promotions enforced by CI on merge. Outstanding: Linux-CI 0-pixel gate (`melos run test:golden` via qa.yml, runs automatically on merge to main, platform of record) + 3 DESIGN_PENDING → APPROVED baseline promotions (goldens-update.yml Linux-CI re-affirmation + design/human approval; QA Architect records the status transition in the promotion commit) + non-blocking follow-ups NA-01..NA-05. |
| Q7 Golden Promotion | **APPROVED (3/3 promoted)** | 2026-09-13: human approval granted for the goldens-update.yml regeneration (decision `CD86C1A3-3BF7-4148-9B85-38035C73684F`, undoing the `FEA82795` deferral; reviewer **tariq**, `design_revision 77ccf5c1-9f2b-4798-87ec-c9b8bd7fb2e3`); the Linux CI host regenerated `program_create.png`, `programs_empty.png`, `program_details_joined.png` (workflow run `34763110654` → commit `a5a5c15`) and appended `[re-approved 2026-09-13 for 77ccf5c1-… by tariq via goldens-update.yml]` markers. QA Architect recorded the DESIGN_PENDING → **APPROVED** status transition in the promotion-record commit `0def076`. qa.yml re-ran against the APPROVED baselines on `0def076` — **result: SUCCESS, main merge-clean** (run `34763722307`, all jobs green: analyze, test, build-web, build-android, build-ios; GitHub Actions only on push). Pixel gate **CLOSED**. |

Per the frozen Gate Criteria (:501-510) and overall-gate entry (:512-514): the
Human gate is REQUIRED and its verdict-time threshold ("No unresolved CRITICAL/
HIGH findings at verdict") is **met** — the PARTIAL status is an evidence-gap
state (2 MEDIUM + 3 LOW follow-ups), not a failure, and BLOCKED does not apply.
The PARTIAL Q5 result has been formally **ACCEPTED as-is** by human decision
`D37D43B5-6BA8-4B3C-9FA8-95F2CF68B777` (OPTION_A), closing every human decision
gate (D1, D4, Q5). All applicable gates PASS at verdict →
**READY_FOR_MERGE**; the remaining items are CI-enforced on merge to main:
(a) the Linux-CI 0-pixel golden gate (`melos run test:golden` via qa.yml, the
merge workflow's own enforcement gate — platform of record; macOS informational),
and (b) the DESIGN_PENDING → APPROVED baseline promotions (goldens-update.yml
Linux-CI regeneration/re-affirmation + design/human approval, with the QA
Architect recording the status transition in the promotion commit).

## Review & Freeze

**Gate Q1**: QA Contract Review (completeness, traceability to Design Contract
`8D9E1F3C-77CC-45C1-9F2B-47987EC9B8BD` + requirements PC-001..PC-010/AC-11,
feasible test strategy, clear evidence standards). **PASSED 2026-09-13** by
`independent-engineering-reviewer` after the Gate Q1 revision v1.0.1 resolved
F-001 (golden-test mapping) and F-002 (promotion-status mechanics) — re-review
verdict `QA_CONTRACT_APPROVED`.
**Gate Q2**: QA Contract Freeze — **EXECUTED 2026-09-13T02:34:00Z** by the
engineering-manager (`FROZEN`, v1.0.1). Required before implementation reports
`IMPLEMENTED` — now satisfied.

**Next Gate**: Implementation (with frozen QA Contract as target).