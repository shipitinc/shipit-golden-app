import 'package:go_router/go_router.dart';
import 'package:shipit_golden_app/app/shell/app_shell.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_state.dart';
import 'package:shipit_golden_app/features/authentication/presentation/screens/login_screen.dart';
import 'package:shipit_golden_app/features/household/presentation/screens/household_screen.dart';
import 'package:shipit_golden_app/features/programs/presentation/screens/programs_screen.dart';

class AppRouter {
  static const _loginLocation = '/login';

  /// Builds the router bound to [authBloc] so the redirect guard can observe
  /// authentication state.
  static GoRouter create(AuthenticationBloc authBloc) {
    return GoRouter(
      initialLocation: _loginLocation,
      // Authenticated destinations live under a `StatefulShellRoute` whose
      // branches (household, programs) share one `AppShell` chrome. Each tab
      // keeps its own Navigator in an IndexedStack, so switching tabs
      // preserves BLoC + scroll state. The shell uses the approved shipit_ui
      // `AppNavigationRail` (auto-collapses below the desktop breakpoint).
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => LoginScreen(authBloc: authBloc),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => LoginScreen(
            authBloc: authBloc,
            initialMode: AuthScreenMode.register,
          ),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              AppShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/household',
                  name: 'household',
                  builder: (context, state) => const HouseholdScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/programs',
                  name: 'programs',
                  builder: (context, state) => const ProgramsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final authenticated = authBloc.state is AuthenticationAuthenticated;
        final loggingIn =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';
        if (!authenticated && !loggingIn) return _loginLocation;
        if (authenticated && loggingIn) return '/household';
        return null;
      },
    );
  }
}
