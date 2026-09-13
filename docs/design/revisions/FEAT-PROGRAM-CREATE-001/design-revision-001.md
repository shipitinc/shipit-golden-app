# Design Revision #1 — Program Creation Surface (FEAT-PROGRAM-CREATE-001)

- **Revision ID:** `77ccf5c1-9f2b-4798-87ec-c9b8bd7fb2e3`
- **Brief ID:** `AE02F243-F283-4A9A-8D50-5597B8CAE9BE` (v1.0.1, APPROVED, Gate D2)
- **Revision Number:** 1
- **Status:** UNDER_REVIEW (Gate D3 returned CHANGES_REQUIRED on findings F1-F4; all addressed — see §11 — and re-submitted for Independent Design Review)
- **Risk Level:** 2 (Feature UX Change)
- **Requirements:** `docs/features/FEAT-PROGRAM-CREATE-001-requirements.md` (PC-001..PC-010)
- **Base/Head SHA:** `ba27df9` (HEAD of `main` at authoring time; no commits by this revision)
- **Design authority chain:** Penpot → shipit_ui (`c310a961aa`, the app's published pin) → Golden App composition

> **Grounding note.** Every shipit_ui component and token cited below was
> verified against the actual pinned clone
> (`/tmp/opencode/shipit-ui`, HEAD `c310a961aa`) by reading its constructor
> before citing. No component, constructor parameter, or token that does not
> exist in that clone appears in this design. Nothing cited here is an
> upstream gap. The task prompt referred to a `cee3a9e` revision; the clone in
> fact checks out at `c310a961aa` (a shallow checkout, `rev-parse` fails on
> `cee3a9e`), which matches the pin published in `apps/app/pubspec.yaml`, in
> `docs/design/design-authority.md`, and in the goldens registry — see
> **§10 Discoveries**.

---

## 1. Path ownership (declared)

| Path | Mode |
|---|---|
| `docs/design/revisions/**` | **OWNED** (this revision creates `FEAT-PROGRAM-CREATE-001/design-revision-001-metadata.yaml` + `design-revision-001.md`) |
| `apps/app/lib/**`, `apps/server/**`, `packages/app_client/**`, `apps/app/test/**` (incl. `test/goldens/goldens_registry.md`), `.github/**` | **PROHIBITED** — no feature, server, client, or test/golden code written; no registry edits (the registry rows this revision requires are specified in **§7** for the implementation/QA lanes to register) |
| everything else referenced in this document (`docs/features`, `docs/design`, `.decisions`, `product.yaml`, shipit-UI clone) | **READ_ONLY** |

## 2. Scope

In scope (completes the approved brief): the authenticated create-program
workflow — entry points on the Programs surface, the create form screen, client
+ server validation, submit mutation with loading/settled-failure states, list
refresh on success, creator auto-join (PD-3) and its reachable joined state,
and the golden registrations required by PC-009 / AC-11.

Explicitly out of scope (unchanged from requirements §3): editing, deletion,
payments, waitlists, scheduling/reminders/notifications, image uploads, staff
management, advanced capacity rules, multi-role authorization, "my programs"
filtering, and any change to the global non-chronological listing semantics.
The program-details screen's joined-state surface is **not redesigned** — its
layout is already owner-approved (2026-09-12); this revision only sanctions the
missing **joined-state golden baseline** (AC-11 / P2 gap #1) that becomes
reachable right after creation.

---

## 3. Design decisions

### D-1 — Entry point (PC-001): app-bar action is PRIMARY; empty-state CTA is SECONDARY

The create action must be reachable "from the Programs surface" in **both** the
empty state and the populated listing (brief, Flow entry criteria).

- **Primary — app-bar action.** An `AppIconButton` (`icon: Icons.add`,
  `tooltip: 'Create program'`, `semanticLabel: Key('programs_create_action')`)
  added as the **first** action in the `ProgramsScreen` `AppBar.actions`
  (order: Create, Refresh, Sign out). Rationale: always visible regardless of
  list content, matches the established app-bar action convention — the
  existing Refresh/Sign-out actions live at `programs_screen.dart:32-51` and
  use `AppIconButton` (as does `household_screen.dart`); 44×44 target built in.
- **Secondary — empty-state CTA.** In the `ProgramsLoaded(programs: [])`
  branch, the existing `AppEmptyState` gains `actionLabel: 'Create program'`
  and `onAction` (which renders the standard `AppButton.secondary` inside
  `AppEmptyState`). Its `message` is replaced from the literal
  `'DESIGN_PENDING: Program creation flow'` (`programs_screen.dart:93`) with a
  real user-safe message: `'Programs you create will appear here.'` Title and
  icon are unchanged (`'No programs available'`, `Icons.event_outlined`).
  Rationale: discoverability when the list is empty; same navigation target.
- **No FAB.** A floating action would be a third, unrequested affordance
  (household's FAB exists for a table-less body; the Programs surface already
  gains two explicit controls). Rejected.

Both entry points call one shared `ProgramsView` helper
(`context.push<bool>('/programs/create')`, refresh on `true` — **§4.1**).

### D-2 — Navigation: `/programs/create`, nested in the programs shell branch (PC-001, PC-007)

- **Route:** `GoRoute(path: '/programs/create', name: 'program-create')`,
  registered **inside the existing Programs `StatefulShellBranch`** in
  `app_router.dart`, declared before `/programs/:id` (go_router scores literal
  segments above `:id`, so `create` never resolves as a program id; declaring
  it first documents intent). It is a sibling push route — the shell chrome
  (rail on tablet/desktop, bottom bar on mobile) stays visible and the branch
  Navigator preserves the `ProgramsBloc` via the `IndexedStack`.
- **Lead-in:** pushed via `context.push('/programs/create')` from either entry
  point (same push idiom `program_card.dart:54` uses for details).
- **Success:** the create screen pops **`true`**; the lead-in helper then
  dispatches `ProgramsRefreshRequested`. The list refreshes from the server and
  the new program appears (PC-003). Refresh emits the existing
  `ProgramsState.loading()` skeleton (PC-008) — this is a full reload, not a
  mid-mutation blank, so it follows the existing refresh pattern.
- **Cancel:** the app-bar back arrow (automatic on a pushed route) pops without
  a result → no refresh, no flicker.
- **Failure:** the screen stays on the form, content intact (PC-006).
- **Auth (PC-007):** `/programs/create` sits inside the authenticated
  `StatefulShellRoute`, so the existing redirect guard
  (`app_router.dart:89-97`: unauthenticated → `/login`) covers it with no
  change. Server side: the new `createProgram` endpoint keeps
  `requireLogin => true` (ProgramsEndpoint already does).

### D-3 — Form anatomy: exact shipit_ui composition (PC-002, PD-2)

Surface: `Scaffold(appBar: AppBar(title: Text('Create Program')))` — the
leading back arrow is the cancel affordance (no secondary Cancel button; a full
screen does not need the dialog Cancel/confirm pair).

Body layout (mirrors the approved auth-form precedent,
`login_screen.dart:121-133`):

```
Center
└─ SingleChildScrollView
   └─ Padding(horizontal: context.space.s4)
      └─ ConstrainedBox(maxWidth: context.layout.maxWidth.form)   // 440 token (GAP-015)
         └─ AppCard(padding: EdgeInsets.all(context.space.s5))
            └─ Form(key: formKey, child: Column(crossAxisAlignment: stretch))
```

Form fields, top to bottom (all required unless marked optional):

1. **Settled-mutation error** (`if submitError != null`): `AppInlineAlert.error`
   — `title: 'Could not create program'`, `message: submitError.userMessage`,
   `onDismiss:` dispatches the error-dismissed event. **Dismissible, NO
   `actionLabel`/Retry** (mutation failures never offer Retry —
   `loading-states.md` rule 6; contrast with the login alert which legitimately
   has Retry because login is an initial-load-style flow, not a settled
   mutation). Followed by `SizedBox(height: context.space.s4)`.
2. **Program name** (required): `AppTextField`
   - `label: 'Program name'`, `hint: 'e.g. Summer Camp'`,
     `semanticLabel: Key('program_create_name')`
   - `validator`: `v == null || v.trim().isEmpty` → `'Program name is required.'`
   - Screen-local `TextEditingController`, trimmed before dispatch.
3. Gap `context.space.s3` (field rhythm matches `add_member_dialog.dart:37`).
4. **Description** (optional): `AppTextField`
   - `label: 'Description'`, `hint: 'Optional'`, `maxLines: 3`,
     `semanticLabel: Key('program_create_description')`, **no validator**
   - Blank → `''` before dispatch (domain model requires a non-null String).
5. Gap `context.space.s4` (opens the date group).
6. **Start date** (required): `AppDatePicker`
   - `label: 'Start date'`, `mode: AppDatePickerMode.single`,
     `presets: const []`, `allowClear: true` (default),
     `semanticLabel: Key('program_create_start')`
   - `validator` (single-mode `FormFieldValidator<DateTime?>`):
     `v == null` → `'Select a start date.'`
   - No `firstDate`/`lastDate` constraint (past ranges are legal — the derived
     status handles `completed`).
7. Gap `context.space.s3`.
8. **End date** (required): `AppDatePicker`
   - `label: 'End date'`, `mode: AppDatePickerMode.single`,
     `presets: const []`, `semanticLabel: Key('program_create_end')`
   - `validator` (reads the current screen-local start value):
     - `v == null` → `'Select an end date.'`
     - `start == null` → `'Select a start date first.'`
     - `!v.isAfter(start)` → `'End date must be after the start date.'`
     (strict `endDate > startDate` per PD-2: equal dates fail `isAfter`.)
9. Gap `context.space.s5` (action separator, matching the form precedent).
10. **Submit:** `AppButton.primary`
    - `label: 'Create Program'`, `icon: Icons.add`,
      `semanticLabel: Key('program_create_submit')`
    - `state:` `AppButtonState.loading` while submitting, else `base`
      (loading disables and shows the in-button spinner — PC-008, rule 2).
    - `onPressed`: `formKey.currentState!.validate()`; if false → focus first
      invalid field and stop (no dispatch); if true → trim values, dispatch
      submit event.

**Rejected alternatives (recorded so the implementer does not re-decide):**
- **`AppSelect` for dates** — rejected: it is a discrete-options dropdown, not
  a calendar control; the brief's "AppDatePicker **or** AppSelect" is resolved
  to `AppDatePicker`.
- **`AppDatePickerMode.range` (single combineed control)** — rejected: PC-002
  requires **per-field** error text ("required fields and `endDate > startDate`
  with per-field error text"), and PD-2 models two distinct server fields
  (`startDate`, `endDate`) that are individually required. Two
  single-mode pickers give error attribution to exactly the failing field and
  keep the create payload 1:1 with the model.
- **Presets** — rejected: `AppDatePreset.defaults` (Today, Last 7/30 days,
  This month) are analytics-oriented and meaningless for a future program
  range; leave `presets: const []`.

### D-4 — `status` auto-derivation (PD-2): NOT a form field

Status has **no input control** in the form (no `AppSelect`, no chip). It is
derived server-side at create time from the submitted date range vs `now`
(`Date` precision; Serverpod stores UTC):
`startDate > now` → `upcoming`; `startDate <= now <= endDate` → `active`;
`endDate < now` → `completed`. These are exactly the three
`ProgramStatus` enum values and the three chip states already rendered by the
shared `ProgramStatusChip`. The user sees the result after return — the new
card's status chip is the feedback. (The form does not preview the derived
status; smallest coherent flow.)

### D-5 — Loading & failure states (PC-006, PC-008, `loading-states.md` rules 1-3, 6)

- **Create screen entry:** no network load — the form is static; **no skeleton**
  on this screen.
- **Submit in flight:** `AppButton.primary` swaps to `AppButtonState.loading`;
  fields stay editable (prevents double-submit via the disabled button without
  freezing input). No content shimmer, no spinner outside the button.
- **Submit failure (settled mutation):** the BLoC settles **back onto a
  kept-form state** carrying `submitError` (mirrors `ProgramDetailsState.loaded(
  mutationError:)` settlement, `loading-states.md` rule 3). The form is never
  blanked or replaced; a dismissible `AppInlineAlert.error` renders above the
  fields (§D-3 step 1). Controllers/values are never cleared, so content is
  retained (PC-006), and the user can correct + resubmit.
- **List refresh on return:** existing `ProgramsState.loading()` → `AppSkeleton
  .card()` × 3 (already implemented; PC-008). On server failure the existing
  failure branch + Retry stays as-is (initial-load path, rule 6).

### D-6 — Accessibility (brief constraints: WCAG AA, 40/44px targets, semantics, error announcement)

All interactive elements are shipit_ui components with built-in semantics
(verified in constructors) — no custom Material layers:

- **Semantics/labels:** `AppTextField` exposes `textField: true` + label;
  `AppDatePicker` exposes a button with label and the displayed value (date
  announced after selection); `AppButton`/`AppIconButton` are `button` nodes
  labelled with their label/tooltip, and the loading state announces
  `'Create Program, loading'`. Automation keys: `programs_create_action`,
  `programs_empty_create` (on `AppEmptyState.semanticLabel`), `program_create_name`,
  `program_create_description`, `program_create_start`, `program_create_end`,
  `program_create_submit`.
- **Error announcement (live regions):** per-field errors are announced via the
  components' existing live regions (`text_field_error`, `date_picker_error`),
  and the settled-mutation alert is a live region itself
  (`AppInlineAlert` severity.title.message); its dismiss control is
  `inline_alert_dismiss` (component-static keys — nothing invented).
- **Tap targets:** `AppButton` min-height 44, `AppIconButton` 44×44, date-picker
  field min-height 44 — all above the 40dp requirement.
- **Focus management:** name field receives initial focus on first frame
  (`FocusNode.requestFocus` in the screen state — `AppTextField` has no
  `autofocus` param). On a failed `Form.validate()`, focus moves to the first
  invalid field (name → start → end).
- **Contrast:** token colors only (`context.color.state.error.fg/.bg`,
  `context.color.fg.primary/secondary`, `context.color.action.primary.bg/.fg`)
  — WCAG AA enforced upstream (`dark_mode_test.dart` regression precedent).
- **Keyboard:** date entry is the standard Material calendar dialogs; text
  fields are default. `AppTextField` does not expose `textInputAction`, so Enter
  does not submit — submission is the explicit button (no invented override).

### D-7 — Empty state, post-create membership, and the joined state (PC-003, PD-3, AC-11)

- On success the create flow pops `true` → Programs refreshes → the new
  `ProgramCard` appears (PC-003). Create + auto-join are atomic in **one
  caller-owned database transaction** (`getOrCreateFor` threads the caller's
  `Transaction?` — wiring in §5-2), so the joined state is deterministic the
  moment create succeeds. The creator's household is auto-joined server-side
  (PD-3), so tapping the card opens **data-details with the joined state**
  (`_MembershipCard` shows `Joined · <name>` + `JOINED` badge + the
  `Cancel Membership` CTA). This makes the joined state reachable immediately
  after create, which is what closes P2 gap #1 (registry today covers
  not-joined only, `goldens_registry.md:14`). No redesign of the details
  screen — it is already owner-approved.

### D-8 — Golden baselines to register (PC-009, AC-11)

New registrations, all **`DESIGN_PENDING`** candidates at implementation time,
promoted to `APPROVED` **only** on the Linux CI host via
`.github/workflows/goldens-update.yml` under this revision once approved
(macOS regeneration prohibited). Rows to add to `goldens_registry.md`
(implementation/QA lane owns the file — Prohibited path here):

| Baseline | Screen / scenario | Status | Design revision | Notes |
|---|---|---|---|---|
| `goldens/program_create.png` | ProgramCreateScreen, initial empty form (no error) | DESIGN_PENDING → APPROVED | this revision | **REQUIRED** (PC-009). Rendered with `shipitLightTheme()`, real Inter, idle state, `pumpAndSettle` — same conventions as `program_details_golden_test.dart`. |
| `goldens/programs_empty.png` | ProgramsScreen empty state (title + message + `Create program` CTA + app-bar actions incl. create) | DESIGN_PENDING → APPROVED | this revision | **REQUIRED** (PC-001/PC-009) — the entry-point change alters a surface with no baseline today, so a candidate preserves visual-regression coverage. |
| `goldens/program_details_joined.png` | ProgramDetailsScreen loaded + **joined** (`Member` card `JOINED`, `Cancel Membership` CTA) | DESIGN_PENDING → APPROVED | this revision | **REQUIRED** (AC-11, P2 gap #1). The new row sits beside the existing not-joined `program_details.png`. |

All three are new files + registry rows in the same commit; no existing
`APPROVED` baseline is regenerated by this feature.

---

## 4. Screen-by-screen specification (buildable contract)

### 4.1 ProgramsScreen (modified — `apps/app/lib/features/programs/presentation/screens/programs_screen.dart`)

1. `AppBar.actions`: insert `AppIconButton(icon: Icons.add,
   tooltip: 'Create program', semanticLabel: Key('programs_create_action'),
   onPressed: () => _openCreate(context))` **before** the existing Refresh and
   Sign-out actions.
2. `ProgramsLoaded(programs: [])` branch: `AppEmptyState` keeps
   `title: 'No programs available'`, `icon: Icons.event_outlined`, swaps
   `message` to `'Programs you create will appear here.'`, and adds
   `actionLabel: 'Create program'`, `onAction: () => _openCreate(context)`,
   `semanticLabel: Key('programs_empty_create')`.
3. New `_openCreate(BuildContext)` helper on `ProgramsView`:
   `final created = await context.push<bool>('/programs/create');` then
   `if (created == true) context.read<ProgramsBloc>().add(const
   ProgramsRefreshRequested());`.
4. Everything else (loading skeleton, failure branch, RefreshIndicator,
   `ProgramCard` list) unchanged.

### 4.2 ProgramCreateScreen (new — `programs/presentation/screens/program_create_screen.dart`)

A `BlocProvider<ProgramCreateBloc>` screen composed of the surface, layout,
`Form`, fields and submit button specified in **§D-3**, plus a
`BlocListener<ProgramCreateBloc>` that `context.pop(true)`s on the terminal
completed state and a `BlocBuilder` that switches the alert (submitError) and
submit-button state (isSubmitting). Validators and controllers are
screen-local (precedent: `add_member_dialog.dart`); the BLoC never holds field
text, so form content survives every state transition by construction (PC-006).

### 4.3 ProgramDetailsScreen (unchanged UI)

No changes to `program_details_screen.dart`. The joined state rendered by the
existing `_MembershipCard` / `_MembershipBadge` / Cancel-Membership CTA is the
subject of the new `program_details_joined.png` baseline only.

---

## 5. Implementation-relevant notes (wiring — not code, no feature code written)

Enough direction that the implementation lane builds this exactly:

1. **Server model (PD-1):** add `createdBy: String` to
   `apps/server/lib/src/models/program.yaml` (flat identity =
   `session.authenticated!.userIdentifier`). Additive change → SAFE migration
   via `serverpod create-migration`; regenerate Serverpod server + client with
   `melos run generate` and re-snapshot the manifest with
   `melos run generate:manifest` so `melos run generate:check` stays green.
   Serverpod CLI must be `serverpod_cli 3.4.13`; `.generated_manifest.json`
   re-snapshot is mandatory (AGENTS.md). Regenerated output is gitignored
   (tracked mirror `serverpod_test_tools.dart` untouched — never hand-edit it).
2. **Server endpoint (PD-2/PD-3, PC-004/PC-005/PC-010):** add
   `createProgram` to `ProgramsEndpoint` (`requireLogin => true`):
   - validate name non-blank, both dates present, and
     `endDate.isAfter(startDate)` strictly; on violation throw the Serverpod
     **framework class** `InvalidParametersException(message)` (serverpod
     3.4.13, `endpoint_dispatch.dart`). Serverpod surfaces that error as a
     **plain HTTP 400**; the client rethrows it as the generic
     `ServerpodClientBadRequest`, and the existing translator case at
     `error_translator.dart:73-75` maps it to `AppFailure.validation` with the
     user-safe message. **Do NOT reuse `ProgramNotFoundException`** for
     validation: it is a lookup-miss sentinel that surfaces to the client as
     the **typed** `api.ProgramNotFoundException`
     (`error_translator.dart:43-45`) — the wrong semantics for
     `createProgram`, and it would contradict §5-3's "no
     `error_translator.dart` change required". **Zero new protocol models.**
   - derive `status` from the date range vs now (D-4).
   - write the Program, then auto-join the creator's household — reuse
     `HouseholdService.getOrCreateFor` + insert a `ProgramMember` (the same
     path `joinProgram` uses) — but make `getOrCreateFor` **transaction-
     threadable first**: as written (`household_service.dart:36-78`) it opens
     its own `session.db.transaction` and takes no `Transaction?` param, so a
     nested call would open a second pool connection and break atomicity.
     Mirror the `findByOwner` signature (`household_service.dart:13-25`): add
     `{Transaction? transaction}` and forward it to the inner `findByOwner`
     and both inserts so it reuses a caller-owned transaction when supplied.
     The endpoint then wraps create-Program + `getOrCreateFor(...,
     transaction:)` + insert-ProgramMember in **one caller-owned** database
     transaction, making create + membership atomic. This is what makes the
     PD-3 auto-join deterministic under concurrency and enables the PC-010 /
     P2-gap-#2 regression test (N concurrent creates for one owner → exactly
     one household, one membership per program, N programs).
   - return the created Program (convenient for PC-005 DB verification).
3. **Client repository:** add `ProgramsRepository.createProgram({required
   name, description, startDate, endDate}) → Result<Program>` mapping the
   response with the existing `programFromProtocol`. Error translation is
   already wired — the existing case at `error_translator.dart:73-75` maps the
   `ServerpodClientBadRequest` produced by the endpoint's
   `InvalidParametersException` to `AppFailure.validation`. No
   `error_translator.dart` change required.
4. **Client BLoC (BLoC + Freezed, immutable):** new `ProgramCreateBloc`.
   Events: `ProgramCreateSubmitted` (carries trimmed name/description + both
   dates), `ProgramCreateErrorDismissed`. States: `initial` (or an idle loaded
   analogue with an `isSubmitting` flag), `submitting`, `failure(submitError)`
   (settled, form kept), `completed` (terminal → screen pops true). The bloc
   mirrors the `ProgramDetailsBloc` mutation-settlement discipline
   (`loading-states.md` rule 3). The Programs app-bar gains a **third**
   `AppIconButton` (Create, before Refresh); any future widget test that
   counts app-bar actions must include it.
5. **Element keys/`name`s to keep stable** for widget + golden tests:
   route `program-create`; keys `programs_create_action`,
   `programs_empty_create`, `program_create_name`, `program_create_description`,
   `program_create_start`, `program_create_end`, `program_create_submit`;
   component-static `text_field_error`, `date_picker_error`,
   `inline_alert_dismiss`, `formatted` labels `'Program name'`, `'Start date'`,
   `'End date'`, `'Create Program'`.
6. **Golden registration** per §D-8; promote only via Linux CI
   `goldens-update.yml`; never `--update-goldens` on macOS.

---

## 6. Traceability matrix

| Requirement | Covered by | Design anchor |
|---|---|---|
| PC-001 | D-1, 4.1 | app-bar `AppIconButton` (existing actions at `programs_screen.dart:32-51`) + empty-state CTA → `/programs/create` |
| PC-002 | D-3 | `Form` validators, per-field error text (name, start, end, strict `endDate > startDate`) |
| PC-003 | D-2, D-7, 4.1 | push/pop `true` + `ProgramsRefreshRequested`; new card visible |
| PC-004 | D-3, §5-2, D-5 | `InvalidParametersException` → plain 400 → `ServerpodClientBadRequest` → `AppFailure.validation` (no new protocol model); kept-form inline error |
| PC-005 | §5-1/2, D-4 | `createdBy` on model + endpoint writes it |
| PC-006 | D-5, 4.2 | kept-form + dismissible `AppInlineAlert.error`, no Retry |
| PC-007 | D-2 | guard covers shell child; `requireLogin` on endpoint |
| PC-008 | D-3 (submit), D-5 (list) | `AppButtonState.loading`; `AppSkeleton.card` on refresh |
| PC-009 | D-8 | new `program_create.png` + `programs_empty.png` registrations |
| PC-010 | D-7, §5-2 | caller-owned single transaction; `getOrCreateFor` threads `Transaction?` (mirrors `findByOwner`) |
| Brief AC-11 (P2 gap #1) | D-7, D-8 | new `program_details_joined.png` registration |
| PD-1 / PD-2 / PD-3 | D-4, D-7, §5-1/2 | `createdBy`; auto status; auto-join via `getOrCreateFor` |

Requirements gaps: **none.**

---

## 7. Compliance & feasibility self-assessment (Design Agent claims; reviewer to verify)

- **design_system_compliance: PASS** — shipit_ui components + `context.*`
  tokens only (verified `c310a961aa`); no raw Material beyond what shipit_ui
  itself wraps; no invented tokens/components; no upstream gaps introduced.
- **ux_accessibility_score: PASS** — WCAG AA token contrast, 44px targets,
  component semantics + live-region error announcement, focus plan (§D-6).
  Known minor: cross-field date errors surface on the submit pass (consistent
  with the household add-member precedent); errors are announced, not silent.
  Known **upstream** gap (out of this design's control — see §9, Gate D3 F4):
  `AppDatePicker`'s `date_picker_clear` affordance renders a ~20px tap target
  (`app_date_picker.dart:283-295`), below the 40dp requirement; this is a
  shipit_ui accessibility gap to report upstream via UPSTREAM_UI_GAP/DCR, NOT
  resolved by inventing a new control in-app. Risk level unchanged (2).
- **implementation_feasibility: HIGH** — every component exists at the pinned
  revision; every interaction pattern already lives in the codebase
  (`add_member_dialog.dart` validation, `program_details_bloc.dart` mutation
  settlement, `login_screen.dart` form layout, `error_translator.dart:73-75`
  400 mapping); server work is an additive field + one endpoint reusing
  `HouseholdService.getOrCreateFor` (with the `Transaction?` threading and
  `InvalidParametersException` error path from §5-2 — both confirmed feasible
  by the Gate D3 reviewer).

---

## 8. Out of scope / decisions NOT taken (recorded)

- No `AppSelect` for dates, no combined `AppDatePickerMode.range` control
  (D-3 rejected alternatives).
- No preview of the derived status in the form (D-4).
- No `Retry` action on the create failure alert (D-3 step 1 — mutation, not
  initial load).
- No FAB for create (D-1).
- No "my programs" scope on the returned list (listing semantics unchanged).
- No change to the program-details joined surface's layout (D-7).

## 9. Discoveries

- **Prompt/clone revision skew:** the task brief cited shipit_ui revision
  `cee3a9e…`; the provided clone resolves to `c310a961aa`
  (`rev-parse --verify cee3a9e` fails — shallow checkout). All component
  verification therefore used `c310a961aa`, which is authoritative anyway:
  it is the pin published in `apps/app/pubspec.yaml`, `design-authority.md`,
  and the goldens registry. The design is valid against the active pin.
  **Persistence recommendation (repository-learning):** add a `DESIGN_DISCOVERY`
  record noting the design lane validated the component inventory at
  `shipit_ui@c310a961aa` (task-prompt revision reference corrected to the
  actual clone HEAD).
- The brief's "empty-state CTA may be Level 1 AUTO" carve-out is honored while
  the revision remains Level 2 overall; noted in `risk_rationale`.
- **Upstream accessibility gap (Gate D3 F4) — `AppDatePicker` clear tap
  target:** the `date_picker_clear` affordance
  (`shipit_ui/lib/src/components/app_date_picker.dart:283-295`) is an
  `AppTooltip`-wrapped `IconButton` with `padding: EdgeInsets.zero` and empty
  `constraints` at `iconSize: 20` — a ~20px target, below the 40dp WCAG AA
  requirement, inside a 44px-high field. Cannot be fixed in-app without
  violating design authority (shipit_ui is the sole UI authority). Action:
  report upstream via UPSTREAM_UI_GAP / a Design Change Request so shipit_ui
  ships a compliant hit target; this design intentionally does not invent a
  replacement control. Does not change the revision risk level (2).

## 10. Ready-for-review gate

This revision is complete and internally consistent: entry points, route,
form anatomy, loading/failure contract, accessibility contract, golden
registrations, traceability, and implementer wiring are all specified. It is
submitted for **Independent Design Review (Gate D3)**. The Design Agent does
not approve its own work. This revision does not modify lower-authority sources
and wrote to `docs/design/revisions/` only.

---

## 11. Revision changelog

- **Rev 1 (re-submission) — Addressed Gate D3 findings F1-F4:**
  - **F1:** exception pattern corrected — the create endpoint throws the
    Serverpod framework class `InvalidParametersException(message)`, surfacing
    as a plain 400 → `ServerpodClientBadRequest` → existing
    `error_translator.dart:73-75` → `AppFailure.validation`. Removed the
    wrong `ProgramNotFoundException`-style typed-exception instructions (and
    repeated wording in §6/§5) and made the §5-3 "no translator change" claim
    consistent; zero new protocol models.
  - **F2:** `HouseholdService.getOrCreateFor` specified as transaction-
    threadable — new `{Transaction? transaction}` mirroring `findByOwner`
    (`household_service.dart:13-25`), forwarded to inner queries/inserts —
    so create-Program + auto-join run within ONE caller-owned transaction
    (§5-2, §D-7); PC-010 test narrows to N concurrent creates for one owner →
    exactly one household, one membership per program, N programs.
  - **F3:** removed the fabricated "tests asserting exactly two
    `AppIconButton`s" claim; now states plainly the app-bar gains a third
    `AppIconButton` and any future action-counting widget test must include
    it.
  - **F4:** documented `AppDatePicker`'s ~20px `date_picker_clear` tap target
    as an upstream shipit_ui accessibility gap (§9, §7), to be reported via
    UPSTREAM_UI_GAP/DCR, not fixed in-app; risk level unchanged.
  - Corrected app-bar action citations to `programs_screen.dart:32-51`.
  - Status → UNDER_REVIEW for Gate D3 re-review by
    `independent-design-reviewer-dytajy`.
- Rev 1 (initial): complete first design revision, DRAFT, submitted for Gate
  D3.