import 'package:app_client/app_client.dart' as api;
import 'package:shipit_golden_app/features/household/domain/household.dart';
import 'package:shipit_golden_app/features/household/domain/household_member.dart';

/// Maps protocol [api.Household] (from the generated Serverpod client) to the
/// feature domain [Household].
Household householdFromProtocol(api.Household household) {
  return Household(
    id: household.id?.toString() ?? '',
    name: household.name,
    ownerId: household.ownerId,
    createdAt: household.createdAt,
  );
}

/// Maps protocol [api.HouseholdMember] (from the generated Serverpod client) to
/// the feature domain [HouseholdMember].
HouseholdMember householdMemberFromProtocol(api.HouseholdMember member) {
  return HouseholdMember(
    id: member.id?.toString() ?? '',
    householdId: member.householdId.toString(),
    name: member.name,
    email: member.email,
    role: member.role.name,
    joinedAt: member.joinedAt,
  );
}
