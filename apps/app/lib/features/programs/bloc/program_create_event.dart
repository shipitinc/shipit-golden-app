import 'package:freezed_annotation/freezed_annotation.dart';

part 'program_create_event.freezed.dart';

@freezed
sealed class ProgramCreateEvent with _$ProgramCreateEvent {
  const factory ProgramCreateEvent.submitted({
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
  }) = ProgramCreateSubmitted;

  const factory ProgramCreateEvent.errorDismissed() =
      ProgramCreateErrorDismissed;
}
