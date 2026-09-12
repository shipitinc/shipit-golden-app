import 'package:freezed_annotation/freezed_annotation.dart';

part 'household_event.freezed.dart';

@freezed
sealed class HouseholdEvent with _$HouseholdEvent {
  const factory HouseholdEvent.started() = HouseholdStarted;
  const factory HouseholdEvent.refreshRequested() = HouseholdRefreshRequested;
  const factory HouseholdEvent.memberAdded({
    required String name,
    required String email,
  }) = HouseholdMemberAdded;
  const factory HouseholdEvent.memberRemoved({required String memberId}) =
      HouseholdMemberRemoved;
  const factory HouseholdEvent.mutationErrorDismissed() =
      HouseholdMutationErrorDismissed;
}
