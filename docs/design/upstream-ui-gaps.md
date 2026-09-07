# Upstream UI Gaps

Tracking components needed by Golden App that don't exist in shipit_ui.

## Reported Gaps

### UPSTREAM_UI_GAP-001: AppNavigationRail
- **Desired Component**: Navigation rail for desktop/tablet layouts
- **Reason**: Reusable cross-product navigation primitive for responsive layouts
- **Recommended Owner**: shipit-ui
- **Status**: Not yet reported
- **Workaround**: Using `NavigationRail` from Material with shipit_ui styling

### UPSTREAM_UI_GAP-002: AppDataTable
- **Desired Component**: Sortable, filterable data table with pagination
- **Reason**: Program listing, member management tables
- **Recommended Owner**: shipit-ui
- **Status**: Not yet reported
- **Workaround**: `ListView` with `AppCard` items

### UPSTREAM_UI_GAP-003: AppDatePicker
- **Desired Component**: Date range picker with presets
- **Reason**: Program date selection, filtering
- **Recommended Owner**: shipit-ui
- **Status**: Not yet reported
- **Workaround**: `showDatePicker` with custom styling

### UPSTREAM_UI_GAP-004: AppAvatar
- **Desired Component**: User avatar with fallback initials, badges
- **Reason**: Household member display, user profile
- **Recommended Owner**: shipit-ui
- **Status**: Not yet reported
- **Workaround**: Custom `CircleAvatar` with initials

### UPSTREAM_UI_GAP-005: AppEmptyState
- **Desired Component**: Standardized empty state illustration + message + action
- **Reason**: Empty programs, empty household members
- **Recommended Owner**: shipit-ui
- **Status**: Not yet reported
- **Workaround**: Custom `Column` with icon + text + button

### UPSTREAM_UI_GAP-006: AppSearchField
- **Desired Component**: Search input with clear, filter chips, recent searches
- **Reason**: Program search, member search
- **Recommended Owner**: shipit-ui
- **Status**: Not yet reported
- **Workaround**: `AppTextField` with search icon

### UPSTREAM_UI_GAP-007: AppConfirmDialog
- **Desired Component**: Standardized confirmation dialog with destructive variant
- **Reason**: Delete member, logout confirmation
- **Recommended Owner**: shipit-ui
- **Status**: Not yet reported
- **Workaround**: `AppDialog` with custom actions

### UPSTREAM_UI_GAP-008: AppTooltip
- **Desired Component**: Accessible tooltip with rich content support
- **Reason**: Icon-only buttons, truncated text
- **Recommended Owner**: shipit-ui
- **Status**: Not yet reported
- **Workaround**: `Tooltip` widget

## Reporting Process

When discovering a gap:

1. **Check shipit_ui** — Verify component doesn't exist
2. **Assess reusability** — Generic vs product-specific
3. **Create entry** — Add to this file
4. **Report upstream** — File issue in shipit-ui repo
5. **Document workaround** — Mark as DESIGN_PENDING in code
6. **Track status** — Update status field

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