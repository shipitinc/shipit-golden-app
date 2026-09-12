import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_details_bloc.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_details_event.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_details_state.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';
import 'package:shipit_golden_app/features/programs/presentation/widgets/program_date_range.dart';
import 'package:shipit_golden_app/features/programs/presentation/widgets/program_status_chip.dart';

/// Single-program detail with a join/cancel membership toggle.
///
/// DESIGN_PENDING: screen layout, CTA copy and destructive-confirm styling are
/// implemented with approved shipit_ui components but await an approved
/// Penpot design revision (see `docs/qa/pending-actions.md`).
class ProgramDetailsScreen extends StatelessWidget {
  final String programId;

  const ProgramDetailsScreen({super.key, required this.programId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProgramDetailsBloc(programId: programId)
            ..add(const ProgramDetailsStarted()),
      child: const ProgramDetailsView(),
    );
  }
}

class ProgramDetailsView extends StatelessWidget {
  const ProgramDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Program Details')),
      body: BlocBuilder<ProgramDetailsBloc, ProgramDetailsState>(
        builder: (context, state) {
          return switch (state) {
            ProgramDetailsLoading() => ListView(
              padding: EdgeInsets.all(context.space.s4),
              children: [
                AppSkeleton.card(),
                SizedBox(height: context.space.s4),
                AppSkeleton.card(),
              ],
            ),
            ProgramDetailsFailure(:final failure) => ListView(
              padding: EdgeInsets.all(context.space.s4),
              children: [
                AppInlineAlert.error(
                  title: 'Error',
                  message: failure.userMessage,
                  actionLabel: 'Retry',
                  onAction: () => context.read<ProgramDetailsBloc>().add(
                    const ProgramDetailsRefreshRequested(),
                  ),
                ),
                SizedBox(height: context.space.s4),
                AppSkeleton.card(autoplay: false),
              ],
            ),
            ProgramDetailsLoaded(
              :final program,
              :final isJoined,
              :final isMutating,
              :final mutationError,
            ) =>
              _ProgramDetailsBody(
                program: program,
                isJoined: isJoined,
                isMutating: isMutating,
                mutationError: mutationError,
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _ProgramDetailsBody extends StatelessWidget {
  final Program program;
  final bool isJoined;
  final bool isMutating;
  final AppFailure? mutationError;

  const _ProgramDetailsBody({
    required this.program,
    required this.isJoined,
    required this.isMutating,
    required this.mutationError,
  });

  @override
  Widget build(BuildContext context) {
    final errorMessage = mutationError?.userMessage;
    return ListView(
      padding: EdgeInsets.all(context.space.s4),
      children: [
        if (mutationError != null) ...[
          AppInlineAlert.error(
            title: 'Error',
            message: errorMessage,
            onDismiss: () {
              context.read<ProgramDetailsBloc>().add(
                const ProgramDetailsMutationErrorDismissed(),
              );
            },
          ),
          SizedBox(height: context.space.s4),
        ],
        AppCard(
          padding: EdgeInsets.all(context.space.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(program.name, style: context.text.title.large),
                  ),
                  ProgramStatusChip(status: program.status),
                ],
              ),
              SizedBox(height: context.space.s2),
              Text(
                program.description,
                style: context.text.body.medium.copyWith(
                  color: context.color.fg.secondary,
                ),
              ),
              SizedBox(height: context.space.s3),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: context.icon.size.sm,
                    color: context.color.fg.secondary,
                  ),
                  SizedBox(width: context.space.s2),
                  Text(
                    formatProgramDateRange(program.startDate, program.endDate),
                    style: context.text.body.small.copyWith(
                      color: context.color.fg.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: context.space.s4),
        // DESIGN_PENDING: membership CTA copy and cancel confirm flow await an
        // approved design revision.
        if (isJoined)
          AppButton.secondary(
            label: 'Cancel Membership',
            state: isMutating ? AppButtonState.loading : AppButtonState.base,
            onPressed: () => _confirmCancel(context),
          )
        else
          AppButton.primary(
            label: 'Join Program',
            state: isMutating ? AppButtonState.loading : AppButtonState.base,
            onPressed: () => context.read<ProgramDetailsBloc>().add(
              const ProgramDetailsJoinRequested(),
            ),
          ),
      ],
    );
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Cancel Membership',
      message:
          'Are you sure you want to cancel your membership in ${program.name}?',
      confirmLabel: 'Cancel Membership',
      isDestructive: true,
    );
    if (confirmed && context.mounted) {
      context.read<ProgramDetailsBloc>().add(
        const ProgramDetailsCancelRequested(),
      );
    }
  }
}
