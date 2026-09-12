import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shipit_ui/shipit_ui.dart';

/// Root chrome for authenticated screens, driven by GoRouter's
/// `StatefulShellRoute.indexedStack`, so each tab keeps its BLoC and scroll
/// state when switching (see `app_router.dart`).
///
/// Two approved shipit_ui primitives cover every layout class:
/// - tablet and desktop widths use the [AppNavigationRail] beside the active
///   branch — it extends at desktop (`context.breakpoint.desktop`) and
///   collapses to icon-only (with tooltips) on tablet widths;
/// - compact and mobile widths swap to the companion [AppBottomNavigationBar]
///   in `Scaffold.bottomNavigationBar`, so narrow navigation has a real tap
///   target instead of a degenerate collapsed rail (see GAP-016 /
///   shipitinc/shipit-ui#15, resolved in `shipit_ui@c310a961aa`).
class AppShell extends StatelessWidget {
  /// The navigation surface GoRouter hands to the shell so destinations can
  /// switch the active branch.
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  static const List<AppNavigationRailItem> _destinations = [
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

  static const List<AppBottomNavigationItem> _bottomDestinations = [
    AppBottomNavigationItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Household',
      semanticLabel: Key('nav-household'),
    ),
    AppBottomNavigationItem(
      icon: Icons.event_outlined,
      selectedIcon: Icons.event,
      label: 'Programs',
      semanticLabel: Key('nav-programs'),
    ),
  ];

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      // Re-selecting the active destination returns it to its initial
      // location instead of stacking another page.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (context.isTabletOrLarger) {
      return Scaffold(
        body: Row(
          children: [
            AppNavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onDestinationSelected,
              items: _destinations,
            ),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        items: _bottomDestinations,
      ),
    );
  }
}
