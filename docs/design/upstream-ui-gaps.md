# Upstream UI Gaps

Tracking components needed by Golden App that don't exist in shipit_ui.

> **Status of this document:** reviewed against shipit_ui revision
> `2a916a551ed4d7bcf72c9159466db00e6bb199ce` (2026-09-06, the revision pinned in
> `apps/app/pubspec.yaml`). Gaps are reported as GitHub issues in the
> [shipitinc/shipit-ui](https://github.com/shipitinc/shipit-ui) repository so the
> design system can process them; the `issue` column links each report.

## Superseded Gaps

These gaps were resolved by components that now exist in shipit_ui. Keep the
entries so the history is legible, but do not file new issues for them.

- **UPSTREAM_UI_GAP-005 (AppEmptyState)** — superseded by `AppStateView.empty`
  (`AppEmptyState` and loading/error variants are all covered by
  `AppStateView.loading` / `.empty` / `.error`).
- **UPSTREAM_UI_GAP-007 (AppConfirmDialog)** — partially superseded by
  `AppDialog.error` (destructive Cancel/Delete confirm). The remaining gap is a
  **generic (non-destructive)** confirm variant; see issue #6 below.

## Reported Gaps

### UPSTREAM_UI_GAP-001: AppNavigationRail
- **Desired Component**: Navigation rail for desktop/tablet layouts
- **Reason**: Reusable cross-product navigation primitive for responsive layouts
- **Recommended Owner**: shipit-ui
- **Status**: reported — [shipitinc/shipit-ui#1](https://github.com/shipitinc/shipit-ui/issues/1)
- **Workaround**: Using `NavigationRail` from Material with shipit_ui styling

### UPSTREAM_UI_GAP-002: AppDataTable
- **Desired Component**: Sortable, filterable data table with pagination
- **Reason**: Program listing, member management tables
- **Recommended Owner**: shipit-ui
- **Status**: reported — [shipitinc/shipit-ui#2](https://github.com/shipitinc/shipit-ui/issues/2)
- **Workaround**: `ListView` with `AppCard` items

### UPSTREAM_UI_GAP-003: AppDatePicker
- **Desired Component**: Date range picker with presets
- **Reason**: Program date selection, filtering
- **Recommended Owner**: shipit-ui
- **Status**: reported — [shipitinc/shipit-ui#3](https://github.com/shipitinc/shipit-ui/issues/3)
- **Workaround**: `showDatePicker` with custom styling

### UPSTREAM_UI_GAP-004: AppAvatar
- **Desired Component**: User avatar with fallback initials, badges
- **Reason**: Household member display, user profile
- **Recommended Owner**: shipit-ui
- **Status**: reported — [shipitinc/shipit-ui#4](https://github.com/shipitinc/shipit-ui/issues/4)
- **Workaround**: Custom `CircleAvatar` with initials

### UPSTREAM_UI_GAP-006: AppSearchField
- **Desired Component**: Search input with clear, filter chips, recent searches
- **Reason**: Program search, member search
- **Recommended Owner**: shipit-ui
- **Status**: reported — [shipitinc/shipit-ui#5](https://github.com/shipitinc/shipit-ui/issues/5)
- **Workaround**: `AppTextField` with search icon

### UPSTREAM_UI_GAP-007: AppConfirmDialog (generic confirm variant)
- **Desired Component**: Standardized **non-destructive** confirmation dialog
  (the destructive variant exists as `AppDialog.error`)
- **Reason**: Logout/changes confirmation without error styling
- **Recommended Owner**: shipit-ui
- **Status**: reported — [shipitinc/shipit-ui#6](https://github.com/shipitinc/shipit-ui/issues/6)
- **Workaround**: `AppDialog.error` with a neutral confirm label

### UPSTREAM_UI_GAP-008: AppTooltip
- **Desired Component**: Accessible tooltip with rich content support
- **Reason**: Icon-only buttons, truncated text (sign-out button)
- **Recommended Owner**: shipit-ui
- **Status**: reported — [shipitinc/shipit-ui#7](https://github.com/shipitinc/shipit-ui/issues/7)
- **Workaround**: `Tooltip` widget from Material (token styling lost)

### UPSTREAM_UI_GAP-009: Inter font not bundled by shipit_ui
- **Desired Component**: `Inter` TTF bundled/declared in shipit_ui
  `AppTypography.fontFamily`
- **Reason**: Golden App test harness pins the `Inter` family to
  golden_toolkit's Roboto (`apps/app/flutter_test_config.dart`) and production
  web falls back to the platform default because neither shipit_ui nor the app
  ships the font asset
- **Recommended Owner**: shipit-ui
- **Status**: not yet reported
- **Workaround**: `flutter_test_config.dart` `FontLoader('Inter')` → Roboto TTF
  in golden tests; production web renders with a default fallback

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