# Phase 2 Evaluation Record — FEAT-PROGRAM-CREATE-001

The program-creation feature configured as the Phase 2 Golden Path proof. This
record is durable traceability for the benchmark: requirement → decisions →
acceptance criteria → QA contract → design revision → code → migration →
generated contract → review → QA evidence → human approval.

## Identity

| Field | Value |
|-------|-------|
| Feature ID | FEAT-PROGRAM-CREATE-001 |
| Work item ID | `A9108212-3417-4E14-B3BA-7BBED3EC2B54` |
| Requirement artifact | `docs/features/FEAT-PROGRAM-CREATE-001-requirements.md` |
| QA contract | `c0b70155-b400-424e-b52b-00b09254c082` v1.0.1 (FROZEN) |
| Design contract | `8D9E1F3C-77CC-45C1-9F2B-47987EC9B8BD` (FROZEN) |
| Design revision | `77ccf5c1-9f2b-4798-87ec-c9b8bd7fb2e3` (DES-PROGRAM-CREATE-001-R1) |
| AEF SHA | `24caa51098e1d7cc479a0ca34c5e8af532675204` (local mirror, 2026-09-13) |
| shipit_ui SHA | `c310a961aa` (pinned git ref in `apps/app/pubspec.yaml`) |
| Model / agent assignment | big-pickle (workflow driver) + role agents (design, QA architect, QA executor, engineering reviewer) |

## Starting / Ending commit

| Field | Value |
|-------|-------|
| Starting commit (planning checkpoint) | `b025c12` (requirements + decisions + design brief recorded) |
| Design brief approved (Gate D2) | `ba27df9` |
| Design revision approved (Gate D3) | `f2c0760` |
| Design contract frozen (Gate D4/D5) | `488ceff` |
| QA contract frozen (Gate Q1/Q2) | `2fb3bf1` |
| Features merged into main | `081b3ad … 1824dae` (server, app, corrections, goldens registration) |
| Q3/Q4 execution + Q5 deferral | `5ee876f` |
| Q5 Human QA session | `d9f57dc` |
| Q6 verdict v1 (HUMAN_DECISION_REQUIRED) | `8486381` |
| Q5 accepted — Q6 READY_FOR_MERGE | `c787d25` |
| E2E journey addition (READY_NOT_EXECUTED) | `89fd5cf` |
| Phase 2 eval/learning records | `5a10e8b` + `61d2e0d` (pushed) |
| Current candidate HEAD | `61d2e0d` (pushed to origin/main) |

## Requirement ↔ Human decisions

| Decision | Decision ID | Resolution | Requirement impact |
|----------|-------------|------------|--------------------|
| PD-1: `Program.createdBy` (creator field) | `0C250F09-6E2B-4B7B-A4E2-4802F8C56EF7` | OPTION_A (added, server-set from `session.userIdentifier`) | PC-003, PC-005 |
| PD-2: Status auto-derived (not user-picked) | `55A8059D-1A09-4C37-A60E-F2539DDC22AF` | OPTION_A (derive from dates vs now) | PC-004, AC-01..AC-03 |
| PD-3: Auto-join creator household | `1231D220-2CD6-42C6-BA96-79317543B616` | OPTION_A (creation + auto-join in one transaction) | PC-007, AC-11 |
| Gate D2 design brief | `4BBBFDCB-E43A-45C5-B676-432A00750E18` | OPTION_A | design lane start |
| Gate D4 design revision | `39E90886-3D53-4792-89CD-8F24ED855C2B` | OPTION_A | design contract freeze |
| Gate Q5 deferral (initial) | `3BDFEA41-2C41-41C5-965E-41CB9ECE8FED` | OPTION_B (defer) | Q5 gate queued |
| Gate Q5 initiate | `2F7C47E4-CF66-4D2C-B384-27105D75C6E0` | OPTION_A (run) | Q5 executed |
| Gate Q5 PARTIAL acceptance | `D37D43B5-6BA8-4B3C-9FA8-95F2CF68B777` | OPTION_A (accept as-is + follow-ups) | Q6 READY_FOR_MERGE |

## Design lifecycle

- **Gate D2**: Design brief `AE02F243-F283-4A9A-8D50-5597B8CAE9BE` v1.0.1 approved →
  exploration start.
- **Gate D3**: Independent design review passed; revision #1
  (`77ccf5c1-…`, `f2c0760`) carried risk 2 and covered the full create surface:
  entry points (app-bar + empty-state CTA), form fields, validation, loading,
  failure, success, responsive, accessibility.
- **Gate D4**: Human visual approval (decision `39E90886`, OPTION_A) → **Gate D5**
  contract freeze (`8D9E1F3C-…`).
