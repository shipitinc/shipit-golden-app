import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/app/routing/app_router.dart';
import 'package:shipit_golden_app/core/config/flavor_config.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_state.dart';

class ShipItGoldenApp extends StatelessWidget {
  /// Provides the root [AuthenticationBloc] instance.
  ///
  /// Tests may supply a pre-configured bloc. In production [main] supplies
  /// a freshly-created bloc.
  final AuthenticationBloc? authBloc;

  const ShipItGoldenApp({super.key, this.authBloc});

  @override
  Widget build(BuildContext context) {
    final bloc = authBloc ?? AuthenticationBloc();
    return MultiBlocProvider(
      providers: [BlocProvider<AuthenticationBloc>.value(value: bloc)],
      child: _AppView(authBloc: bloc),
    );
  }
}

class _AppView extends StatefulWidget {
  final AuthenticationBloc authBloc;
  const _AppView({required this.authBloc});

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.create(widget.authBloc);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: widget.authBloc,
      listener: (context, state) => _router.refresh(),
      child: MaterialApp.router(
        title: FlavorConfig.appName,
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        theme: shipitLightTheme(),
        darkTheme: shipitDarkTheme(),
        themeMode: ThemeMode.system,
      ),
    );
  }
}
