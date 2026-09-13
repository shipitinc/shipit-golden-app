# Design Brief — AE02F243-F283-4A9A-8D50-5597B8CAE9BE (rev 1.0.1)

<!-- Design Brief: DRAFT -> UNDER_REVIEW -> APPROVED (Gate D1 review + Gate D2 human approval)
rev 1.0.1: addressed Gate D1 findings (traceability) - in-repo requirements source,
           explicit PD-1/2/3 decision_id mapping, defined P2 gap #1, split AC for
           distinguishability. -->

## Metadata

| Field | Value |
|-------|-------|
| `brief_id` | AE02F243-F283-4A9A-8D50-5597B8CAE9BE |
| `version` | 1.0.1 |
| `status` | APPROVED |
| `created_by` | agent_id: design-agent-fcp-scaffold |
| `created_at` | 2026-09-12T23:59:23Z |
| `updated_at` | 2026-09-13T00:12:00Z |
| `approved_by` | Human (product/design lead) — Human Decision 4BBBFDCB-E43A-45C5-B676-432A00750E18 (Gate D2) |
| `approved_at` | 2026-09-13T00:12:00Z |

## Traceability

- **Requirements Refs**: `docs/features/FEAT-PROGRAM-CREATE-001-requirements.md`
  (defines PC-001..PC-010 in-repo; feature work item
  `A9108212-3417-4E14-B3BA-7BBED3EC2B54`). Additional requirement source:
  `FEAT-PROGRAM-CREATE-001` Phase 2 Planning Package, Section 5 (archived in the
  requirements artifact above).
- **Architecture Refs (ADRs)**: `docs/architecture/frontend.md`,
  `docs/architecture/backend.md`, `docs/architecture/state-management.md`,
  `docs/architecture/flavors.md`, AEF `DESIGN_GOVERNANCE.md`, AEF
  `QA_GOVERNANCE.md`.
- **Human Decisions (resolved, in-repo)**: PD-1 →
  `.decisions/human-decision-0C250F09-6E2B-4B7B-A4E2-4802F8C56EF7.yaml`
  (createdBy); PD-2 →
  `.decisions/human-decision-55A8059D-1A09-4C37-A60E-F2539DDC22AF.yaml`
  (auto status); PD-3 →
  `.decisions/human-decision-1231D220-2CD6-42C6-BA96-79317543B616.yaml`
  (auto-join).

## Problem Statement

Programs are currently view-only: any authenticated user can browse the global
program listing and open program details. There is no sanctioned, designed way
to create a program. The Programs empty state carries a literal placeholder —
`'DESIGN_PENDING: Program creation flow'` (`programs_screen.dart:93`) — proving
the creation workflow was explicitly deferred to the design lane. The product
needs the smallest coherent, design-approved "Create Program" workflow that
demonstrates the full reference vertical slice (client form → server
persistence → list refresh → creator membership) without inventing product
scope.

## User Flows

### Flow: create-a-program
- **Entry Criteria**: Authenticated user with at least one household (`/household` reachable); user on `/programs` (empty state or listing) selects the create action.
- **Steps**:
  - User triggers the create action from the Programs surface (entry-point presentation is a Design Revision decision).
  - App navigates to the Create Program form.
  - User enters name (required), optional description, startDate and endDate (both required).
  - Form validates client-side (`endDate > startDate`, required fields) and the submit button shows loading while in flight.
  - Server validates again; on success persists the Program (`createdBy` = caller) and auto-joins the creator's household (PD-3).
  - On success the app returns to `/programs`, refreshed from the server; the new program is visible (PC-003/PC-005/PC-010).
  - On failure the form retains its content and shows a dismissible inline error (PC-006); validation errors surface per-field (PC-002/PC-004).
- **Exit Criteria**: New program visible in listing having survived a server round-trip; creator is a member (joined state reachable via PD-3 auto-join); no invalid program persisted.
- **Success Metrics**: Create-to-visible round trip completes under the AppButton-loading latency; zero invalid program rows; creation does not blank loaded content (loading-states.md rule 1).

## Success Criteria

