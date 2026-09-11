import 'package:freezed_annotation/freezed_annotation.dart';

part 'program_details_event.freezed.dart';

@freezed
sealed class ProgramDetailsEvent with _$ProgramDetailsEvent {
  const factory ProgramDetailsEvent.started() = ProgramDetailsStarted;
  const factory ProgramDetailsEvent.refreshRequested() =
      ProgramDetailsRefreshRequested;
  const factory ProgramDetailsEvent.joinRequested() =
      ProgramDetailsJoinRequested;
  const factory ProgramDetailsEvent.cancelRequested() =
      ProgramDetailsCancelRequested;
}
