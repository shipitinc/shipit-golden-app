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
/// Owner-approved UI (2026-09-12): layout, CTA copy and destructive-confirm
/// styling follow the approved shipit_ui component usage under the pinned
/// `shipit_ui@c310a961aa`; a golden baseline for the loaded detail surface is
/// captured on the Linux CI host via `.github/workflows/goldens-update.yml` and
/// recorded in `apps/app/test/goldens/goldens_registry.md`.
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
      appBar: AppBar(
        title: const Text('Program Details'),
        actions: [
          AppIconButton(
            icon: Icons.refresh,
            tooltip: 'Refresh',
            onPressed: () {
              context.read<ProgramDetailsBloc>().add(
                const ProgramDetailsRefreshRequested(),
              );
            },
          ),
        ],
      ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      program.name,
                      style: context.text.headline.small,
                    ),
                  ),
                  SizedBox(width: context.space.s2),
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
              SizedBox(height: context.space.s4),
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
        _MembershipCard(program: program, isJoined: isJoined),
        SizedBox(height: context.space.s4),
        if (isJoined)
          AppButton.secondary(
            label: 'Cancel Membership',
            icon: Icons.remove_circle_outline,
            state: isMutating ? AppButtonState.loading : AppButtonState.base,
            onPressed: () => _confirmCancel(context),
          )
        else
          AppButton.primary(
            label: 'Join Program',
            icon: Icons.add,
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

/// Membership summary card: status-colored read-only surface paired with the
/// join/cancel CTA so the user can see their state at a glance.
class _MembershipCard extends StatelessWidget {
  final Program program;
  final bool isJoined;

  const _MembershipCard({required this.program, required this.isJoined});

  @override
  Widget build(BuildContext context) {
    final accent = isJoined
        ? context.color.state.success
        : context.color.state.info;
    return AppCard(
      padding: EdgeInsets.all(context.space.s4),
      child: Row(
        children: [
          Icon(
            isJoined ? Icons.check_circle_outline : Icons.group_add_outlined,
            size: context.icon.size.md,
            color: accent.fg,
          ),
          SizedBox(width: context.space.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Membership',
                  style: context.text.label.large.copyWith(
                    color: context.color.fg.secondary,
                  ),
                ),
                Text(
                  isJoined ? 'Joined · ${program.name}' : 'Not joined yet',
                  style: context.text.title.small,
                ),
              ],
            ),
          ),
          SizedBox(width: context.space.s2),
          _MembershipBadge(isJoined: isJoined, accent: accent),
        ],
      ),
    );
  }
}

class _MembershipBadge extends StatelessWidget {
  final bool isJoined;
  final AppColorPair accent;

  const _MembershipBadge({required this.isJoined, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.space.s2,
        vertical: context.space.s1,
      ),
      decoration: BoxDecoration(
        color: accent.bg,
        borderRadius: context.radius.all.sm,
      ),
      child: Text(
        isJoined ? 'JOINED' : 'EXPLORE',
        style: context.text.label.small.copyWith(
          color: accent.fg,
          fontWeight: context.font.weight.semibold,
        ),
      ),
    );
  }
}
