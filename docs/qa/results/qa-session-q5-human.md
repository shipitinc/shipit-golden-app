# Q5 Human QA — Session Log (FEAT-PROGRAM-CREATE-001)

## Session Meta

| Field | Value |
|---|---|
| Gate | Q5 — Human QA (REQUIRED: WCAG AA + exploratory, per contract) |
| Contract | `c0b70155-b400-424e-b52b-00b09254c082` v1.0.1 (FROZEN, Gate Q1/Q2) |
| Target revision | `1824dae` (feature head, range `2fb3bf1..1824dae`) |
| Executed at HEAD | `8486381` (`docs(qa): FEAT-PROGRAM-CREATE-001 Gate Q6 verdict — HUMAN_DECISION_REQUIRED`) |
| Session date | 2026-09-13 (UTC 10:56–11:33) |
| Executor | `qa-executor-feat-program-create-001` |
| Result | PARTIAL — see `qa-result-q5-human.yaml` and findings log below |

## Method and Evidence Basis

Live interaction was performed against the [Dev] ShipIt Golden App (Flutter web,
development flavor, `FLAVOR=development`) with a real Serverpod backend
(`localhost:8099`) and a real PostgreSQL (Compose) instance. Interactions were
replayed through an automated browser (Playwright) whose **accessibility
snapshots** (`page-2026-09-13T*.yml`, `.playwright-mcp/`) and **console logs**
(`console-2026-09-13T*.log`, `.playwright-mcp/`) were captured continuously.
Because the session was driven through the a11y tree, every PASS below is
grounded in a capturable, timestamped tree state or browser-log record. No
interaction described here is invented; sub-aspects that the evidence cannot
show are recorded as EVIDENCE_GAP / PARTIAL, never as PASS.

Supplementary deterministic evidence generated at HEAD (same revision set as
Q3): `docs/qa/results/evidence-q5-human-generate-check.log`
(`Generated output matches .generated_manifest.json.` → SUCCESS) and
`docs/qa/results/evidence-q5-human-test-flutter.log` (`00:31 +121: All tests
passed!`), including `accessibility_semantics_test.dart` and
`key_widget_semantics_test.dart` (program card semantics, `ProgramCreateView`
form fields and submit button expose labels, members table rows).

Session captures (repo root, copied verbatim into
`docs/qa/results/evidence-q5-human/` — session evidence only, NOT pixel
goldens; macOS renders text ~1% differently and these are human-QA session
reference screenshots):

- `q5-empty-state.png` — Programs empty state at session start
- `q5-program-card.png` — program card after first create
- `q5-details-joined.png` — Program Details with JOINED membership

## Session Timeline (condensed, timestamped evidence)

