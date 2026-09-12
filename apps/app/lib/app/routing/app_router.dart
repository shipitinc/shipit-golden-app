import 'package:go_router/go_router.dart';
import 'package:shipit_golden_app/app/shell/app_shell.dart';
import 'package:shipit_golden_app/core/networking/session_expired_notifier.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_event.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_state.dart';
import 'package:shipit_golden_app/features/authentication/presentation/screens/login_screen.dart';
import 'package:shipit_golden_app/features/household/presentation/screens/household_screen.dart';
import 'package:shipit_golden_app/features/programs/presentation/screens/program_details_screen.dart';
import 'package:shipit_golden_app/features/programs/presentation/screens/programs_screen.dart';

/// Owns the [GoRouter] bound to [authBloc] plus the session-expiry hook.
///
/// The auth redirect guard reads [AuthenticationBloc] state directly, so the
/// router itself is the natural place to translate a mid-session 401
/// (announced by [SessionExpiredNotifier]) into the event that ends the local
/// session — no widget in the tree needs to observe the notifier.
class AppRouter {
  static const _loginLocation = '/login';

  final AuthenticationBloc _authBloc;
  final SessionExpiredNotifier _notifier;

  /// The configured router; pass to `MaterialApp.router(routerConfig:)`.
  late final GoRouter router;

  /// Builds the router bound to [authBloc] so the redirect guard can observe
  /// authentication state.
  ///
  /// [notifier] defaults to [SessionExpiredNotifier.shared] (production
  /// convention, mirroring `ServerpodClientProvider.shared`); tests and a
  /// future DI container can supply a dedicated instance.
  AppRouter(this._authBloc, {SessionExpiredNotifier? notifier})
    : _notifier = notifier ?? SessionExpiredNotifier.shared {
    _notifier.add(_onSessionExpired);
    router = GoRouter(
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
          builder: (context, state) => LoginScreen(authBloc: _authBloc),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => LoginScreen(
            authBloc: _authBloc,
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
                GoRoute(
                  path: '/programs/:id',
                  name: 'program-details',
                  builder: (context, state) => ProgramDetailsScreen(
                    programId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final authenticated = _authBloc.state is AuthenticationAuthenticated;
        final loggingIn =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';
        if (!authenticated && !loggingIn) return _loginLocation;
        if (authenticated && loggingIn) return '/household';
        return null;
      },
    );
  }

  /// Ends the local session when a mid-session auth-expiry is observed.
  ///
  /// The server is authoritative (it already refused the request); this only
  /// ends the session locally so the redirect guard returns the user to login.
  void _onSessionExpired() {
    _authBloc.add(const AuthenticationEvent.sessionExpired());
  }

  /// Releases the subscription and disposes the underlying router.
  void dispose() {
    _notifier.remove(_onSessionExpired);
    router.dispose();
  }
}
