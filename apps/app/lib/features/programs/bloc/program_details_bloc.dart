import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_details_event.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_details_state.dart';
import 'package:shipit_golden_app/features/programs/data/programs_repository.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';

/// Loads a single [Program] together with the authenticated user's membership
/// status, and coordinates the join/cancel mutation flow.
///
/// Mutation state follows the household pattern: the loaded state carries
/// [ProgramDetailsLoaded.isMutating] so the CTA button shows its loading
/// indicator while a join/cancel is in flight, and a failed mutation stays on
/// the loaded state with [ProgramDetailsLoaded.mutationError] so the screen
/// renders an inline alert instead of blanking the loaded content.
class ProgramDetailsBloc
    extends Bloc<ProgramDetailsEvent, ProgramDetailsState> {
  final String programId;
  final ProgramsRepository _repository;

  ProgramDetailsBloc({required this.programId, ProgramsRepository? repository})
    : _repository = repository ?? ProgramsRepository(),
      super(const ProgramDetailsState.initial()) {
    on<ProgramDetailsStarted>(_onStarted);
    on<ProgramDetailsRefreshRequested>(_onRefreshRequested);
    on<ProgramDetailsJoinRequested>(_onJoinRequested);
    on<ProgramDetailsCancelRequested>(_onCancelRequested);
    on<ProgramDetailsMutationErrorDismissed>(_onMutationErrorDismissed);
  }

  Future<void> _onStarted(
    ProgramDetailsStarted event,
    Emitter<ProgramDetailsState> emit,
  ) async {
    emit(const ProgramDetailsState.loading());
    await _load(emit);
  }

  Future<void> _onRefreshRequested(
    ProgramDetailsRefreshRequested event,
    Emitter<ProgramDetailsState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<ProgramDetailsState> emit) async {
    final programResult = await _repository.getProgramById(programId);
    if (programResult is Failure<Program>) {
      emit(ProgramDetailsState.failure(failure: programResult.failure));
      return;
    }

    final membershipResult = await _repository.isJoined(programId);
    if (membershipResult is Failure<bool>) {
      emit(ProgramDetailsState.failure(failure: membershipResult.failure));
      return;
    }

    emit(
      ProgramDetailsState.loaded(
        program: (programResult as Success<Program>).value,
        isJoined: (membershipResult as Success<bool>).value,
      ),
    );
  }

  Future<void> _onJoinRequested(
    ProgramDetailsJoinRequested event,
    Emitter<ProgramDetailsState> emit,
  ) async {
    if (state is ProgramDetailsLoaded) {
      final currentState = state as ProgramDetailsLoaded;
      emit(
        ProgramDetailsState.loaded(
          program: currentState.program,
          isJoined: currentState.isJoined,
          isMutating: true,
        ),
      );
      final result = await _repository.joinProgram(programId);
      result.when(
        success: (_) {
          emit(
            ProgramDetailsState.loaded(
              program: currentState.program,
              isJoined: true,
            ),
          );
        },
        failure: (failure) {
          emit(
            ProgramDetailsState.loaded(
              program: currentState.program,
              isJoined: currentState.isJoined,
              mutationError: failure,
            ),
          );
        },
      );
    }
  }

  Future<void> _onCancelRequested(
    ProgramDetailsCancelRequested event,
    Emitter<ProgramDetailsState> emit,
  ) async {
    if (state is ProgramDetailsLoaded) {
      final currentState = state as ProgramDetailsLoaded;
      emit(
        ProgramDetailsState.loaded(
          program: currentState.program,
          isJoined: currentState.isJoined,
          isMutating: true,
        ),
      );
      final result = await _repository.cancelMembership(programId);
      result.when(
        success: (_) {
          emit(
            ProgramDetailsState.loaded(
              program: currentState.program,
              isJoined: false,
            ),
          );
        },
        failure: (failure) {
          emit(
            ProgramDetailsState.loaded(
              program: currentState.program,
              isJoined: currentState.isJoined,
              mutationError: failure,
            ),
          );
        },
      );
    }
  }

  Future<void> _onMutationErrorDismissed(
    ProgramDetailsMutationErrorDismissed event,
    Emitter<ProgramDetailsState> emit,
  ) async {
    if (state is ProgramDetailsLoaded) {
      final currentState = state as ProgramDetailsLoaded;
      emit(
        ProgramDetailsState.loaded(
          program: currentState.program,
          isJoined: currentState.isJoined,
        ),
      );
    }
  }
}