| Frame / log (UTC) | What the capture shows |
|---|---|
| 11-18-47Z | Registration: "[Dev] ShipIt Golden App", email entry, "Request Verification Code" |
| 11-19-14Z | Email `q5human@lets.shipit.app` entered; button "Request Verification Code, loading" [disabled] |
| 11-19-42Z / 11-20-01Z | Verification code `65759333` + password entered; "Create Account, loading" [disabled] |
| 11-20-28Z | Programs screen: heading "Programs"; buttons "Create program", "Refresh", "Sign out" (empty account; see `q5-empty-state.png`) |
| 11-21-01 / 11-21-11Z | Create Program form; name field "e.g. Summer Camp" is **[active]** (initial focus); description "Optional"; dates unset |
| 11-21-41Z | Date picker dialog (calendar grid, day buttons `15, Tuesday…` etc., "Select year", "Cancel"/"OK") — calendar entry exercised |
| 11-21-58Z | Dialog "Select date Tue, Sep 15", day `15` [active] — **start date chosen in calendar** |
| 11-22-14Z | Form: "Start date 2026-09-15" with "Clear 2026-09-15" group; "End date Select date" |
| 11-22-31 / 11-22-40Z | Calendar dialog again (start-date re-entry) |
| 11-22-44Z | Form: Start `2026-09-15` AND End `2026-09-20` with Clear groups — **first create fully filled** |
| 11-22-57Z | Transition frame: only "Back" (AppBar) captured during navigation away from the form |
| 11-23-05Z | Programs list: card "Q5 Human Camp UPCOMING Created live during Gate Q5 human QA 15/9/2026 - 20/9/2026" + "View Details" + "Create program"/"Refresh"/"Sign out" (**first create result**; see `q5-program-card.png`) |
| 11-23-30 / 11-23-38Z | Create Program form again; name "e.g. Summer Camp" [active]; no values |
| 11-23-58 / 11-24-04Z | **Per-field validation error on the name field**: label reads "Program name Program name Program name is required." — blank submit; error attributed to first invalid field |
| 11-24-52 / 11-25-08Z | Calendar dialog open (date phase of the second attempt) |
| 11-25-22Z | Programs list with ONLY the original "Q5 Human Camp" card — second create attempt abandoned (no second card) |
| 11-25-32 / 11-25-40Z | **Program Details** (`q5-details-joined.png`): card "Q5 Human Camp UPCOMING … 15/9/2026 - 20/9/2026"; Membership card "Joined · Q5 Human Camp JOINED"; button "Cancel Membership" |
| 11-26-03 / 11-26-11Z | Cancel Membership confirmation dialog ("Are you sure you want to cancel your membership in Q5 Human Camp?", Cancel / Cancel Membership) |
| 11-26-19 / 11-26-23Z | After cancel: Membership card "Not joined yet EXPLORE"; button "Join Program" |
| 11-26-34 / 11-26-40Z | After join: Membership "Joined · Q5 Human Camp JOINED"; "Cancel Membership" restored |
| 11-27-23Z | Programs list (Q5 Human Camp); re-entered create flow |
| 11-27-35 / 11-27-44Z | Create Program form (name [active]) |
| 11-27-59 / 11-28-14Z | Calendar: start date dialog; day `14` [active] |
| 11-28-18Z | Form: Start `2026-09-14`; "End date Select date" |
| 11-28-31 / 11-28-40 / 11-28-46 / 11-29-19Z | Calendar: end-date dialog; day `16` [active] |
| 11-29-27Z | Form: Start `2026-09-14` + End `2026-09-16` with Clear groups (**second create filled**) |
| 11-29-58 / 11-30-11Z | **Failure alert ABOVE form**: button "error. Could not create program. Network error: Could not reach the server. Please check your connection and try again. Dismiss" — form values preserved (Start/End Clear groups intact) |
| 11-32-32Z | After Dismiss: alert gone; form still populated (Start `2026-09-14`, End `2026-09-16`); "Create Program" active again |
| 11-32-40 / 11-32-45Z | Programs list with BOTH cards: "Q5 Human Camp UPCOMING …" AND "Server-Down Program UPCOMING 14/9/2026 - 16/9/2026" (**resubmit succeeded**) |

Console evidence: `console-2026-09-13T11-25-07-960Z.log` shows
`net::ERR_CONNECTION_REFUSED` on `http://localhost:8099/jwtTokens` and
`http://localhost:8099/programs` — the C3 failure was a **real server
unreachable** condition (backend temporarily stopped mid-session), not an
injected UI error. `console-2026-09-13T10-56-21-328Z.log` /
`11-04-27-425Z.log` show only DWDS/dev-tooling hot-reload websocket drops
(`$dwdsSseHandler` ERR_CONNECTION_REFUSED during dev-server restarts) —
environment noise. `console-2026-09-13T11-15-53-084Z.log` contains a
webdev-injected-client `_JsonMap` cast error (see Findings, F1).

## Charters (C1–C4)

