import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/features/household/domain/household_member.dart';
import 'package:shipit_golden_app/features/household/bloc/household_bloc.dart';
import 'package:shipit_golden_app/features/household/bloc/household_event.dart';

class MemberList extends StatelessWidget {
  final List<HouseholdMember> members;
  final bool isMutating;

  const MemberList({super.key, required this.members, this.isMutating = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Members (${members.length})', style: AppTypography.titleMedium),
        SizedBox(height: AppSpacing.space3),
        if (isMutating)
          const _MembersTableShimmer()
        else
          AppDataTable<HouseholdMember>(
            columns: [
              AppDataColumn.text(
                label: 'Name',
                value: (member) => member.name,
                comparator: (a, b) => a.name.compareTo(b.name),
              ),
              AppDataColumn.text(
                label: 'Email',
                value: (member) => member.email,
                comparator: (a, b) => a.email.compareTo(b.email),
              ),
              AppDataColumn(
                label: '',
                cellBuilder: (context, member) =>
                    _MemberRowMenu(member: member),
              ),
            ],
            rows: members,
            emptyTitle: 'No members yet',
            emptyDescription: 'Tap the + button to add a member',
          ),
      ],
    );
  }
}

/// Shimmer silhouette of the members table, shown while an add/remove
/// operation is in flight so the table never blanks out mid-mutation.
class _MembersTableShimmer extends StatelessWidget {
  const _MembersTableShimmer();

  @override
  Widget build(BuildContext context) {
    return AppSkeleton.shimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
              child: Row(
                children: [
                  Expanded(child: AppSkeleton.line(width: 180)),
                  SizedBox(width: AppSpacing.space8),
                  Expanded(child: AppSkeleton.line(width: 240)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MemberRowMenu extends StatelessWidget {
  final HouseholdMember member;

  const _MemberRowMenu({required this.member});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'remove') {
          _confirmRemove(context, context.read<HouseholdBloc>());
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'remove', child: Text('Remove')),
      ],
    );
  }

  Future<void> _confirmRemove(BuildContext context, HouseholdBloc bloc) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Remove Member',
      message: 'Are you sure you want to remove ${member.name}?',
      confirmLabel: 'Remove',
      isDestructive: true,
    );
    if (confirmed) {
      bloc.add(HouseholdMemberRemoved(memberId: member.id));
    }
  }
}
