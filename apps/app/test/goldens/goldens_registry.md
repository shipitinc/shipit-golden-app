# Golden Baselines Registry

Status values:
- `DESIGN_PENDING` — candidate baseline preserving current rendering; NOT yet
  approved by design. Regeneration is allowed but must be recorded here.
- `APPROVED` — reviewed and approved against an approved Penpot revision.
  NEVER regenerate silently; any change requires design/human approval and a
  registry update.

| File | Screen | Status | Design revision | Notes |
|------|--------|--------|-----------------|-------|
| `goldens/login_sign_in.png` | LoginScreen (sign in) | APPROVED | shipit_ui@d6abf9a | Auth screen, shipit_ui components (approved design source per `product.yaml` `design.source: penpot`, implemented by the pinned shipit_ui revision). First promoted to APPROVED on 2026-09-08 against `shipit_ui@1207004`; re-approved on 2026-09-09 against `shipit_ui@d6abf9a` (the token-tree refactor migration re-renders these screens — regenerated on the Linux CI host via `.github/workflows/goldens-update.yml`, reviewer tariq). Baseline is rendered on the Linux CI host (authoritative golden runner) with the real bundled Inter TTFs; local macOS runs intentionally show a known ~1% rasterizer diff (CoreText vs FreeType) — never regenerate on macOS. REGENERATION REQUIRES design/human approval + registry update in the same commit. |
| `goldens/login_register.png` | LoginScreen (register) | APPROVED | shipit_ui@d6abf9a | Register/request-code mode. Auth screen, shipit_ui components (approved design source per `product.yaml` `design.source: penpot`, implemented by the pinned shipit_ui revision). First promoted to APPROVED on 2026-09-08 against `shipit_ui@1207004`; re-approved on 2026-09-09 against `shipit_ui@d6abf9a` (the token-tree refactor migration re-renders these screens — regenerated on the Linux CI host via `.github/workflows/goldens-update.yml`, reviewer tariq). Baseline is rendered on the Linux CI host (authoritative golden runner) with the real bundled Inter TTFs; local macOS runs intentionally show a known ~1% rasterizer diff (CoreText vs FreeType) — never regenerate on macOS. REGENERATION REQUIRES design/human approval + registry update in the same commit. |

## Policy (enforced by `test/goldens/golden_policy_test.dart`)

1. Baselines exist for each listed screen and preserve current rendered output,
   so visual regressions fail CI with a diff instead of silently disappearing.
2. Every listed baseline carries a valid status: `DESIGN_PENDING` (candidate
   preserving current rendering) or `APPROVED` (reviewed and approved against an
   approved design revision, referenced in the table). An `APPROVED` baseline
   MUST reference a non-empty design revision.
3. Regenerating a baseline (`fvm flutter test test/goldens --update-goldens`)
   is captured by the golden diff in CI and must be accompanied by a registry
   update describing the change and its design authority:
   - `DESIGN_PENDING`: regeneration is allowed but must be recorded here.
   - `APPROVED`: NEVER regenerate silently — required steps are
     design authority approval, the corresponding design revision, and an
     updated golden + registry update in the same commit.