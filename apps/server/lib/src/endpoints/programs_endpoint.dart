import 'package:serverpod/serverpod.dart';
import 'package:shipit_golden_server/src/generated/protocol.dart';

/// Programs endpoint backed by PostgreSQL.
///
/// Returns all programs from the database. Programs are global (not scoped to a
/// household) in the current schema.
class ProgramsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns all programs.
  Future<List<Program>> getAll(Session session) async {
    return Program.db.find(session);
  }
}
