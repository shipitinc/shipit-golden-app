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

Access design tokens through shipit_ui's `AppThemeContext` extension — every
token is read from the ambient theme via `context.*` accessors. Do NOT
re-implement token access and do NOT reach for the (now removed) static
`AppColors` / `AppSpacing` / `AppTypography` classes.

```dart
// CORRECT (canonical shipit_ui theme context API)
Container(color: context.color.state.info.bg)
padding: EdgeInsets.all(context.space.s5)
Text('Title', style: context.text.headline.medium)

// WRONG (arbitrary values / removed static token classes)
Container(color: Color(0xFF3A7BD5))
padding: EdgeInsets.all(16)
Text('Title', style: TextStyle(fontSize: 24))
```

### 3. No Arbitrary Values
- Colors → `context.color.*` (`bg.base/surface/subtle/disabled`, `fg.primary/secondary/muted/inverse/disabled`, `border.base/strong/focus/error`, `action.primary.bg/bgHover/fg`, `action.secondary.bg/border/fg`, `action.disabled.*`, `state.error/success/warning/info.fg|bg`, `scrim`, `shimmer.base/highlight`, `nav.*`, `tooltip.*`, `avatar.*`, `chip.*`, `table.*`)
- Spacing → `context.space.s0` … `s16`
- Typography → `context.text.{display|headline|title|body|label}.{large|medium|small}`; family via `context.font.resolvedFamily`
- Radius → `context.radius.all.{none|sm|md|lg|xl|full}` (`BorderRadius.circular`)
- Breakpoints → `context.breakpoint.{mobile|tablet|desktop|wide|pageWidth}` (360 / 600 / 1024 / 1440 / 1200)
- Elevation → `context.elevation.*`
- Motion → `context.motion.*`
- Opacity → `context.opacity.scrim`

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
context.breakpoint.mobile    // 360px
context.breakpoint.tablet    // 600px
context.breakpoint.desktop   // 1024px
context.breakpoint.wide      // 1440px
context.breakpoint.pageWidth // max content width (1200px)
```

Detection: `context.layoutType` (`AppLayoutType.compact|mobile|tablet|desktop|wide`)
plus `context.isMobileLayout`, `context.isDesktopOrLarger`, etc. The `AppLayout`
class is a **static utility** (not a widget) with `pageConstraints`,
`centeredPage`, `responsivePageWidth`, `responsivePadding` (accepts
compact/mobile/tablet/desktop variants), `hStack`, `vStack`, `divider`, and
fixed spacing helpers (`width2/4/6`, `height2/4/6`).

### AppLayout Usage
```dart
// AppLayout is a static helper, not a widget:
child: AppLayout.centeredPage(child: content, width: context.breakpoint.pageWidth)

AppLayout.hStack(spacing: context.space.s4, children: [AppButton.primary(...), ...])
AppLayout.vStack(...)
AppLayout.responsivePadding(
  mobilePadding: EdgeInsets.all(context.space.s3),
  desktopPadding: EdgeInsets.all(context.space.s5),
  child: content,
)

// Layout-type branching (640px viewport = tablet):
switch (context.layoutType) {
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
- `context.color.bg.surface` / `context.color.fg.primary` — Adapt automatically
- `context.color.action.primary.bg` / `context.color.action.primary.fg` — Brand colors
- `context.color.state.error.fg` / `context.color.state.error.bg` — Error states

Dark mode is governed by `AppTheme.dark` (semantic token tree) painted on dark
surfaces (`#020617` base) with high-contrast text (`neutral50`); the regression
test in `test/theme/dark_mode_test.dart` enforces WCAG AA contrast and distinctly
dark canvases (UPSTREAM_UI_GAP-011 resolved in `shipit_ui@d6abf9a`).

## Golden Baselines

### Policy
- Committed baselines carry a status in
  `apps/app/test/goldens/goldens_registry.md`: `APPROVED` (reviewed and
  approved against an approved design revision; the visual contract) or
  `DESIGN_PENDING` (candidate preserving current rendering so visual
  regressions fail CI with a diff). The login baselines
  (`login_sign_in.png`, `login_register.png`) are `APPROVED` against
  `shipit_ui@d6abf9a` (re-approved 2026-09-09 after the token-tree refactor
  migration; initially promoted 2026-09-08 against `shipit_ui@1207004`),
  and were re-approved 2026-09-10 against `shipit_ui@18d1a5d6` (the GAP-012
  `AppTextButton` / `AppIconButton` migration) via the `goldens-update.yml`
  workflow with design/human approval, recorded in
  `docs/qa/pending-actions.md`. **Current revision:** the app pins
  `shipit_ui@c310a961aa` (2026-09-12 shell bump); the baselines were
  re-approved 2026-09-11 under the previous `shipit_ui@526926d` pin with no
  regeneration — the pin bump consumed GAP-012/013/014 tokens at identical
  values (16 / w600 / 440), so `@526926d` renders the login screens
  pixel-identically — and the `c310a961aa` bump (2026-09-12) consumed only the
  additive `AppBottomNavigationBar` component, which the login screens do not
  use, so the visual contract continues to stand under the active pin (see the
  pin notes in `apps/app/test/goldens/goldens_registry.md`).
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
├── goldens_registry.md      # status list (APPROVED / DESIGN_PENDING) + pin / re-approval notes
├── golden_policy_test.dart  # registry conformance + approved baselines
└── goldens/
    ├── login_sign_in.png    # APPROVED (current pin shipit_ui@c310a961aa; re-approved 2026-09-11, no regen)
    └── login_register.png   # APPROVED (current pin shipit_ui@c310a961aa; re-approved 2026-09-11, no regen)
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