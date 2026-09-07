import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/household/domain/household.dart';
import 'package:shipit_golden_app/features/household/domain/household_member.dart';

part 'household_state.freezed.dart';

@freezed
sealed class HouseholdState with _$HouseholdState {
  const factory HouseholdState.initial() = HouseholdInitial;
  const factory HouseholdState.loading() = HouseholdLoading;
  const factory HouseholdState.loaded({
    required Household household,
    required List<HouseholdMember> members,
  }) = HouseholdLoaded;
  const factory HouseholdState.failure({required AppFailure failure}) =
      HouseholdFailure;
}
