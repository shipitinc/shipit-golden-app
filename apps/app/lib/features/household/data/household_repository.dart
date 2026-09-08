import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/household/data/household_converters.dart';
import 'package:shipit_golden_app/features/household/domain/household.dart';
import 'package:shipit_golden_app/features/household/domain/household_member.dart';

class HouseholdRepository {
  final ServerpodClientProvider _clientProvider;

  HouseholdRepository({ServerpodClientProvider? clientProvider})
    : _clientProvider = clientProvider ?? ServerpodClientProvider.shared;

  Future<Result<Household>> getHousehold() async {
    return _runCatching(() async {
      final household = await _clientProvider.client.household.getCurrent();
      return householdFromProtocol(household);
    });
  }

  Future<Result<List<HouseholdMember>>> getMembers() async {
    return _runCatching(() async {
      final members = await _clientProvider.client.household.getMembers();
      return members.map(householdMemberFromProtocol).toList();
    });
  }

  Future<Result<HouseholdMember>> addMember(String name, String email) async {
    return _runCatching(() async {
      final member = await _clientProvider.client.household.addMember(
        name,
        email,
      );
      return householdMemberFromProtocol(member);
    });
  }

  Future<Result<void>> removeMember(String memberId) async {
    return _runCatching(() async {
      await _clientProvider.client.household.removeMember(memberId);
    });
  }

  Future<Result<T>> _runCatching<T>(Future<T> Function() action) async {
    try {
      return Result.success(await action());
    } catch (e) {
      return Result.failure(_mapError(e));
    }
  }

  AppFailure _mapError(Object error) => mapAppFailure(error);
}
