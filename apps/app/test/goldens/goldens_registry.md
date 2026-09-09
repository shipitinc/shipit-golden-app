# Golden Baselines Registry

Status values:
- `DESIGN_PENDING` — candidate baseline preserving current rendering; NOT yet
  approved by design. Regeneration is allowed but must be recorded here.
- `APPROVED` — reviewed and approved against an approved Penpot revision.
  NEVER regenerate silently; any change requires design/human approval and a
  registry update.

| File | Screen | Status | Design revision | Notes |
|------|--------|--------|-----------------|-------|
| `goldens/login_sign_in.png` | LoginScreen (sign in) | DESIGN_PENDING | (none) | Auth screen, shipit_ui components. Baseline rendered with the real bundled Inter TTFs (`flutter_test_config.dart` loads `packages/shipit_ui` Inter under the resolved family `packages/shipit_ui/Inter`); deterministic across hosts and verified by CI (Linux). Regenerated during the shipit_ui `1207004` migration (real `FormField` validation + Inter font bundling) after previously being captured with golden_toolkit's Roboto as a font stand-in. |
| `goldens/login_register.png` | LoginScreen (register) | DESIGN_PENDING | (none) | Register/request-code mode. Baseline rendered with the real bundled Inter TTFs (`flutter_test_config.dart` loads `packages/shipit_ui` Inter under the resolved family `packages/shipit_ui/Inter`); deterministic across hosts and verified by CI (Linux). Regenerated during the shipit_ui `1207004` migration (real `FormField` validation + Inter font bundling) after previously being captured with golden_toolkit's Roboto as a font stand-in. |

## Policy (enforced by `test/goldens/golden_policy_test.dart`)

1. Baselines exist for each listed screen and preserve current rendered output,
   so visual regressions fail CI with a diff instead of silently disappearing.
2. All baselines are `DESIGN_PENDING` until reviewed against an approved Penpot
   revision. Promoting to `APPROVED` references that revision in this table.
3. Regenerating a baseline (`fvm flutter test test/goldens --update-goldens`)
   is captured by the golden diff in CI and must be accompanied by a registry
   update describing the change and its design authority.