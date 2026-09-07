import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/bloc/programs_event.dart';
import 'package:shipit_golden_app/features/programs/bloc/programs_state.dart';
import 'package:shipit_golden_app/features/programs/data/programs_repository.dart';

class ProgramsBloc extends Bloc<ProgramsEvent, ProgramsState> {
  final ProgramsRepository _repository;

  ProgramsBloc({ProgramsRepository? repository})
    : _repository = repository ?? ProgramsRepository(),
      super(const ProgramsState.initial()) {
    on<ProgramsStarted>(_onStarted);
    on<ProgramsRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onStarted(
    ProgramsStarted event,
    Emitter<ProgramsState> emit,
  ) async {
    emit(const ProgramsState.loading());
    await _loadPrograms(emit);
  }

  Future<void> _onRefreshRequested(
    ProgramsRefreshRequested event,
    Emitter<ProgramsState> emit,
  ) async {
    await _loadPrograms(emit);
  }

  Future<void> _loadPrograms(Emitter<ProgramsState> emit) async {
    final result = await _repository.getPrograms();
    result.when(
      success: (programs) {
        emit(ProgramsState.loaded(programs: programs.toImmutableList()));
      },
      failure: (failure) {
        emit(ProgramsState.failure(failure: failure));
      },
    );
  }
}
