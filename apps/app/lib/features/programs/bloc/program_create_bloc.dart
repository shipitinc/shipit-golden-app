import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_create_event.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_create_state.dart';
import 'package:shipit_golden_app/features/programs/data/programs_repository.dart';

/// Coordinates the program-creation mutation.
///
/// A successful submission settles in the terminal [ProgramCreateCompleted]
/// state; the create screen owns the resulting navigation (pops with `true`)
/// and the programs list refreshes on return — the bloc never navigates. A
/// failed submission settles in [ProgramCreateFailure] so the form stays
/// intact and the screen renders a dismissible error alert; there is no
/// automatic retry.
class ProgramCreateBloc extends Bloc<ProgramCreateEvent, ProgramCreateState> {
  final ProgramsRepository _repository;

  ProgramCreateBloc({ProgramsRepository? repository})
    : _repository = repository ?? ProgramsRepository(),
      super(const ProgramCreateState.initial()) {
    on<ProgramCreateSubmitted>(_onSubmitted);
    on<ProgramCreateErrorDismissed>(_onErrorDismissed);
  }

  Future<void> _onSubmitted(
    ProgramCreateSubmitted event,
    Emitter<ProgramCreateState> emit,
  ) async {
    if (state is ProgramCreateSubmitting || state is ProgramCreateCompleted) {
      return;
    }
    emit(const ProgramCreateState.submitting());
    final result = await _repository.createProgram(
      name: event.name,
      description: event.description,
      startDate: event.startDate,
      endDate: event.endDate,
    );
    result.when(
      success: (_) => emit(const ProgramCreateState.completed()),
      failure: (failure) =>
          emit(ProgramCreateState.failure(submitError: failure)),
    );
  }

  Future<void> _onErrorDismissed(
    ProgramCreateErrorDismissed event,
    Emitter<ProgramCreateState> emit,
  ) async {
    if (state is ProgramCreateFailure) {
      emit(const ProgramCreateState.initial());
    }
  }
}
