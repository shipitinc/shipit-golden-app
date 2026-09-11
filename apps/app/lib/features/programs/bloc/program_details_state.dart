import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';

part 'program_details_state.freezed.dart';

@freezed
sealed class ProgramDetailsState with _$ProgramDetailsState {
  const factory ProgramDetailsState.initial() = ProgramDetailsInitial;
  const factory ProgramDetailsState.loading() = ProgramDetailsLoading;
  const factory ProgramDetailsState.loaded({
    required Program program,
    required bool isJoined,
    @Default(false) bool isMutating,
  }) = ProgramDetailsLoaded;
  const factory ProgramDetailsState.failure({required AppFailure failure}) =
      ProgramDetailsFailure;
}
