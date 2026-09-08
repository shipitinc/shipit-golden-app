import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/data/program_converters.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';

class ProgramsRepository {
  final ServerpodClientProvider _clientProvider;

  ProgramsRepository({ServerpodClientProvider? clientProvider})
    : _clientProvider = clientProvider ?? ServerpodClientProvider.shared;

  Future<Result<List<Program>>> getPrograms() async {
    try {
      final programs = await _clientProvider.client.programs.getAll();
      return Result.success(programs.map(programFromProtocol).toList());
    } catch (e) {
      return Result.failure(mapAppFailure(e));
    }
  }
}
