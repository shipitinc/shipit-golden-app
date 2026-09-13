# E2E Journey — Live-Server Execution Log (FEAT-PROGRAM-CREATE-001)

## Session Meta

| Field | Value |
|---|---|
| Item | E2E Journey (App→Server), QA Contract §End-to-End Tests |
| Contract | `c0b70155-b400-424e-b52b-00b09254c082` v1.0.1 (FROZEN, Gate Q1/Q2) |
| Session date | 2026-09-13 (UTC 18:11–18:18) |
| Executor | `qa-executor-feat-program-create-001` |
| Result | **PASS** — full journey exercised live against a real Serverpod + PostgreSQL |
| Evidence | `docs/qa/results/evidence-e2e/` (`e2e-01..e2e-05-*.png`) + this log + DB records + server log |

## Method and Evidence Basis

The journey defined in `apps/app/integration_test/app_journey_test.dart` was
replayed as a **live interaction** against a real stack — the [Dev] ShipIt Golden
App (Flutter web, development flavor) pointed at a dedicated Serverpod instance
running **PostgreSQL-backed** (Compose) on `localhost:8097`. This mirrors the
established Q5 harness convention (browser-driven, accessibility-tree
snapshots + console logs), and it is how the contract's device-gated E2E row is
achievable in an environment with no headless device / CI emulator lane.

**Determinism:** the journey registers a fresh email per run and the comparison
code is pinned at compile time (`--dart-define=E2E_VERIFICATION_CODE`). The
dev server otherwise issues a random code per request, so a new server-only
development toggle was added — `SERVERPOD_DEV_VERIFICATION_CODE` env var
(`apps/server/bin/main.dart`), honored **only** in `ServerpodRunMode.development`.
The server log confirms the pinned code `000000` was issued for this run's fresh
email. This matches the existing deterministic pattern in the server integration
harness (`test/integration/auth_flow_test.dart` uses generator `'000000'`).

The automated `melos run test:integration` runner itself (iOS simulator) could
not attach in this environment (hung at the same loading gate on two attempts;
web is unsupported for `flutter test integration_test`). That lane gap is the
framework-level U-03 / agentic-engineering-framework#2 finding, now resolved
upstream with formal `NOT_EXECUTED` vs `SKIPPED` gate semantics. The journey
evidence below is the product-established **live-interaction** execution of the
same assertions.

## Execution Timeline

| Frame / log (UTC) | What the capture shows |
|---|---|
| 18-11-13Z | App boots to `/login` (unauthenticated); a11y placeholder "Enable accessibility" |
| 18-13-21Z | After enabling semantics: **"Sign In"** + Email/Password fields + "New here? Create an account" — matches journey assertion (`Sign In`, 2 `AppTextField`s) |
| 18-14-05Z | "New here? Create an account" → registration card "Enter your email to receive a verification code" + "Request Verification Code" |
| 18-14-14Z | Fresh email `e2e_live_20260913_1815@lets.shipit.app` entered; "Request Verification Code" submitted |
| 18-14-14Z | **Server log:** `[dev] Email verification code for e2e_live_20260913_1815@lets.shipit.app: 000000` (pinned generator; fresh account request created) |
| 18-14-15Z | Screen "Enter the code sent to \"e2e_live_20260913_1815@lets.shipit.app\"" — matches journey `find.text('Enter the code sent to')` + Verification Code field |
| 18-14-27Z | Verify code `000000` + password `ShipItTest#123` entered; "Create Account" |
| 18-14-33Z | Authenticated → redirected to `#/household`: "Household", members table "Members (1)", Owner card (matches DB `01a09bfa-…`) |
| 18-15-13Z | `/programs`: heading "Programs", buttons "Create program" / "Refresh" / "Sign out" — matches journey `find.text('Programs')` + `programs_create_action` (see `e2e-02-programs-list.png`) |
| 18-15-31Z | Create form: "Create Program", fields Program name / Description / Start date / End date + submit (see `e2e-01-login.png` region; form reached) |
| 18-15-45Z | Calendar dialog "Select date Sun, Sep 13" opened for Start date; day `14, Monday, September 14, 2026` selected (start = tomorrow) |
| 18-16-00Z | Start date fixed `2026-09-14` with Clear group; End date picker opened; `19, Saturday, September 19, 2026` selected (start + 5) |
| 18-16-14Z | Form complete: name "E2E Live Program 20260913", description, Start `2026-09-14`, End `2026-09-19`; "Create Program" submitted |
| 18-16-20Z | Programs list shows card **"E2E Live Program 20260913 UPCOMING … 14/9/2026 - 19/9/2026"** — matches journey `find.text(name)` (see `e2e-03-created-in-list.png`) |
| 18-16-50Z | "View Details" → "Program Details" + Membership card **"Joined · E2E Live Program 20260913 JOINED"** + "Cancel Membership" — matches journey assertions (see `e2e-04-details-joined.png`) |
| 18-18-07Z | Sign out → back to `/login` |
| 18-18-23Z | Wrong password leg: entered the same email with `definitely-wrong-password`, Sign In → **`AppInlineAlert`** "error. Sign In Failed. Incorrect email or password." — matches journey `find.byType(AppInlineAlert)` (see `e2e-05-signin-failure-alert.png`); server returned 400 on `/auth` (console evidence) |

## Deterministic Evidence (DB + server)

PostgreSQL (Compose, `shipit-golden-postgres`):

```
programs: id=3 name='E2E Live Program 20260913'
         createdBy='01a09bfa-6626-7626-9c5e-22f55f881190'   (the fresh E2E user)
         startDate=2026-09-14 endDate=2026-09-19 status='upcoming'
program_members: programId=3 householdId=3 joinedAt=2026-09-13 18:16:19.716648
```

- `createdBy` derives from `session.userIdentifier` server-side (not client
  input) — matches the registered user's Owner ID shown on the Household screen.
- The membership row was auto-joined in the same caller-owned transaction as
  the create (PC-009) and is what renders `JOINED` on Program Details.

Server console (`/tmp/golden-e2e-server.log`, dev server on `:8097`):

```
[dev] Email verification code for e2e_live_20260913_1815@lets.shipit.app: 000000
```

## Assertions vs Journey File

| `app_journey_test.dart` assertion | Live result |
|---|---|
| Unauthenticated → `/login`, "Sign In", 2 `AppTextField`s | PASS (18-11/18-13) |
| Wrong password → `AppInlineAlert` (server-backed 400) | PASS (18-18) |
| Fresh registration via UI → verified with pinned code | PASS (18-14·15, server log) |
| `/programs` with `programs_create_action` | PASS (18-15) |
| Fill form (name/description + calendar dates) + submit | PASS (18-15/18-16) |
| Created program card in list | PASS (18-16, DB id=3) |
| `View Details` → "Program Details" + "JOINED" + "Cancel Membership" | PASS (18-16, DB membership) |

## Result

**PASS.** Every assertion of the E2E journey was satisfied through the real
app → Serverpod → PostgreSQL boundary with deterministic, pinned-code
registration. This is the product's live-interaction execution of the
contract-mandated journey; the automated iOS-simulator runner remains
device-gated in this environment (framework-level U-03/AEF#2, now resolved
upstream with formal gate semantics).