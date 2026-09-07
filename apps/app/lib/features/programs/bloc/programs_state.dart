import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';

part 'programs_state.freezed.dart';

@freezed
sealed class ProgramsState with _$ProgramsState {
  const factory ProgramsState.initial() = ProgramsInitial;
  const factory ProgramsState.loading() = ProgramsLoading;
  const factory ProgramsState.loaded({required List<Program> programs}) =
      ProgramsLoaded;
  const factory ProgramsState.failure({required AppFailure failure}) =
      ProgramsFailure;
}
