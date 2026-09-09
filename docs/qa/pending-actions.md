# Pending Action Items

Open items tracked outside of issue trackers (not blockers; captured so they
are not lost between sessions).

| # | Item | Owning gate | Status |
|---|------|-------------|--------|
| 1 | Regenerate golden baselines on Linux (CI host) after the shipit_ui `1207004` upgrade: swap the `flutter_test_config.dart` Roboto font pin for the real bundled Inter TTFs, regenerate `login_sign_in` / `login_register` (and any other candidate baselines), and obtain DESIGN_PENDING → APPROVED per AEF. Clears the two pre-existing macOS-only golden failures and completes the remaining GAP-009 step. | design/human approval + Linux host | open |
| 2 | Dev environment: `localhost:8080` is owned by an unrelated `partnerhub-*` server. The golden server runs on `8099` via runtime env overrides (`SERVERPOD_API_SERVER_PORT=8099` + `SERVERPOD_API_SERVER_PUBLIC_*`) and the app via `--dart-define=API_BASE_URL=http://localhost:8099`. No committed port change — do not stop the partnerhub server. | ops note | informational |
| 3 | Optional: manual on-device pass of the form-field validation showcase (login/register + add-member) — currently covered by widget tests only. | QA | open |