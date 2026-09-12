# Upstream UI Gaps

Tracking components needed by Golden App that don't exist in shipit_ui.

> **Status of this document:** reviewed against shipit_ui revision `c310a961aa`
> (2026-09-12, the revision pinned in `apps/app/pubspec.yaml`). GAP-001 through
> GAP-008 shipped upstream and the Golden App now consumes the components (see
> **Resolved Gaps** below). GAP-009 (Inter font bundling), GAP-010 (AppTextField
> validation text), GAP-011 (dark mode), GAP-012 (AppTextButton /
> AppIconButton), the three token-level gaps (GAP-013 `icon.size.sm`,
> GAP-014 `text.weight.semibold`, GAP-015 `layout.maxWidth.form`) and
> GAP-016 (mobile bottom navigation) all shipped upstream — GAP-009 as
> [shipitinc/shipit-ui#8](https://github.com/shipitinc/shipit-ui/issues/8),
> GAP-010 as
> [shipitinc/shipit-ui#9](https://github.com/shipitinc/shipit-ui/issues/9),
> GAP-011 as
> [shipitinc/shipit-ui#10](https://github.com/shipitinc/shipit-ui/issues/10),
> GAP-012 as
> [shipitinc/shipit-ui#11](https://github.com/shipitinc/shipit-ui/issues/11),
> GAP-013 as
> [shipitinc/shipit-ui#12](https://github.com/shipitinc/shipit-ui/issues/12),
> GAP-014 as
> [shipitinc/shipit-ui#13](https://github.com/shipitinc/shipit-ui/issues/13),
> GAP-015 as
> [shipitinc/shipit-ui#14](https://github.com/shipitinc/shipit-ui/issues/14) and
> GAP-016 as
> [shipitinc/shipit-ui#15](https://github.com/shipitinc/shipit-ui/issues/15) —
> and the Golden App consumes all of them (real Inter in tests + regenerated
> baselines; form-field validation showcase; dark mode regression test;
> auth/household/programs buttons; token-backed icon size, font weight and
> form max-width; mobile bottom navigation in the app shell). See below.
>
> There are **no open upstream UI gaps**.

## Revision History

- `2026-09-08` — reviewed against `1207004` (static `AppColors` /
  `AppTypography` / `AppSpacing` / `AppRadius` / `AppBreakpoints` class API).
- `2026-09-09` — bumped to `d6abf9a` (token-tree refactor: token access moved
  to the `AppThemeContext` extension — `context.color.*`, `context.space.*`,
  `context.text.*`, `context.breakpoint.*`, etc. — static token classes were
  deleted; `shipitDarkTheme()` fixed, GAP-011 resolved). The Golden App
  migrated all token reads to the `context.*` surface.
- `2026-09-09` — bumped to `18d1a5d6` (GAP-012 resolved: `AppTextButton` and
  `AppIconButton` shipped in
  [shipitinc/shipit-ui#11](https://github.com/shipitinc/shipit-ui/issues/11),
  closing the last open component gap). The Golden App swapped the login-screen
  `TextButton`/`IconButton` workarounds and the household/programs app-bar
  `IconButton`s for the upstream components.
- `2026-09-10` — bumped to `526926d` (token-level gaps closed: `icon.size.sm`
  (#12), `text.weight.semibold` (#13) and `layout.maxWidth.form` (#14) shipped
  in `b6b7a16`/`526926d`). The Golden App replaced `kSmallIconSize` →
  `context.icon.size.sm`, `_labelWeight` → `context.font.weight.semibold` and
  `_authCardMaxWidth` → `context.layout.maxWidth.form`, and deleted the
  app-level constants (`ui_constants.dart` removed). All three token values are
  identical to the constants they replace (16 / w600 / 440, no raw literals
  introduced either way), so the rendered output — including the APPROVED login
  baselines — is unchanged.
- `2026-09-12` — bumped to `c310a961aa` (GAP-016 resolved:
  `AppBottomNavigationBar` shipped in
  [shipitinc/shipit-ui#15](https://github.com/shipitinc/shipit-ui/issues/15),
  closing the last open gap). The Golden App replaced the narrow-collapse shell
  fallback: `app/shell/app_shell.dart` now uses the rail for tablet/desktop
  widths and the new `AppBottomNavigationBar` in `Scaffold.bottomNavigationBar`
  for compact/mobile widths (no Material `NavigationBar`, no invented tab
  primitives). Covered by `test/features/navigation/app_shell_widget_test.dart`
  (mobile swap + bottom-bar branch switching). Pure additive component — no
  token changes, no re-renders, so the APPROVED login baselines are untouched
  under the new pin.

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

### UPSTREAM_UI_GAP-012: AppTextButton and AppIconButton variants
- **Desired Component**: `AppTextButton` (text/link-style button, e.g. "New
  here? Create an account") and `AppIconButton` (icon-only button, e.g. the
  back arrow on the register mode of the login screen and the refresh/sign-out
  actions in the household/programs app bars)
- **Reason**: shipit_ui v0.1.0 ships only `AppButton` (primary/secondary with
  optional icon); the Golden App login screen needs both variants but must not
  silently reimplement shipit_ui, so it fell back to raw Material
  `TextButton`/`IconButton` with `UPSTREAM_UI_GAP` comments
- **Recommended Owner**: shipit-ui
- **shipit_ui**: shipped in `18d1a5d6` (`AppTextButton`, `AppIconButton`,
  matching the `AppButton` conventions — `context.*` tokens, `AppButtonState`,
  `semanticLabel`, 44 px tap targets; mapped to approved Penpot boards
  `component/button/text` and `component/button/icon`)
- **Issue**: [shipitinc/shipit-ui#11](https://github.com/shipitinc/shipit-ui/issues/11) — closed
- **Status**: resolved 2026-09-09
- **Workaround**: removed — `login_screen.dart` uses `AppTextButton` (mode
  toggle) and `AppIconButton` (back arrow); `household_screen.dart` and
  `programs_screen.dart` use `AppIconButton` for the refresh and sign-out
  actions (replacing the raw `IconButton` + `AppTooltip` composition). Login
  golden baselines were regenerated and re-approved against
  `shipit_ui@18d1a5d6` via `goldens-update.yml` (recorded in
  `goldens_registry.md`; pending-actions.md #6 completed 2026-09-10).

### UPSTREAM_UI_GAP-013: icon-size token (`icon.size.sm`)
- **Desired Component**: small inline icons (calendar-today beside caption text)
  read their 16 px size from a token, not an app-level constant
- **Reason**: Golden App kept `kSmallIconSize` (16) as a named app constant
  because shipit_ui exposed no icon-size token
- **Recommended Owner**: shipit-ui
- **shipit_ui**: shipped in `b6b7a16`/`526926d` (`AppIconTokens.size.sm` = 16,
  `context.icon.size.sm`)
- **Issue**: [shipitinc/shipit-ui#12](https://github.com/shipitinc/shipit-ui/issues/12) — closed
- **Status**: resolved 2026-09-10
- **Workaround**: removed — `program_card.dart` and `household_header.dart` read
  `context.icon.size.sm`; `kSmallIconSize` and `ui_constants.dart` were deleted

### UPSTREAM_UI_GAP-014: font-weight token (`text.weight.semibold`)
- **Desired Component**: semibold emphasis (`w600`) read from a shipit_ui
  token instead of the `FontWeight.w600` constant on the status chip
- **Reason**: Golden App kept `_labelWeight` (`w600`) because no text token
  carried the emphasis (`context.text.label.*` resolves `w500`)
- **Recommended Owner**: shipit-ui
- **shipit_ui**: shipped in `526926d` (`AppFontWeightTokens.semibold` = `w600`,
  `context.font.weight.semibold`)
- **Issue**: [shipitinc/shipit-ui#13](https://github.com/shipitinc/shipit-ui/issues/13) — closed
- **Status**: resolved 2026-09-10
- **Workaround**: removed — `program_card.dart` `_StatusChip` reads
  `context.font.weight.semibold`; `_labelWeight` deleted

### UPSTREAM_UI_GAP-015: form max-width token (`layout.maxWidth.form`)
- **Desired Component**: the 440 px centered auth-card constraint read from a
  token instead of the app-level `_authCardMaxWidth`
- **Reason**: Golden App kept `_authCardMaxWidth` (440) because
  `pageWidth`/1200 and the breakpoints do not fit a form
- **Recommended Owner**: shipit-ui
- **shipit_ui**: shipped in `b6b7a16`/`526926d`
  (`AppLayoutMaxWidthTokens.form` = 440, `context.layout.maxWidth.form`)
- **Issue**: [shipitinc/shipit-ui#14](https://github.com/shipitinc/shipit-ui/issues/14) — closed
- **Status**: resolved 2026-09-10
- **Workaround**: removed — `login_screen.dart` reads
  `context.layout.maxWidth.form`; `_authCardMaxWidth` deleted

## Open Gaps

### UPSTREAM_UI_GAP-016: Mobile bottom navigation
- **Desired Component**: a shipit-token-styled bottom navigation bar for
  mobile/narrow screens (e.g. `AppBottomNavigationBar`)
- **Reason**: the Golden App shares authenticated screens through
  `app/shell/app_shell.dart` via GoRouter `StatefulShellRoute.indexedStack`
  with `AppNavigationRail`. At narrow widths (`< context.breakpoint.tablet`)
  the rail collapsed below with tooltips but remained a rail — there was no
  compact bottom bar, so mobile navigation of Household / Programs was
  degenerate
- **Recommended Owner**: shipit-ui
- **shipit_ui**: shipped in `c310a961aa` (`AppBottomNavigationBar` — same
  pill indicator, selected/unselected colors, `semibold` active label and
  44 px+ tap targets as the rail; consumes `context.*` tokens)
- **Issue**: [shipitinc/shipit-ui#15](https://github.com/shipitinc/shipit-ui/issues/15) — closed
- **Status**: resolved 2026-09-12
- **Golden App**: `app/shell/app_shell.dart` uses the rail for tablet/desktop
  layouts and `AppBottomNavigationBar` in `Scaffold.bottomNavigationBar` for
  compact/mobile widths (both primitives use the same `nav-household` /
  `nav-programs` semantics keys). Covered by
  `test/features/navigation/app_shell_widget_test.dart` (mobile swap, no rail,
  bottom-bar branch switching). The Material `NavigationBar` is never used.

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