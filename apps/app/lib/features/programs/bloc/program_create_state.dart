import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shipit_golden_app/core/core.dart';

part 'program_create_state.freezed.dart';

@freezed
sealed class ProgramCreateState with _$ProgramCreateState {
  const factory ProgramCreateState.initial() = ProgramCreateInitial;
  const factory ProgramCreateState.submitting() = ProgramCreateSubmitting;
  const factory ProgramCreateState.failure({required AppFailure submitError}) =
      ProgramCreateFailure;
  const factory ProgramCreateState.completed() = ProgramCreateCompleted;
}
