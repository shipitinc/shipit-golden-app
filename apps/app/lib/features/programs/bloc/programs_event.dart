import 'package:freezed_annotation/freezed_annotation.dart';

part 'programs_event.freezed.dart';

@freezed
sealed class ProgramsEvent with _$ProgramsEvent {
  const factory ProgramsEvent.started() = ProgramsStarted;
  const factory ProgramsEvent.refreshRequested() = ProgramsRefreshRequested;
}
