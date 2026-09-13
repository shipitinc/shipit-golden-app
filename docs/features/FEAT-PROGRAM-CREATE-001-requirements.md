# FEAT-PROGRAM-CREATE-001 — Requirements

Resolvable, in-repo source of truth for the Program Creation feature. This is
the requirement artifact referenced by the Design Brief
(`docs/design/briefs/FEAT-PROGRAM-CREATE-001-design-brief.md`).

## Metadata

| Field | Value |
|-------|-------|
| Feature ID | FEAT-PROGRAM-CREATE-001 |
| Feature work item ID | A9108212-3417-4E14-B3BA-7BBED3EC2B54 |
| Status | PLANNED (requirements frozen; design lane in progress) |
| Resolved human decisions | `0C250F09-6E2B-4B7B-A4E2-4802F8C56EF7` (PD-1, createdBy), `55A8059D-1A09-4C37-A60E-F2539DDC22AF` (PD-2, auto status), `1231D220-2CD6-42C6-BA96-79317543B616` (PD-3, auto-join) |
| Source | Phase 2 Planning Package (checkpoint 1); resolved via structured human decisions 2026-09-12 |

## Feature Goal

The smallest coherent authenticated "Create Program" workflow that demonstrates
the full reference vertical slice (client form → server persistence → list
refresh → creator membership) on the existing non-chronological program listing,
without inventing product scope.

## Scope

**In scope:** creation workflow — form entry, validation (client + server),
persistence, list refresh, creator auto-join membership.
**Explicitly NOT in scope (unchanged):** editing, deletion, payments, waitlists,
scheduling/reminders, notifications, image uploads, staff management, advanced
capacity rules, reporting, multi-role authorization.

## Resolved Product/Architecture Decisions

| ID | Decision | Resolution |
|----|----------|------------|
| PD-1 | Creator field | Add `createdBy: String` (= `session.authenticated!.userIdentifier`) to `program.yaml`; SAFE additive migration; regenerate server+client; re-snapshot `.generated_manifest.json`. Decision `0C250F09-…` |
| PD-2 | Field/status policy | Required: name, startDate, endDate (enforce `endDate > startDate` server-side). Optional: description. `status` auto-derived from date range vs now (upcoming/active/completed). Decision `55A8059D-…` |
| PD-3 | Post-create membership | Auto-join creator's household via race-safe `HouseholdService.getOrCreateFor`; insert creator `ProgramMember`. Enables P2 gap #2 concurrency regression test. Decision `1231D220-…` |

## P2 Gaps Closed by This Feature

- **P2 gap #1 — program-details joined-state baseline:** the approved goldens
  registry only contains `program_details.png` for the **not-joined** state
  (`apps/app/test/goldens/goldens_registry.md:14`). The joined state (Cancel
  Membership CTA surface) has no golden baseline. This feature's auto-join
  (PD-3) makes the joined state reachable right after creation, so this feature
  adds a joined-state baseline (DESIGN_PENDING → APPROVED via Linux CI
  `.github/workflows/goldens-update.yml`, macOS regen forbidden).
- **P2 gap #2 — getOrCreate concurrency regression:** the race-safe
  `getOrCreateFor` (`household_service.dart:36-78`) has no deterministic
  concurrent regression test. Auto-join exercises this path; add the test.

## Acceptance Criteria (PC-001..PC-010)

| ID | Criterion | Test method |
|----|-----------|-------------|
| PC-001 | An authenticated user can open the creation flow from the Programs surface | AUTOMATED (widget) |
| PC-002 | Form validates required fields and `endDate > startDate` with per-field error text | AUTOMATED (widget) |
| PC-003 | Submitting persists via server round-trip; listing shows the new program on return | AUTOMATED (server integration + widget) |
| PC-004 | Server rejects invalid input with a typed 400; app maps to `AppFailure.validation` with a user-safe message | AUTOMATED (server + unit) |
| PC-005 | Creator identity is recorded (`createdBy`) | AUTOMATED (server) |
| PC-006 | Failed create keeps form content and shows a dismissible inline error | AUTOMATED (widget + bloc) |
| PC-007 | Unauthenticated access to the create route redirects to `/login` (router guard + `requireLogin`) | AUTOMATED (widget + server) |
| PC-008 | Loading uses skeletons (list) and button loading (submit); no content spinners | VISUAL + AUTOMATED |
| PC-009 | New create-flow screens register goldens (DESIGN_PENDING → APPROVED) | VISUAL / HUMAN |
| PC-010 | Concurrent creates/joins for one owner produce exactly one household + one membership (deterministic; closes P2 gap #2) | AUTOMATED (server integration concurrency) |

## Traceability Map

- PC-001..PC-010 → Design Brief AC-01..AC-10 (1:1).
- Design Brief AC-11 (program-details joined-state golden) has no PC-001..PC-010
  counterpart by design: it is a QA/visual closure traceable to PD-3 (auto-join
  makes the joined state reachable after create) + P2 gap #1 (`requirements.md` P2 Gaps section).
- PD-3 (auto-join) → PC-010, P2 gap #2.
- PD-3 (joined state reachable after create) → P2 gap #1 baseline closure (Design Brief AC-11).
- PC-009 + P2 gap #1 → `goldens_registry.md` rows: new create-flow golden + program-details joined-state golden.
- PC-007 → `app_router.dart` redirect guard (`:87-97`) + `ProgramsEndpoint.requireLogin`.
- PC-004/PC-006 → `error_translator.dart` `ValidationFailure` mapping + settled-mutation pattern (`loading-states.md`).

## Governance Notes

- Design authority: Penpot → shipit_ui → Golden App; shipit_ui components +
  `context.*` tokens only (`docs/design/design-authority.md`).
- Design Determination: **DESIGN_REQUIRED** (literal `DESIGN_PENDING: Program
  creation flow` marker at `programs_screen.dart:93`).
- Risk: Level 2 (Feature UX Change) → Independent Design Review + Human Design
  Approval required.
- Goldens: never regenerated on macOS; Linux CI only via
  `.github/workflows/goldens-update.yml`.