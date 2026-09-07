import 'package:freezed_annotation/freezed_annotation.dart';

part 'household_member.freezed.dart';

@freezed
sealed class HouseholdMember with _$HouseholdMember {
  const factory HouseholdMember({
    required String id,
    required String householdId,
    required String name,
    required String email,
    required String role,
    required DateTime joinedAt,
  }) = _HouseholdMember;
}
