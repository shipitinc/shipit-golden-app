import 'package:app_client/app_client.dart' as api;
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/data/program_converters.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';

class ProgramsRepository {
  final ServerpodClientProvider _clientProvider;

  ProgramsRepository({ServerpodClientProvider? clientProvider})
    : _clientProvider = clientProvider ?? ServerpodClientProvider.shared;

  Future<Result<List<Program>>> getPrograms() async {
    return _runCatching(() async {
      final programs = await _clientProvider.client.programs.getAll();
      return programs.map(programFromProtocol).toList();
    });
  }

  /// Returns a single program by its (string) id, or a validation failure when
  /// the id is not a valid program id or the program no longer exists.
  Future<Result<Program>> getProgramById(String programId) async {
    final id = int.tryParse(programId);
    if (id == null) return _invalidProgramId();
    return _runCatching(() async {
      final program = await _clientProvider.client.programs.getById(id);
      if (program == null) throw api.ProgramNotFoundException();
      return programFromProtocol(program);
    });
  }

  /// Returns whether the authenticated user's household is joined to
  /// [programId].
  Future<Result<bool>> isJoined(String programId) async {
    final id = int.tryParse(programId);
    if (id == null) return _invalidProgramId();
    return _runCatching(() async {
      final membership = await _clientProvider.client.programs.getMembership(
        id,
      );
      return membership != null;
    });
  }

  /// Joins the authenticated user's household to [programId]. Returns `true`
  /// once joined.
  Future<Result<bool>> joinProgram(String programId) async {
    final id = int.tryParse(programId);
    if (id == null) return _invalidProgramId();
    return _runCatching(() async {
      await _clientProvider.client.programs.joinProgram(id);
      return true;
    });
  }

  /// Cancels the authenticated user's household membership in [programId].
  /// Returns `false` once cancelled.
  Future<Result<bool>> cancelMembership(String programId) async {
    final id = int.tryParse(programId);
    if (id == null) return _invalidProgramId();
    return _runCatching(() async {
      await _clientProvider.client.programs.cancelMembership(id);
      return false;
    });
  }

  Result<T> _invalidProgramId<T>() => Result.failure(
    const AppFailure.validation(message: 'Program not found.'),
  );

  Future<Result<T>> _runCatching<T>(Future<T> Function() action) async {
    try {
      return Result.success(await action());
    } catch (e) {
      return Result.failure(mapAppFailure(e));
    }
  }
}