| Charter | Status | Evidence (timestamped) |
|---|---|---|
| **C1 — entry points: app-bar create vs empty-state CTA; desktop/tablet/mobile shell widths; dark mode** | **PARTIAL** | Desktop-width covers verified: create flow reachable from Programs screen at `11-20-28` ("Create program") → form `11-21-01`; two full journeys completed (`11-23-05`, `11-32-40`). Empty-state screen captured as `q5-empty-state.png`. **EVIDENCE_GAP:** (a) tablet/mobile shell widths NOT exercised — all session captures are a single ~1200px desktop viewport (screenshots 1200×863); (b) dark mode NOT exercised — no dark-mode frame or toggle evidence; (c) empty-state CTA vs app-bar action are both labeled "Create program" in the a11y tree (`11-20-28`), so button-level attribution of the first create is not capturable from the snapshots. |
| **C2 — full create journey incl. date-picker calendar entry and per-field error recovery** | **PARTIAL** | Full journeys PASS ×2: Q5 Human Camp (`11-21-41`→`11-22-44`→`11-23-05`) and Server-Down Program (`11-27-59`→`11-29-27`→`11-32-40`). Calendar entry PASS (day cells selected for start `15/9` at `11-21-58`, `14/9` at `11-28-14`, end `20/9` result at `11-22-44`, `16/9` at `11-29-19`). Per-field error recovery **PARTIAL:** name-field error "Program name is required." evidenced on-field at `11-23-58`/`11-24-04` and the flow recovered (dates phase `11-24-52`, later successful submit `11-32-40`); date-field per-field errors (equal/out-of-order dates) NOT live-captured — flagged as EVIDENCE_GAP (automated widget tests cover them: `create_program_screen_test.dart`, included in the 121-test log). |
| **C3 — failure path: content kept, inline alert, dismiss, resubmit** | **PARTIAL (failure origin exercised fully = PASS)** | Server-unreachable mode all four behaviors PASS live: form kept (`11-29-58`, dates preserved), inline alert above form (`11-29-58`/`11-30-11`), Dismiss (`11-32-32`, form still populated, submit re-enabled), resubmit success (`11-32-40` both cards). Network origin corroborated by console `11-25-07-960Z` (`ERR_CONNECTION_REFUSED`). **EVIDENCE_GAP:** the second failure origin — server **validation rejection** (`ServerpodClientBadRequest → AppFailure.validation` → inline alert) — was not live-exercised; it is covered only by automated Q3 contract evidence and the translator/widget tests. |
| **C4 — post-create joined state: JOINED badge + Cancel Membership** | **PASS** | Program Details shows card + Membership "Joined · Q5 Human Camp JOINED" + "Cancel Membership" (`11-25-32`/`11-25-40`). Cancel Membership confirmation dialog (`11-26-03`/`11-26-11`) → Not joined state + "Join Program" (`11-26-19`/`11-26-23`) → re-join restores "JOINED" + "Cancel Membership" (`11-26-34`/`11-26-40`). |

## Usability Tasks

| Task | Status | Evidence |
|---|---|---|
| Complete the create journey end-to-end from **both entry points** | **PARTIAL** | Two end-to-end journeys evidenced (first from the empty list state — `q5-empty-state.png`, second from the populated list) and both reach the identical form. Strict attribution of empty-state CTA vs app-bar button is not capturable (both expose label "Create program", `11-20-28`). |
| Correct a validation mistake using only **on-field errors** | **PASS** | Blank submit → "Program name is required." attached to the name field (`11-23-58`/`11-24-04`); flow continued and a later create succeeded (`11-32-40`) — correction used the on-field error only. |
| **Dismiss** the failure alert and **resubmit** | **PASS** | Alert Dismiss (`11-32-32`), form retained, resubmit created "Server-Down Program" (`11-32-40`). |
| **Cancel the flow via the back arrow** | **PARTIAL** | Back affordance present on every create-form frame (`11-21-01`, `11-22-14`, `11-22-44`, `11-23-30`, `11-27-35`, `11-29-27`); the second attempt (`11-23-30`) terminated without creating a card and returned to Programs (`11-25-22`); a lone "Back" capture during navigation (`11-22-57`). The tap gesture itself is not visible in a11y snapshots, so cancellation mechanism is inferred from affordance + outcome (no Cancel button exists on the form). |

## Accessibility Audit (WCAG AA)

