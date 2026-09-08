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
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () {
              context.read<AuthenticationBloc>().add(
                const AuthenticationEvent.logoutRequested(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProgramsBloc, ProgramsState>(
        builder: (context, state) {
          return switch (state) {
            ProgramsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ProgramsFailure(:final failure) => AppStateView.error(
              title: 'Error',
              message: failure.userMessage,
              onRetry: () => context.read<ProgramsBloc>().add(
                const ProgramsRefreshRequested(),
              ),
            ),
            ProgramsLoaded(:final programs) => RefreshIndicator(
              onRefresh: () async {
                context.read<ProgramsBloc>().add(
                  const ProgramsRefreshRequested(),
                );
              },
              child: programs.isEmpty
                  ? _EmptyProgramsView()
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

class _EmptyProgramsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.space5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_outlined,
              size: 64,
              color: AppColors.fgSecondaryColor,
            ),
            SizedBox(height: AppSpacing.space5),
            Text('No programs available', style: AppTypography.headlineSmall),
            SizedBox(height: AppSpacing.space3),
            Text(
              'DESIGN_PENDING: Program creation flow',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.fgSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
