# Pending Action Items

Open items tracked outside of issue trackers (not blockers; captured so they
are not lost between sessions).

| # | Item | Owning gate | Status |
|---|------|-------------|--------|
| 1 | Golden check runs with the real bundled Inter TTFs; candidate baselines were regenerated on the Linux CI host via the manual `.github/workflows/goldens-update.yml` and promoted to APPROVED by design/human sign-off on 2026-09-08 (design revision `shipit_ui@1207004`). Local macOS runs intentionally show a known ~1% rasterizer diff (CoreText vs FreeType) on exactly the two golden tests — do NOT regenerate on macOS; use the workflow with `design_revision` + `reviewer` inputs. | design/human approval | completed 2026-09-08 |
| 2 | Dev environment: `localhost:8080` is owned by an unrelated `partnerhub-*` server. The golden server runs on `8099` via runtime env overrides (`SERVERPOD_API_SERVER_PORT=8099` + `SERVERPOD_API_SERVER_PUBLIC_*`) and the app via `--dart-define=API_BASE_URL=http://localhost:8099`. No committed port change — do not stop the partnerhub server. | ops note | informational |
| 3 | Form-field validation showcase (login/register + add-member per-field errors) approved by design/human on 2026-09-08; covered by widget tests (`authentication_flow_widget_test.dart`, `add_member_dialog_test.dart`). Manual on-device pass optional for any future visual QA. | QA | completed 2026-09-08 |
| 4 | Dark mode was broken in shipit_ui (`shipitDarkTheme()` used static light surfaces with white text). Documented as UPSTREAM_UI_GAP-011 and reported as shipitinc/shipit-ui#10 (2026-09-08); fixed upstream in the token-tree refactor (`shipit_ui@d6abf9a`). Golden App bumped the pin, migrated all token reads to the `context.*` API (`AppThemeContext`), and added a dark-mode regression test (`test/theme/dark_mode_test.dart`: genuinely dark scaffolds + WCAG AA body-text contrast). No app-side override kept. | shipit-ui upstream | completed 2026-09-09 |