- New program appears in `/programs` after a server round-trip (Measurable: widget + server integration tests, PC-003).
- Server rejects invalid dates/absence of required fields with a typed 400 (Measurable: server integration, PC-004).
- Creator `createdBy` is recorded (Measurable: DB row check, PC-005).
- Exactly one household + membership per creator under concurrent creates (Measurable: deterministic concurrency test, PC-010 / P2 gap #2).
- Failed create preserves form content and surfaces a dismissible inline error (Measurable: widget test, PC-006).
- Load uses skeletons/button-loading, not spinners, except in buttons (Measurable: visual + golden, PC-008/PC-009).

## Constraints

| Category | Constraints |
|----------|-------------|
| Technical | Serverpod 3.4.13 models/endpoints; `requireLogin` only (flat identity = `session.authenticated!.userIdentifier`); SAFE additive migration (PD-1); Regenerate server+client + `.generated_manifest.json` re-snapshot; derived status from dates (PD-2); auto-join via `getOrCreateFor` (PD-3) |
| Brand | shipit_ui components + `context.*` tokens only (`design-authority.md`); no raw Material, no arbitrary values; UI must be product-agnostic to shipit_ui |
| Regulatory | No PII beyond existing auth identity; no new data class surfaced |
| Accessibility | WCAG AA; 40dp touch targets, semantics labels (precedent: `dark_mode_test.dart`, `accessibility_semantics_test.dart`) |
| Performance | No spinners for content; skeleton on load; button loading only for mutation (`loading-states.md`) |
| Other | Goldens NEVER regenerated on macOS (Linux CI only, `.github/workflows/goldens-update.yml`); generated code not committed; baseline shipit_ui pin `c310a961aa` untouched |

## Acceptance Criteria

- **AC-01**: An authenticated user can open the creation flow from the Programs surface. — *Testable via*: AUTOMATED widget (PC-001)
- **AC-02**: The form validates required fields and endDate > startDate with per-field error text. — *Testable via*: AUTOMATED widget (PC-002)
- **AC-03**: Submit persists via server round-trip and listing shows the new program. — *Testable via*: AUTOMATED server integration + widget (PC-003)
- **AC-04**: Server rejects invalid input with a typed 400; app maps to AppFailure.validation with user-safe message. — *Testable via*: AUTOMATED server + unit (PC-004)
- **AC-05**: Creator identity is recorded. — *Testable via*: AUTOMATED server (PC-005)
- **AC-06**: Failed create keeps form content + dismissible inline error. — *Testable via*: AUTOMATED widget + bloc (PC-006)
- **AC-07**: Unauthenticated access redirects to /login. — *Testable via*: AUTOMATED widget + server (PC-007)
- **AC-08**: Skeletons (list) + button loading (submit); no content spinners. — *Testable via*: VISUAL + AUTOMATED (PC-008)
- **AC-09**: New create-flow screens register goldens (DESIGN_PENDING -> APPROVED). — *Testable via*: VISUAL / HUMAN (PC-009)
- **AC-10**: Concurrent creates/joins for one owner produce exactly one household + one membership (deterministic; closes P2 gap #2). — *Testable via*: AUTOMATED server concurrency regression (PC-010)
- **AC-11**: Program-details **joined-state** golden baseline registered (DESIGN_PENDING -> APPROVED), closing P2 gap #1 (current registry covers not-joined only — `goldens_registry.md:14`). — *Testable via*: VISUAL / HUMAN

## Risk Assessment

| Risk Level | Rationale |
|------------|-----------|
| 2 (Feature UX Change) | New user-facing creation workflow changes user behavior (Level 2 per DESIGN_GOVERNANCE.md); requires Independent Design Review (D1/D3) + Human Design Approval (D2/D4). Implementation-level details (e.g., a standard shipit_ui-empty-state CTA) may be Level 1 AUTO. |

---

## Design Exploration Guidance

This Design Brief authorizes the Design Agent to explore candidate designs via
Design Revisions (docs/design/revisions/). Each revision will be evaluated
against these criteria and the risk-level framework in DESIGN_GOVERNANCE.md.
No feature code is authorized by this brief.

**Next Gate**: Independent Design Review (Gate D1) → Human Approval (Gate D2) → Design Exploration.