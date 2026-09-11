import 'package:go_router/go_router.dart';
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
      // DESIGN_PENDING: No app shell / navigation between /household and
      // /programs (no approved tab/rail/drawer in Penpot). /programs is
      // reachable by URL only; a shell is the recommended Phase-2 golden-path
      // task resolved against an approved Penpot revision (see README).
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
        GoRoute(
          path: '/household',
          name: 'household',
          builder: (context, state) => const HouseholdScreen(),
        ),
        GoRoute(
          path: '/programs',
          name: 'programs',
          builder: (context, state) => const ProgramsScreen(),
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