- Design authority: shipit_ui pin `c310a961aa` + design tokens; no local
  primitives invented. One upstream gap recorded: AppDatePicker ~20px
  `date_picker_clear` tap target (`UPSTREAM_UI_GAP-003`).

## Implementation lifecycle

- **Phase 1 server** (`081b3ad`, re-manifest `7781b4a`): `createdBy` added to
  `program.yaml`; `ProgramsEndpoint.createProgram` with
  `InvalidParametersException` validation + server-derived status +
  `createdBy=session.userIdentifier`; household auto-join via ONE caller-owned
  transaction; `HouseholdService.getOrCreateFor` gained `{Transaction?}`
  threading; migration `20260912*` (additive `createdBy`); `.generated_manifest.json`
  re-snapshotted (Serverpod outputs gitignored).
- **Phase 2 app** (`1207fc1`): `program_create_bloc/event/state` (Freezed,
  immutable), `create_program_screen.dart`, route `/programs/create` declared
  before `/programs/:id`, `programs_repository.createProgram`, entry points +
  refresh-on-create; widget/unit/a11y tests.
- **Correction loop**: engineering review F-01..F-06 → `1630feb` (F-03 rollback
  test, F-04 skeleton assertions), conformance `887efe3` (refresh emits
  `ProgramsState.loading()` skeleton), goldens registration `da67fc6` (3
  DESIGN_PENDING baselines by QA Architect), format fix `1824dae`. Final
  review: IMPLEMENTATION_APPROVED.

## QA evidence

| Gate | Result | Evidence |
|------|--------|----------|
| Q3 Automated | PASS | `docs/qa/results/qa-result-q3-automated.yaml` — analyze clean; generate:check clean; test:server 33/33 (incl. PC-010 5-way concurrency + rollback); test:unit 2/2; test:flutter 121/121; registry conformance PASS |
| Q4 Visual (local) | PASS (local) | `qa-result-q4-visual-local.yaml` — registry conformance PASS; pixel gate Linux-CI pending |
| Q5 Human QA | ACCEPTED — PARTIAL | `qa-result-q5-human.yaml` + `qa-session-q5-human.md` (live session 10:56–11:33 UTC) — C4 PASS; C1/C2/C3 evidence-gap partials; F1 INFORMATIONAL ENVIRONMENT_DEFECT only |
| E2E (App→Server) | READY_NOT_EXECUTED | `app_journey_test.dart` journey added (`89fd5cf`); device-gated, NOT_IN_DEFAULT_PIPELINE, not silently asserted |
| Q6 Verdict | READY_FOR_MERGE | `qa-verdict-q6.yaml` (rev 3, `47645A7A-…`); Linux-CI pixel gate + promotion CI-enforced on merge |

## Findings from this run

- **F1 (exactly once)**: INFORMATIONAL ENVIRONMENT_DEFECT — DWDS/webdev
  injected-client `_JsonMap` cast during dev-server hot reload
  (console-2026-09-13T11-15-53-084Z.log); lane INFRA_REMEDIATION; no product
  code impact.
- No IMPLEMENTATION_DEFECT / DESIGN_DEFECT / REQUIREMENT_GAP findings
  (unclassified 0, product_defects 0).

## Human interventions

- 8 structured human decisions (3 product + 5 gate); 1 gate deferral then
  re-initiation; Q5 followed up with a live human-QA session after an initial
  defer; PARTIAL Q5 accepted as-is.
- **Golden-baseline promotion DEFERRED** by human (decision
  `FEA82795-EC9E-4A87-BF57-8EEB69C4680D`, OPTION_B): the 3 DESIGN_PENDING
  baselines stay status DESIGN_PENDING; goldens-update.yml NOT dispatched; main
  CI remains red on exactly the 3 pixel tests until promotion.

## Follow-ups (non-blocking)

- NA-01 C1 dark-mode sweep (MEDIUM); NA-02 C1 tablet/mobile shell widths at
  600/800/1200px (MEDIUM); NA-03 C2 live date-field per-field errors (LOW);
  NA-04 C3 live validation-rejection origin (LOW); NA-05 a11y SR announcement +
  first-invalid-field focus verify (LOW).
- Linux-CI pixel gate + 3 DESIGN_PENDING → APPROVED promotions (CI-enforced
  on merge via `goldens-update.yml`). **Promotion DEFERRED 2026-09-13**
  (human decision `FEA82795-EC9E-4A87-BF57-8EEB69C4680D`); baselines remain
  DESIGN_PENDING, main stays red on exactly the 3 pixel tests until re-gated.

## Learning capture

See `docs/qa/evals/FEAT-PROGRAM-CREATE-001-upstream-learning.md` for the
upstream/golden-app classification of improvements discovered during this run.