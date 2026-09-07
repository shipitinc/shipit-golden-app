import 'package:app_client/app_client.dart' as api;
import 'package:shipit_golden_app/features/programs/domain/program.dart';

/// Maps protocol [api.Program] (from the generated Serverpod client) to the
/// feature domain [Program].
Program programFromProtocol(api.Program program) {
  return Program(
    id: program.id?.toString() ?? '',
    name: program.name,
    description: program.description,
    startDate: program.startDate,
    endDate: program.endDate,
    status: program.status,
  );
}
