# Design Contract — FEAT-PROGRAM-CREATE-001 (Program Creation Surface)

## Metadata

| Field | Value |
|-------|-------|
| `contract_id` | 8D9E1F3C-77CC-45C1-9F2B-47987EC9B8BD |
| `source_revision_id` | 77ccf5c1-9f2b-4798-87ec-c9b8bd7fb2e3 |
| `source_revision_version` | 1 (APPROVED, Gate D4 / Human Decision 39E90886-3D53-4792-89CD-8F24ED855C2B) |
| `brief_id` | AE02F243-F283-4A9A-8D50-5597B8CAE9BE |
| `feature_id` | FEAT-PROGRAM-CREATE-001 |
| `risk_level` | 2 (Feature UX Change) |
| `status` | FROZEN |
| `frozen_at` | 2026-09-13T00:28:00Z |
| `frozen_by` | engineering-manager (per Gate D5, DESIGN_GOVERNANCE.md) |
| `head_sha` | f2c0760 (authoritative source revision commit) |

## Status: FROZEN

This contract is immutable once frozen. Changes require the DCR process
(DESIGN_GOVERNANCE.md): a new Design Revision, independent review, and human
approval for Level 2+ changes. Implementation and QA Contract must satisfy this
contract; implementation-discovered UI gaps route back via DCR, never resolved
in the implementation lane.

## Bound Design (summary — the authoritative source is the revision artifact)

Full authoritative detail: `docs/design/revisions/FEAT-PROGRAM-CREATE-001/design-revision-001.md`.

- **Entry points (PC-001):** primary `AppIconButton(Icons.add, 'Create program',
  Key('programs_create_action'))` as the first `ProgramsScreen` app-bar action;
  secondary `AppEmptyState` CTA (`actionLabel: 'Create program'`, `onAction`,
  message replaced from the DESIGN_PENDING literal to
  `'Programs you create will appear here.'`). No FAB.
- **Route (PC-001/PC-007):** `GoRoute('/programs/create', name:
  'program-create')` nested in the programs `StatefulShellBranch`, registered
  before `/programs/:id`; guarded by the existing auth redirect + endpoint
  `requireLogin`.
- **Form anatomy (PC-002, PD-2):** `Scaffold(AppBar('Create Program'))` →
  Center → SingleChildScrollView → `ConstrainedBox(context.layout.maxWidth.form)`
  → `AppCard` → `Form`. Fields: settled-mutation `AppInlineAlert.error`
  (dismissible, no Retry) → `AppTextField` name (required) → `AppTextField`
  description (optional, maxLines 3) → `AppDatePicker` start (single mode,
  required) → `AppDatePicker` end (single mode, required, strict
  `endDate.isAfter(startDate)` per-field error) → `AppButton.primary('Create
  Program', icon: Icons.add, state: loading while submitting)`. Status is NOT a
  form field — derived server-side from the date range vs now (upcoming/active/
  completed).
- **Loading/failure (PC-006/PC-008):** skeleton list on refresh; button-loading
  only for submit; settled failure keeps the form and shows a dismissible inline
  alert; no content blanking.
- **Success (PC-003):** pop `true` → `ProgramsRefreshRequested` → list shows the
  new program.
- **Auto-join (PD-3, PC-010):** endpoint runs create-Program + `getOrCreateFor`
  + insert-ProgramMember in ONE caller-owned transaction, with `getOrCreateFor`
  gaining a `{Transaction? transaction}` param mirroring `findByOwner`.
- **Server validation/errors (PC-004/PC-005):** `createProgram` validates name
  non-blank, both dates present, `endDate.isAfter(startDate)`; throws Serverpod
  `InvalidParametersException(message)` → plain 400 → `ServerpodClientBadRequest`
  → `AppFailure.validation` (existing `error_translator.dart:73-75`; no new
  protocol model, no translator change). Writes `createdBy` = caller identity.
- **Goldens (PC-009, AC-11):** register new `program_create.png`,
  `programs_empty.png`, `program_details_joined.png` as DESIGN_PENDING →
  APPROVED, promoted only on Linux CI via `.github/workflows/goldens-update.yml`.
- **Accessibility:** WCAG AA token contrast, 44px targets, semantics labels +
  live-region error announcement, initial focus on name, first-invalid-field
  focus on failed validate. Known upstream gap (AppDatePicker clear ~20px)
  reported via UPSTREAM_UI_GAP/DCR, not fixed in-app.

## Traceability (PC-001..PC-010 + AC-11 + PD-1..3)

Complete — see the source revision §6 traceability matrix and metadata
`requirements_covered`. Requirements source:
`docs/features/FEAT-PROGRAM-CREATE-001-requirements.md`.

## Governance notes

- Design authority chain: Penpot → shipit_ui (`c310a961aa`) → Golden App
  composition; shipit_ui components + `context.*` tokens only.
- Implementers must not invent consequential UX beyond this contract; gaps route
  via DCR.
- QA Contract (QA Architect lane) freezes against this contract before
  implementation completes.