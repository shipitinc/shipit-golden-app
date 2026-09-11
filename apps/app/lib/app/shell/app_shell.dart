import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shipit_ui/shipit_ui.dart';

/// Root chrome for authenticated screens: a shipit_ui [AppNavigationRail] with
/// the primary destinations (Household / Programs) beside the active branch.
///
/// The active branch is driven by GoRouter's `StatefulShellRoute.indexedStack`,
/// so each tab keeps its BLoC and scroll state when switching (see
/// `app_router.dart`). The rail follows `AppNavigationRail` conventions: it
/// extends below the desktop breakpoint (`context.breakpoint.desktop`) and
/// collapses to icon-only (with tooltips) on tablet/compact widths, so a
/// single approved Penpot navigation component serves every layout.
class AppShell extends StatelessWidget {
  /// The navigation surface GoRouter hands to the shell so destinations can
  /// switch the active branch.
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  static const List<AppNavigationRailItem> destinations = [
    AppNavigationRailItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Household',
      semanticLabel: Key('nav-household'),
    ),
    AppNavigationRailItem(
      icon: Icons.event_outlined,
      selectedIcon: Icons.event,
      label: 'Programs',
      semanticLabel: Key('nav-programs'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppNavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                // Re-selecting the active destination returns it to its
                // initial location instead of stacking another page.
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            items: destinations,
          ),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
