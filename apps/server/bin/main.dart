import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:shipit_golden_server/src/auth/auth_setup.dart';
import 'package:shipit_golden_server/src/generated/endpoints.dart';
import 'package:shipit_golden_server/src/generated/protocol.dart';

void main(List<String> args) async {
  final pod = Serverpod(args, Protocol(), Endpoints());

  // The end-to-end journey (apps/app/integration_test/app_journey_test.dart)
  // needs a verification code known before the run, but the dev email channel
  // generates one per request at runtime. In development ONLY, the operator can
  // pin it via the SERVERPOD_DEV_VERIFICATION_CODE env var so the journey is
  // deterministic end-to-end (mirrors the fixed '000000' generator used by the
  // integration-test harness in test/integration/auth_flow_test.dart). Never
  // set in non-development environments.
  final e2ePin = Platform.environment['SERVERPOD_DEV_VERIFICATION_CODE'];
  configureAuthServices(
    pod,
    registrationVerificationCodeGenerator:
        pod.runMode == ServerpodRunMode.development &&
            e2ePin != null &&
            e2ePin.isNotEmpty
            ? () => e2ePin
            : null,
  );

  await pod.start();
}
