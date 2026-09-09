# Design Authority

## Governance Model

```
Approved Penpot Design Revision
           │
           ▼
      shipit_ui (components)
           │
           ▼
   Golden App Product UI
```

## Authority Hierarchy

1. **Penpot Design System** — Source of truth for visual design
2. **shipit_ui** — Canonical Flutter implementation of design tokens/components
3. **Golden App** — Product-specific composition of shipit_ui components

## Design Implementation Rules

### 1. Use shipit_ui Components
```dart
// CORRECT
AppButton.primary(label: 'Submit', onPressed: () {})
AppTextField(label: 'Email', controller: controller)
AppCard(child: content)

// WRONG
ElevatedButton(onPressed: () {}, child: Text('Submit'))
TextField(controller: controller)
Card(child: content)
```

### 2. Use Design Tokens

Access design tokens via shipit_ui's canonical static API. Do NOT re-implement
token access through `BuildContext` alias extensions; the canonical surface is
`AppColors`, `AppSpacing`, `AppTypography`, `AppRadius`, etc.

```dart
// CORRECT (canonical shipit_ui static API)
Container(color: AppColors.stateInfoBgColor)
padding: EdgeInsets.all(AppSpacing.space5)
Text('Title', style: AppTypography.headlineMedium)

// WRONG (redundant token aliases that drift from shipit_ui)
Container(color: Color(0xFF3A7BD5))
padding: EdgeInsets.all(16)
Text('Title', style: TextStyle(fontSize: 24))
```

### 3. No Arbitrary Values
- Colors → `AppColors.*` (static members: `fgSecondaryColor`, `actionPrimaryBgColor`, etc.)
- Spacing → `AppSpacing.space5` etc.
- Typography → `AppTypography.headlineMedium` etc.
- Radius → `AppRadius.radiusSm` etc.
- Breakpoints → `AppBreakpoints.*`
- Elevation → `AppElevation.*`
- Motion → `AppMotion.*`
- Opacity → `AppOpacity.*`

## Design Change Process

### Level 1: Component Usage (No Design Review)
- Using existing shipit_ui components as intended
- Standard composition patterns

### Level 2: Visual Adjustments (Design Review Required)
- Modifying component appearance
- New color usage
- Spacing changes
- Requires: Design Revision in Penpot → shipit_ui update → Golden App update

### Level 3: New Components (Design Brief + Review)
- New reusable component needed
- Requires: Design Brief → Penpot design → shipit_ui implementation → Golden App usage

## DESIGN_PENDING Marker

Screens/components without approved design:

```dart
// In code comments
// DESIGN_PENDING: Program detail screen - awaiting design revision #42

// In UI (development only)
Text('DESIGN_PENDING: Program detail screen')
```

## Responsive Design

### Breakpoints (from shipit_ui)
```dart
AppBreakpoints.mobile   // 360px
AppBreakpoints.tablet   // 600px
AppBreakpoints.desktop  // 1024px
AppBreakpoints.wide     // 1440px
AppBreakpoints.pageWidth // max content width (1200px)
```

Detection helpers (`AppBreakpoints.isMobile(context)`, `isTablet`, `isDesktop`,
`isWide`, `getLayoutType`) and the `AppLayoutType` enum handle comparison. The
`AppLayout` class is a **static utility** (not a widget) with `pageConstraints`,
`centeredPage`, `responsivePageWidth`, `responsivePadding`, `hStack`, `vStack`,
`divider`, and fixed spacing helpers (`width2/4/6`, `height2/4/6`).

### AppLayout Usage
```dart
// AppLayout is a static helper, not a widget:
child: AppLayout.centeredPage(child: content, width: AppBreakpoints.pageWidth)

AppLayout.hStack(spacing: AppSpacing.space4, children: [AppButton.primary(...), ...])
AppLayout.vStack(...)

// Layout-type branching (640px viewport = tablet):
switch (AppBreakpoints.getLayoutType(context)) {
  case AppLayoutType.compact:
  case AppLayoutType.mobile:
    return _MobileLayout();
  case AppLayoutType.tablet:
    return _TabletLayout();
  case AppLayoutType.desktop:
  case AppLayoutType.wide:
    return _DesktopLayout();
}
```

## Accessibility

### Built into shipit_ui
- Semantic labels on all interactive components
- Focus management
- Contrast ratios (WCAG AA)
- Screen reader support

### Golden App Responsibilities
- Provide meaningful semantics for custom compositions
- Test with screen readers
- Verify keyboard navigation

## Dark Mode

### Automatic via shipit_ui
```dart
MaterialApp(
  theme: shipitLightTheme(),
  darkTheme: shipitDarkTheme(),
  themeMode: ThemeMode.system,
)
```

### Token Semantics
- `colors.surface` / `colors.onSurface` — Adapt automatically
- `colors.primary` / `colors.onPrimary` — Brand colors
- `colors.error` / `colors.onError` — Error states

## Golden Baselines

### Policy
- Committed baselines carry a status in
  `apps/app/test/goldens/goldens_registry.md`: `APPROVED` (reviewed and
  approved against an approved design revision; the visual contract) or
  `DESIGN_PENDING` (candidate preserving current rendering so visual
  regressions fail CI with a diff). The login baselines
  (`login_sign_in.png`, `login_register.png`) were promoted to `APPROVED` on
  2026-09-08 against `shipit_ui@1207004`.
- Approved goldens = visual contract; `flutter test --update-goldens` is NOT a
  fix. Promoting to `APPROVED` (and any subsequent regeneration) requires:
  1. Design authority approval
  2. Corresponding design revision
  3. Updated golden + registry update in the same commit
- Regenerate baselines only on the Linux CI host via
  `.github/workflows/goldens-update.yml` (macOS renders text ~1% differently).

### Golden Test Structure
```
test/goldens/
├── goldens_registry.md      # status list (APPROVED / DESIGN_PENDING)
├── golden_policy_test.dart  # registry conformance + approved baselines
└── goldens/
    ├── login_sign_in.png    # APPROVED (shipit_ui@1207004, 2026-09-08)
    └── login_register.png   # APPROVED (shipit_ui@1207004, 2026-09-08)
```

## Upstream Gaps

When shipit_ui lacks a needed component:

1. **Determine reusability** — Is this generic or product-specific?
2. **Document gap** — Add to `docs/design/upstream-ui-gaps.md`
3. **Report** — Create UPSTREAM_UI_GAP entry
4. **Workaround** — Mark as DESIGN_PENDING, use minimal custom code

```markdown
UPSTREAM_UI_GAP:
  desired_component: AppNavigationRail
  reason: Reusable cross-product navigation primitive
  recommended_owner: shipit-ui
  status: reported
```