import 'package:flutter/material.dart';
import 'package:shipit_golden_app/app/app.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_event.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final authBloc = AuthenticationBloc();
  runApp(ShipItGoldenApp(authBloc: authBloc));
  authBloc.add(const AuthenticationStarted());
}