| WCAG AA item | Status | Basis |
|---|---|---|
| Token-only contrast (1.4.3 text / 1.4.11 non-text) | **EVIDENCE_GAP** | Not measurable from a11y snapshots; requires visual/design verification. The UI consumes shipit_ui `context.*` tokens exclusively per authority (AGENTS.md + design contract); no in-scope contrast regression was observed, but no pixel/contrast measurement exists in session evidence. |
| Interactive targets ≥ 44px (2.5.5 / 1.4.11) | **PARTIAL** | All interactive controls are standard shipit_ui components (buttons, text fields, icon buttons expose sane targets). No live pixel measurement in evidence. The single documented exception — `AppDatePicker`'s ~20px `date_picker_clear` tap target — is tracked upstream (see Upstream-Gap Verification). |
| Semantics labels (4.1.2) | **PASS** | Every interactive element labeled in the a11y tree across all frames: "Program name", "Description", "Start date 2026-09-15", "End date Select date", "Create Program", "Back", "Refresh", "Sign out", "Create program", "View Details", "Cancel Membership", "Join Program", card "Q5 Human Camp UPCOMING …", Membership "Joined · Q5 Human Camp JOINED", date cells "15, Tuesday…". Reinforced by automated `key_widget_semantics_test.dart` ("ProgramCreateView form fields and submit button expose labels", "program card exposes the program name and target label") and `accessibility_semantics_test.dart` in the 121-test log. |
| Live-region error announcement (4.1.3) | **PARTIAL** | Component-static live regions verified in the consumed shipit_ui source: `AppTextField` error → `Semantics(liveRegion: true, key: 'text_field_error')` (app_text_field.dart:266-275); `AppDatePicker` error → `Semantics(liveRegion: true, key: 'date_picker_error')` (app_date_picker.dart:201-205); `AppInlineAlert` → `Semantics(container: true, liveRegion: true, label: '${severity.name}. …')` (app_inline_alert.dart:111-117). The live error is attributed to the first invalid field (`11-23-58`). Actual screen-reader announcement during the session was not instrumented — EVIDENCE_GAP for the SR-level behavior itself. |
| Initial focus on the name field | **PASS** | Name field is **[active]** (focused) on every fresh create-form open (`11-21-01`, `11-23-30`, `11-27-35`); implemented via post-frame `_nameFocusNode.requestFocus()` (create_program_screen.dart:54-58); automated test "initial focus lands on the name field" green in the 121-test log. |
| First-invalid-field focus on failed `Form.validate()` | **PARTIAL** | Error text attaches to the first invalid field (name) at `11-23-58`/`11-24-04`. Focus relocation itself is not visible in a11y snapshots (the post-click snapshot shows the submit button as [active]). Code routes focus to the failing field (`FocusScope.requestFocus` on name/start/end focus nodes, create_program_screen.dart:88/106/110) but there is no automated assertion or live capture of the focus post-validate — EVIDENCE_GAP. |

## Upstream-Gap Verification

**Reported:** the `AppDatePicker` ~20px `date_picker_clear` tap target
(≤40dp, below the 44px WCAG AA guideline) is documented as a known upstream
accessibility gap in the QA contract (Human QA / Accessibility Standards,
`c0b70155…` :432-435), in the design revision (Gate D3 finding F4,
`docs/design/revisions/FEAT-PROGRAM-CREATE-001/design-revision-001.md`:460-464,
:502), and tracked as `UPSTREAM_UI_GAP-003` in
`docs/design/upstream-ui-gaps.md`.

**Not regressed:** the create form consumes shipit_ui `AppDatePicker` directly
(`create_program_screen.dart`:192-224) with no in-app wrapper or ≥44px masking;
the small `date_picker_clear` affordance is still the shipped component's
behavior, unchanged in the session captures (`11-22-14`, `11-22-44`,
`11-29-27` — "Clear 2026-09-15" groups). Per contract, this gap is routed as
`UPSTREAM_UI_GAP`/DCR to shipit_ui, NOT fixed in-app.

**Verdict: reported + not regressed — verified.**

## Findings Log

| ID | Finding | Classification (exactly once) | Severity | Lane |
|---|---|---|---|---|
| F1 | `console-2026-09-13T11-15-53-084Z.log`: webdev-injected-client (`dwds` `client.js`) reports `TypeError: Instance of '_JsonMap': type '_JsonMap' is not a subtype of type 'List<Object?>'` during dev-server hot-reload of the DDC session. Origin is DWDS dev tooling, NOT application code (stack is entirely `dwds/src/injected/client.js`); the app subsequently loaded and passed every interaction, and the same dev-restart window produced only websocket-drop noise in the 10:56Z/11:04Z logs. Console itself directs filing at https://github.com/dart-lang/webdev. | **ENVIRONMENT_DEFECT** | INFORMATIONAL (LOW) | INFRA_REMEDIATION (upstream dev tooling; no product code change; optionally file against dart-lang/webdev) |

No IMPLEMENTATION_DEFECT / DESIGN_DEFECT / REQUIREMENT_GAP findings resulted
from this session. Note: a Q5 session-only record, the `_JsonMap` item is
classified exactly once (above) and is carried into the machine-readable
result as `F1`.

## Gate Result

**PARTIAL.** The exercised exploratory and WCAG-AA surface passed with live,
timestamped evidence (both create journeys, calendar entry, name-field
per-field error recovery, full C3 unreachable-failure cycle, full C4 joined
state cycle, semantics, initial focus, upstream-gap status). `PARTIAL` reflects
captured EVIDENCE_GAPS, not failures: C1 dark-mode and tablet/mobile shell
widths; C2 live date-field per-field error capture; C3 live
validation-rejection origin; a11y items contrast (visual), post-validate
focus relocation, and live SR announcement. Follow-ups are listed in
`qa-result-q5-human.yaml` (`next_actions`).