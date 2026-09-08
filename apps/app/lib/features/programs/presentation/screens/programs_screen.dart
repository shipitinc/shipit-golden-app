import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_event.dart';
import 'package:shipit_golden_app/features/programs/bloc/programs_bloc.dart';
import 'package:shipit_golden_app/features/programs/bloc/programs_event.dart';
import 'package:shipit_golden_app/features/programs/bloc/programs_state.dart';
import 'package:shipit_golden_app/features/programs/presentation/widgets/program_card.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProgramsBloc()..add(const ProgramsStarted()),
      child: const ProgramsView(),
    );
  }
}

class ProgramsView extends StatelessWidget {
  const ProgramsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProgramsBloc>().add(
                const ProgramsRefreshRequested(),
              );
            },
          ),
          AppTooltip(
            message: 'Sign out',
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthenticationBloc>().add(
                  const AuthenticationEvent.logoutRequested(),
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProgramsBloc, ProgramsState>(
        builder: (context, state) {
          return switch (state) {
            ProgramsLoading() => ListView(
              padding: EdgeInsets.all(AppSpacing.space4),
              children: [
                AppSkeleton.card(),
                const SizedBox(height: AppSpacing.space4),
                AppSkeleton.card(),
                const SizedBox(height: AppSpacing.space4),
                AppSkeleton.card(),
              ],
            ),
            ProgramsFailure(:final failure) => ListView(
              padding: EdgeInsets.all(AppSpacing.space4),
              children: [
                AppInlineAlert.error(
                  title: 'Error',
                  message: failure.userMessage,
                  actionLabel: 'Retry',
                  onAction: () => context.read<ProgramsBloc>().add(
                    const ProgramsRefreshRequested(),
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                AppSkeleton.card(autoplay: false),
              ],
            ),
            ProgramsLoaded(:final programs) => RefreshIndicator(
              onRefresh: () async {
                context.read<ProgramsBloc>().add(
                  const ProgramsRefreshRequested(),
                );
              },
              child: programs.isEmpty
                  ? ListView(
                      padding: EdgeInsets.all(AppSpacing.space4),
                      children: const [
                        AppEmptyState(
                          title: 'No programs available',
                          message: 'DESIGN_PENDING: Program creation flow',
                          icon: Icons.event_outlined,
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(AppSpacing.space4),
                      itemCount: programs.length,
                      itemBuilder: (context, index) {
                        return ProgramCard(program: programs[index]);
                      },
                    ),
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
