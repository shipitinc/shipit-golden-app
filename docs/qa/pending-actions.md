# Pending Action Items

Open items tracked outside of issue trackers (not blockers; captured so they
are not lost between sessions).

| # | Item | Owning gate | Status |
|---|------|-------------|--------|
| 1 | Automatic golden check now runs with the real bundled Inter TTFs (`flutter_test_config.dart` loads `packages/shipit_ui` Inter); the candidate login baselines were regenerated with Inter and the full suite is green on macOS. Remaining: confirm the Linux CI `test` job stays green, then promote `login_sign_in` / `login_register` from DESIGN_PENDING → APPROVED against an approved Penpot revision. | design/human approval + Linux CI | in progress |
| 2 | Dev environment: `localhost:8080` is owned by an unrelated `partnerhub-*` server. The golden server runs on `8099` via runtime env overrides (`SERVERPOD_API_SERVER_PORT=8099` + `SERVERPOD_API_SERVER_PUBLIC_*`) and the app via `--dart-define=API_BASE_URL=http://localhost:8099`. No committed port change — do not stop the partnerhub server. | ops note | informational |
| 3 | Optional: manual on-device pass of the form-field validation showcase (login/register + add-member) — currently covered by widget tests only. | QA | open |