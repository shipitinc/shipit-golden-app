import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_event.dart';
import 'package:shipit_golden_app/features/household/bloc/household_bloc.dart';
import 'package:shipit_golden_app/features/household/bloc/household_event.dart';
import 'package:shipit_golden_app/features/household/bloc/household_state.dart';
import 'package:shipit_golden_app/features/household/presentation/widgets/household_header.dart';
import 'package:shipit_golden_app/features/household/presentation/widgets/member_list.dart';
import 'package:shipit_golden_app/features/household/presentation/widgets/add_member_dialog.dart';

class HouseholdScreen extends StatelessWidget {
  const HouseholdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HouseholdBloc()..add(const HouseholdStarted()),
      child: const HouseholdView(),
    );
  }
}

class HouseholdView extends StatelessWidget {
  const HouseholdView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Household'),
        actions: [
          AppIconButton(
            icon: Icons.refresh,
            tooltip: 'Refresh',
            onPressed: () {
              context.read<HouseholdBloc>().add(
                const HouseholdRefreshRequested(),
              );
            },
          ),
          // DESIGN_PENDING: Household settings screen
          AppIconButton(
            icon: Icons.logout,
            tooltip: 'Sign out',
            onPressed: () {
              context.read<AuthenticationBloc>().add(
                const AuthenticationEvent.logoutRequested(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HouseholdBloc, HouseholdState>(
        builder: (context, state) {
          return switch (state) {
            HouseholdLoading() => ListView(
              padding: EdgeInsets.all(context.space.s4),
              children: [
                AppSkeleton.card(),
                SizedBox(height: context.space.s4),
                AppSkeleton.card(),
              ],
            ),
            HouseholdFailure(:final failure) => ListView(
              padding: EdgeInsets.all(context.space.s4),
              children: [
                AppInlineAlert.error(
                  title: 'Error',
                  message: failure.userMessage,
                  actionLabel: 'Retry',
                  onAction: () => context.read<HouseholdBloc>().add(
                    const HouseholdRefreshRequested(),
                  ),
                ),
                SizedBox(height: context.space.s4),
                AppSkeleton.card(autoplay: false),
              ],
            ),
            HouseholdLoaded(
              :final household,
              :final members,
              :final mutationError,
            ) =>
              RefreshIndicator(
                onRefresh: () async {
                  context.read<HouseholdBloc>().add(
                    const HouseholdRefreshRequested(),
                  );
                },
                child: ListView(
                  padding: EdgeInsets.all(context.space.s4),
                  children: [
                    if (mutationError != null) ...[
                      AppInlineAlert.error(
                        title: 'Error',
                        message: mutationError.userMessage,
                        onDismiss: () {
                          context.read<HouseholdBloc>().add(
                            const HouseholdMutationErrorDismissed(),
                          );
                        },
                      ),
                      SizedBox(height: context.space.s4),
                    ],
                    HouseholdHeader(household: household),
                    SizedBox(height: context.space.s6),
                    MemberList(
                      members: members,
                      isMutating: state.isMembersMutating,
                    ),
                  ],
                ),
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddMemberDialog.show(context),
        tooltip: 'Add member',
        // DESIGN_PENDING: Member invitation flow (invite-by-code/email)
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
