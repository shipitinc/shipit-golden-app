import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/household/bloc/household_event.dart';
import 'package:shipit_golden_app/features/household/bloc/household_state.dart';
import 'package:shipit_golden_app/features/household/data/household_repository.dart';
import 'package:shipit_golden_app/features/household/domain/household.dart';
import 'package:shipit_golden_app/features/household/domain/household_member.dart';

class HouseholdBloc extends Bloc<HouseholdEvent, HouseholdState> {
  final HouseholdRepository _repository;

  HouseholdBloc({HouseholdRepository? repository})
    : _repository = repository ?? HouseholdRepository(),
      super(const HouseholdState.initial()) {
    on<HouseholdStarted>(_onStarted);
    on<HouseholdRefreshRequested>(_onRefreshRequested);
    on<HouseholdMemberAdded>(_onMemberAdded);
    on<HouseholdMemberRemoved>(_onMemberRemoved);
  }

  Future<void> _onStarted(
    HouseholdStarted event,
    Emitter<HouseholdState> emit,
  ) async {
    emit(const HouseholdState.loading());
    await _loadHousehold(emit);
  }

  Future<void> _onRefreshRequested(
    HouseholdRefreshRequested event,
    Emitter<HouseholdState> emit,
  ) async {
    await _loadHousehold(emit);
  }

  Future<void> _loadHousehold(Emitter<HouseholdState> emit) async {
    final householdResult = await _repository.getHousehold();
    if (householdResult is Failure<Household>) {
      emit(HouseholdState.failure(failure: householdResult.failure));
      return;
    }

    final membersResult = await _repository.getMembers();
    if (membersResult is Failure<List<HouseholdMember>>) {
      emit(HouseholdState.failure(failure: membersResult.failure));
      return;
    }

    emit(
      HouseholdState.loaded(
        household: (householdResult as Success<Household>).value,
        members: (membersResult as Success<List<HouseholdMember>>).value
            .toImmutableList(),
      ),
    );
  }

  Future<void> _onMemberAdded(
    HouseholdMemberAdded event,
    Emitter<HouseholdState> emit,
  ) async {
    if (state is HouseholdLoaded) {
      final currentState = state as HouseholdLoaded;
      final result = await _repository.addMember(event.name, event.email);
      result.when(
        success: (member) {
          emit(
            HouseholdState.loaded(
              household: currentState.household,
              members: [...currentState.members, member].toImmutableList(),
            ),
          );
        },
        failure: (failure) {
          emit(HouseholdState.failure(failure: failure));
        },
      );
    }
  }

  Future<void> _onMemberRemoved(
    HouseholdMemberRemoved event,
    Emitter<HouseholdState> emit,
  ) async {
    if (state is HouseholdLoaded) {
      final currentState = state as HouseholdLoaded;
      final result = await _repository.removeMember(event.memberId);
      result.when(
        success: (_) {
          emit(
            HouseholdState.loaded(
              household: currentState.household,
              members: currentState.members
                  .where((m) => m.id != event.memberId)
                  .toImmutableList(),
            ),
          );
        },
        failure: (failure) {
          emit(HouseholdState.failure(failure: failure));
        },
      );
    }
  }
}
