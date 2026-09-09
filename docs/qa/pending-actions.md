# Pending Action Items

Open items tracked outside of issue trackers (not blockers; captured so they
are not lost between sessions).

| # | Item | Owning gate | Status |
|---|------|-------------|--------|
| 1 | Golden check runs with the real bundled Inter TTFs; candidate baselines were regenerated on the Linux CI host via the manual `.github/workflows/goldens-update.yml` and the qa `test` job is green. Local macOS runs intentionally show a known ~1% rasterizer diff (CoreText vs FreeType) on exactly the two golden tests — do NOT regenerate on macOS; use the workflow. Remaining: design/human review to promote `login_sign_in` / `login_register` from DESIGN_PENDING → APPROVED against an approved Penpot revision. | design/human approval | in progress |
| 2 | Dev environment: `localhost:8080` is owned by an unrelated `partnerhub-*` server. The golden server runs on `8099` via runtime env overrides (`SERVERPOD_API_SERVER_PORT=8099` + `SERVERPOD_API_SERVER_PUBLIC_*`) and the app via `--dart-define=API_BASE_URL=http://localhost:8099`. No committed port change — do not stop the partnerhub server. | ops note | informational |
| 3 | Optional: manual on-device pass of the form-field validation showcase (login/register + add-member) — currently covered by widget tests only. | QA | open |