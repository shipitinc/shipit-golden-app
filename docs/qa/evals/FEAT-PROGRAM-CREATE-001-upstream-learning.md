# FEAT-PROGRAM-CREATE-001 — Upstream Learning Classification

Phase 2 Golden Path findings categorized per the AEF learning policy
(LEARNING_POLICY.md). Each item is tagged EXACTLY ONE category
(`EPHEMERAL` / `PROJECT_FACT` / `RUNTIME_DISCOVERY` / `ARCHITECTURE_DISCOVERY` /
`DESIGN_DISCOVERY` / `QA_DISCOVERY` / `DEPLOYMENT_DISCOVERY` /
`HUMAN_DECISION_RECORD` / `WORKFLOW_IMPROVEMENT` / `AUTOMATION_OPPORTUNITY` /
`CONTRADICTION`) and routed to the correct owning repository. **No upstream
changes were made in this run** — candidates are reported here for the framework
/ shipit_ui maintainers.

## Upstream candidates (none implemented)

### U-01 — AEF gap: QA contract `E_*` generic vs feature-specific evidence
- **Category**: `AEF_GAP` (upstream). Split/shape the QA contract's generic
  `E_*` evidence rows so a QA Architect can reference feature-specific artifacts
  (e.g. this feature's `E2E_VERIFICATION_CODE` journey) without hand-editing a
  frozen contract or going OOS.
- **Owner**: shipitagentic / framework. **Filed 2026-09-13 as
  [agentic-engineering-framework#1](https://github.com/shipitinc/agentic-engineering-framework/issues/1)**.
- **Resolved** upstream. No change consumed in this app.

### U-02 — shipit_ui gap: `AppDatePicker` clear-target too small (~20px)
- **Category**: `SHIPIT_UI_GAP` (upstream). Small clear icon in date pickers,
  below the ≥44px interaction target guideline. Already reported to shipit_ui as
  `UPSTREAM_UI_GAP-003` (design-revision-001 F4); verified in Q5 and NOT
  regressed in this app. **Filed 2026-09-13 as
  [shipitinc/shipit-ui#16](https://github.com/shipitinc/shipit-ui/issues/16)**
  (GTD D3 F4). Owner: shipit-ui.
  - **Effect on Golden App**: none — no local reimplementation (AGENTS.md:
    product-agnostic shipit_ui, UPSTREAM_UI_GAP reporting over patching).
  - **Resolved upstream** 2026-09-13T17:33:47Z — shipitinc/shipit-ui#16
    **CLOSED** by the maintainer; fix landed in `2e4a8fe` ("Fix AppDatePicker
    clear affordance tap target to 44dp (WCAG AA)", `_targetSize = 44` in
    `app_date_picker.dart`, icon visually 20px within a 44px hit target),
    237 tests pass. **Not yet consumed in this app**: the pinned ref is still
    `c310a961aa`, so UPSTREAM_UI_GAP-003 remains observable at the pinned
    revision; consumption is a separate shipit_ui pin-bump product decision
    (see pending-actions).

### U-03 — ShipIt platform gap: no headless-device E2E in local/CI workflow
- **Category**: `SHIPIT_PLATFORM_GAP` (upstream). The contract orders an
  authenticated app→server E2E journey (`§End-to-End Tests`) that is
  "device-gated", but there is no CI device/emulator lane AND no local headless
  device can run it — so the gate is permanently READY_NOT_EXECUTED in this
  environment. That makes E2E evidence unattainable-by-design while staying a
  real contract line.
- **Owner**: shipitagentic / golden app. **Filed 2026-09-13 as
  [agentic-engineering-framework#2](https://github.com/shipitinc/agentic-engineering-framework/issues/2)**.
- **Resolved** upstream. No change consumed in this app.

## Golden App / product-specific classifications

### G-01 — Q5 Human QA: C1/C2/C3 EVIDENCE_GAP (no failures), F1 INFORMATIONAL
- **Category**: `QA_DISCOVERY` (product + QA strategy). First live human-QA
  session. APP acts as a `LIVE_INTERACTION` harness w/ screenshots + a11y
  snapshots. PARTIAL accepted via decision `D37D43B5-6BA8-4B3C-9FA8-95F2CF68B777`;
  no product defects found (zero CRITICAL/HIGH/MAJOR). Single INFORMATIONAL
  finding F1 = ENVIRONMENT_DEFECT (DWDS/webdev `_JsonMap` injected-client + one
  `ERR_CONNECTION_REFUSED` from a transient 8099 bootstrap) — lane
  `INFRA_REMEDIATION`, effect on product code NONE. Follow-ups:
  **NA-01** dark-mode sweep (MEDIUM), **NA-02** tablet/mobile shell-widths
  600/800/1200px (MEDIUM), **NA-03** live date-field per-field errors (LOW),
  **NA-04** live validation-rejection origin (LOW), **NA-05** SR announcement +
  first-invalid-field focus verify (LOW).

### G-02 — A11y wiring is not token-complete in this app
- **Category**: `DESIGN_DISCOVERY` (product). Contrast tokens come from shipit_ui
  tokens, not per-version color overrides — so `E10-D11 (contrast)` is a
  structural EVIDENCE_GAP for any feature app. The design contract says contrast
  is "by token"; artifact audit passed. NOT a defect; add to design-authority
  guidance (docs/design/design-authority.md) so future features know contrast is
  token-provided and only new tokens require re-approval.

### G-03 — Multi-flavor runtime on dev host
- **Category**: `RUNTIME_DISCOVERY`. Dev server binds 8080; golden host runs an
  overridden `API_BASE_URL=localhost:8099` (pending-actions #2) to avoid the
  `partnerhub-*` app locked on 8080. Documented in `docs/qa/pending-actions.md`;
  reproduced for Q5. This is product-developer knowledge — persist there, done.

### G-04 — Migration strategy: additive + PC-010 concurrency/rollback
- **Category**: `ARCHITECTURE_DISCOVERY` / `DEPLOYMENT_DISCOVERY`
  (product + server). `createdBy` implemented as an additive nullable mirror
  (`server_pod` migration), validated by PC-010 serial concurrency + rollback
  atomicity; the server derives creator from `session.userIdentifier` (not client
  input) and auto-joins the creator's household in the same caller-owned
  transaction. If this pattern is generalized it compresses future
  features; report as a server-pattern candidate (no change here).

### G-05 — Generated output is gitignored; `.generated_manifest.json` is the drift gate
- **Category**: `PROJECT_FACT` (product). Serverpod outputs (`server/lib/src/generated/`)
  and app_client protocol outputs are regenerated + hash-gated via
  `melos run generate:check`; model changes must be re-manifested
  (`melos run generate:manifest`). Required on EVERY model/endpoint change —
  this run consumed it for `Program.createdBy` + `createProgram`. Persisted in
  AGENTS.md (already there); test-server 33/33 proves compile+run cleanliness.

### G-06 — Freezed/immutable BLoC contract enforced by PC-001..PC-009
- **Category**: `ARCHITECTURE_DISCOVERY` (product). Program-creation state is a
  Freezed immutable contract (PC-001), no mutable collections (PC-002), business
  logic in BLoC not widgets (PC-003..PC-005), server-authoritative createdBy
  (PC-008), single-txn auto-join (PC-009), concurrency rollback (PC-010). All
  verified in Q3. This is the "golden path" the app is named for; not a new
  upstream gap.

## Decision: no pushes to upstream made

Per AEF authority ladder and AGENTS.md, no upstream commits (AEF/shipit_ui/
partnerhub) were made during this run. U-01..U-03 were reported here and in
`docs/qa/pending-actions.md`.

**Status update (2026-09-13, confirmed by engineering):** all three filed
upstream issues are now **resolved upstream** — AEF#1 (contract `E_*`
evidence rows) and AEF#2 (unrunnable E2E gates) landed in the framework in
commit `01e0e84`, which now mandates that any permanently-unrunnable REQUIRED
gate be made runnable, formally declared `SKIPPED` (reasons + authority_ref),
or revised, and distinguishes `NOT_EXECUTED` from `SKIPPED` in `gate_results`;
and shipit-inc/shipit-ui#16 (U-02, AppDatePicker `date_picker_clear` ~20px
target) was **closed upstream 2026-09-13T17:33:47Z** with the 44dp hit-target
fix in `2e4a8fe` (not yet consumed — the pinned ref remains `c310a961aa`).
The Golden App consumes the AEF resolution for the app→server E2E: the
journey (`app_journey_test.dart`) is executed as the product's live-interaction
equivalent against a real Serverpod+PostgreSQL stack (see
`qa-session-e2e-live.md`), with deterministic registration via a dev-only
`SERVERPOD_DEV_VERIFICATION_CODE` pin, and the row is formally determined in
the `E_*` model via the adopted strategy (`docs/qa/strategy.md`) and contract
Status Ledger — `E2E_JOURNEY` EXECUTED, `E2E_AUTOMATED_RUNNER` SKIPPED with
`reasons` + `authority_ref` — instead of being left permanently
READY_NOT_EXECUTED by an unavailable device lane (shipit-golden-app#1).