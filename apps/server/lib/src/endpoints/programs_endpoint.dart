import 'package:serverpod/serverpod.dart';
import 'package:shipit_golden_server/src/generated/protocol.dart';

// STUB / DEV_PENDING
// ---------------------------------------------------------------------------
// This endpoint is a local-development STUB, NOT canonical. It returns a hard
// coded in-memory list (no PostgreSQL persistence beyond JWT enforcement). It
// exists so the reference UI can be built against stable responses. Do not copy
// this pattern as canonical; the real implementation persists to PostgreSQL
// like the auth flow in auth_endpoint.dart. See docs/architecture/backend.md
// and product.yaml.
// ---------------------------------------------------------------------------

class ProgramsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<Program>> getAll(Session session) async {
    return [
      Program(
        name: 'Summer Camp 2024',
        description: 'Annual summer camp for families',
        startDate: DateTime(2024, 6, 15),
        endDate: DateTime(2024, 8, 15),
        status: 'active',
      ),
      Program(
        name: 'Winter Workshop',
        description: 'Creative winter activities',
        startDate: DateTime(2024, 12, 1),
        endDate: DateTime(2024, 12, 20),
        status: 'upcoming',
      ),
    ];
  }
}
