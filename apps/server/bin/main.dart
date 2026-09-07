import 'package:serverpod/serverpod.dart';
import 'package:shipit_golden_server/src/auth/auth_setup.dart';
import 'package:shipit_golden_server/src/generated/endpoints.dart';
import 'package:shipit_golden_server/src/generated/protocol.dart';

void main(List<String> args) async {
  final pod = Serverpod(args, Protocol(), Endpoints());

  configureAuthServices(pod);

  await pod.start();
}
