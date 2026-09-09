# Upstream UI Gaps

Tracking components needed by Golden App that don't exist in shipit_ui.

> **Status of this document:** reviewed against shipit_ui revision `d6abf9a`
> (2026-09-09, the revision pinned in `apps/app/pubspec.yaml`). GAP-001 through
> GAP-008 shipped upstream and the Golden App now consumes the components (see
> **Resolved Gaps** below). GAP-009 (Inter font bundling), GAP-010 (AppTextField
> validation text) and GAP-011 (dark mode) all shipped upstream — GAP-009 as
> [shipitinc/shipit-ui#8](https://github.com/shipitinc/shipit-ui/issues/8),
> GAP-010 as
> [shipitinc/shipit-ui#9](https://github.com/shipitinc/shipit-ui/issues/9) and
> GAP-011 as
> [shipitinc/shipit-ui#10](https://github.com/shipitinc/shipit-ui/issues/10) —
> and the Golden App consumes all three (real Inter in tests + regenerated
> baselines; form-field validation showcase; dark mode regression test). See
> below.

## Revision History

- `2026-09-08` — reviewed against `1207004` (static `AppColors` /
  `AppTypography` / `AppSpacing` / `AppRadius` / `AppBreakpoints` class API).
- `2026-09-09` — bumped to `d6abf9a` (token-tree refactor: token access moved
  to the `AppThemeContext` extension — `context.color.*`, `context.space.*`,
  `context.text.*`, `context.breakpoint.*`, etc. — static token classes were
  deleted; `shipitDarkTheme()` fixed, GAP-011 resolved). The Golden App
  migrated all token reads to the `context.*` surface.

## Resolved Gaps

These gaps shipped in shipit_ui and the Golden App migrated to the upstream
components. The `shipit_ui` column records the commit that closed the gap
within the revision range `2a916a5..1207004`.

### UPSTREAM_UI_GAP-001: AppNavigationRail
- **Desired Component**: Navigation rail for desktop/tablet layouts
- **Reason**: Reusable cross-product navigation primitive for responsive layouts
- **Recommended Owner**: shipit-ui
- **shipit_ui**: shipped in `7ca6189` (`AppNavigationRail`)
- **Issue**: [shipitinc/shipit-ui#1](https://github.com/shipitinc/shipit-ui/issues/1) — closed
- **Workaround**: Using `NavigationRail` from Material with shipit_ui styling

### UPSTREAM_UI_GAP-002: AppDataTable
- **Desired Component**: Sortable, filterable data table with pagination
- **Reason**: Program listing, member management tables
- **Recommended Owner**: shipit-ui
- **shipit_ui**: shipped in `7bf293b` (`AppDataTable`)
- **Issue**: [shipitinc/shipit-ui#2](https://github.com/shipitinc/shipit-ui/issues/2) — closed
- **Workaround**: `ListView` with `AppCard` items

### UPSTREAM_UI_GAP-003: AppDatePicker
- **Desired Component**: Date range picker with presets
- **Reason**: Program date selection, filtering
- **Recommended Owner**: shipit-ui
- **shipit_ui**: shipped in `7bf293b` (`AppDatePicker`)
- **Issue**: [shipitinc/shipit-ui#3](https://github.com/shipitinc/shipit-ui/issues/3) — closed
- **Workaround**: `showDatePicker` with custom styling

### UPSTREAM_UI_GAP-004: AppAvatar
- **Desired Component**: User avatar with fallback initials, badges
- **Reason**: Household member display, user profile
- **Recommended Owner**: shipit-ui
- **shipit_ui**: shipped in `7bf293b` (`AppAvatar`)
- **Issue**: [shipitinc/shipit-ui#4](https://github.com/shipitinc/shipit-ui/issues/4) — closed
- **Workaround**: Custom `CircleAvatar` with initials

### UPSTREAM_UI_GAP-005: AppEmptyState
- **Desired Component**: Empty-state view that *replaces* a content area
- **Reason**: `AppStateView.empty` used to be the only empty state; the
  loading/error variants were removed from `AppStateView`
- **Recommended Owner**: shipit-ui
- **shipit_ui**: superseded by the `AppStateView` split in `e5648e0`
  (`AppEmptyState`, `AppSkeleton`, `AppInlineAlert`)
- **Issue**: — closed via the `AppStateView` split
- **Workaround**: `AppStateView.empty` / `.loading` / `.error`

### UPSTREAM_UI_GAP-006: AppSearchField
- **Desired Component**: Search input with clear, filter chips, recent searches
- **Reason**: Program search, member search
- **Recommended Owner**: shipit-ui
- **shipit_ui**: shipped in `7bf293b` (`AppSearchField`, `AppFilterChip`)
- **Issue**: [shipitinc/shipit-ui#5](https://github.com/shipitinc/shipit-ui/issues/5) — closed
- **Workaround**: `AppTextField` with search icon

### UPSTREAM_UI_GAP-007: AppConfirmDialog (generic confirm variant)
- **Desired Component**: Standardized **non-destructive** confirmation dialog
  (the destructive variant exists as `AppDialog.error`)
- **Reason**: Logout/changes confirmation without error styling
- **Recommended Owner**: shipit-ui
- **shipit_ui**: shipped in `7bf293b` (`AppConfirmDialog` — generic + destructive)
- **Issue**: [shipitinc/shipit-ui#6](https://github.com/shipitinc/shipit-ui/issues/6) — closed
- **Workaround**: `AppDialog.error` with a neutral confirm label

### UPSTREAM_UI_GAP-008: AppTooltip
- **Desired Component**: Accessible tooltip with rich content support
- **Reason**: Icon-only buttons, truncated text (sign-out button)
- **Recommended Owner**: shipit-ui
- **shipit_ui**: shipped in `7ca6189` (`AppTooltip`, `AppTooltip.rich`)
- **Issue**: [shipitinc/shipit-ui#7](https://github.com/shipitinc/shipit-ui/issues/7) — closed
- **Workaround**: `Tooltip` widget from Material (token styling lost)

### UPSTREAM_UI_GAP-009: Inter font not bundled by shipit_ui
- **Desired Component**: `Inter` TTF bundled/declared in shipit_ui
  `AppTypography.fontFamily`
- **Reason**: Golden App test harness pinned the `Inter` family to
  golden_toolkit's Roboto (`apps/app/flutter_test_config.dart`) as a stand-in
  and production fell back to the platform default because neither shipit_ui
  nor the app shipped the font asset
- **Recommended Owner**: shipit-ui
- **shipit_ui**: bundling shipped in `5d6b34a` (issue closed)
- **Status**: resolved upstream — [shipitinc/shipit-ui#8](https://github.com/shipitinc/shipit-ui/issues/8) closed
- **Golden App**: `flutter_test_config.dart` now loads the real bundled Inter
  TTFs under `packages/shipit_ui/Inter`; the candidate login baselines were
  regenerated with real Inter (see `goldens_registry.md`) and verified by
  Linux CI. Nothing pending.

### UPSTREAM_UI_GAP-010: AppTextField does not surface validation text
- **Desired Component**: `AppTextField` integrating with Flutter `Form`
  (validator actually enforced) and a parameter for a custom validation
  message (`errorText`), instead of only the hardcoded
  "Error: Please check this field"
- **Reason**: Golden App's auth and add-member forms pass `validator`s today
  but no validation was ever shown (the field used to be a plain `TextField`
  wrapping the validator as dead data), and no custom `errorText` existed, so
  field-level form validation could not be showcased
- **Recommended Owner**: shipit-ui
- **shipit_ui**: shipped in `2e6d491` — `AppTextField` is now a real
  `FormField` (validator runs on `Form.validate()`/save and per
  `autovalidateMode`) with an `errorText` parameter that takes precedence
- **Issue**: [shipitinc/shipit-ui#9](https://github.com/shipitinc/shipit-ui/issues/9) — closed
- **Workaround**: superseded — auth & household add-member forms already pass
  validators inside a `Form`; the upgrade activates per-field error messages
  with no code change

### UPSTREAM_UI_GAP-011: shipitDarkTheme() broken (light surfaces + white text)
- **Desired Component**: `shipitDarkTheme()` that renders genuinely dark surfaces
  with high-contrast text, via dark-adapted semantic tokens
- **Reason**: Dark mode in the Golden App was broken — `shipitDarkTheme()`
  reused the static light `AppColors` for scaffold/card/appbar/input surfaces
  (`bgBaseColor` `#F8FAFC`, `bgSubtleColor` `#F1F5F9`) while `darkTextTheme`
  painted text white, so surfaces stayed light and text became nearly invisible.
  Only M3-dark-`ColorScheme`-driven parts (icons, primaries) responded, matching
  the observed "only icons adapt" symptom
- **Recommended Owner**: shipit-ui
- **Issue**: [shipitinc/shipit-ui#10](https://github.com/shipitinc/shipit-ui/issues/10) — closed
- **Status**: resolved in `d6abf9a` (token-tree refactor) — `AppTheme.dark`
  paints dark surfaces (`bg.base` `#020617`) with high-contrast text
  (`fg.primary` `neutral50`); the Golden App consumes it with a regression test
  (`test/theme/dark_mode_test.dart`) asserting genuinely dark scaffolds and
  WCAG AA body-text contrast, and `flutter_test_config.dart` loads fonts via
  `AppTheme.light.font.resolvedFamily`
- **Workaround**: none required — surfaces/text read from `MaterialApp` themes
  (`shipitLightTheme`/`shipitDarkTheme`) with no app-side override; dark-token
  values trace to approved Penpot dark tokens via shipit_ui maintained tokens

## Reporting Process

When discovering a gap:

1. **Check shipit_ui** — Verify component doesn't exist
2. **Assess reusability** — Generic vs product-specific
3. **Create entry** — Add to this file
4. **Report upstream** — File issue in shipit-ui repo (add the `issue` link)
5. **Document workaround** — Mark as DESIGN_PENDING in code
6. **Track status** — Update status/issue fields; move to "Superseded" when upstream ships

## Template

```markdown
### UPSTREAM_UI_GAP-XXX: ComponentName
- **Desired Component**: Brief description
- **Reason**: Why Golden App needs it
- **Recommended Owner**: shipit-ui or product
- **Status**: not reported / reported / in progress / shipped
- **Workaround**: Current implementation approach
- **Priority**: high / medium / low
```