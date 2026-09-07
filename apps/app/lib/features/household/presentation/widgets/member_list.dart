import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/features/household/domain/household_member.dart';
import 'package:shipit_golden_app/features/household/bloc/household_bloc.dart';
import 'package:shipit_golden_app/features/household/bloc/household_event.dart';

class MemberList extends StatelessWidget {
  final List<HouseholdMember> members;

  const MemberList({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return AppCard(
        padding: EdgeInsets.all(AppSpacing.space5),
        child: Column(
          children: [
            Icon(
              Icons.people_outline,
              size: 48,
              color: AppColors.fgSecondaryColor,
            ),
            SizedBox(height: AppSpacing.space3),
            Text('No members yet', style: AppTypography.titleMedium),
            SizedBox(height: AppSpacing.space2),
            Text(
              'Tap the + button to add a member',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.fgSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Members (${members.length})', style: AppTypography.titleMedium),
        SizedBox(height: AppSpacing.space3),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: members.length,
          separatorBuilder: (_, _) => SizedBox(height: AppSpacing.space2),
          itemBuilder: (context, index) {
            final member = members[index];
            return _MemberTile(member: member);
          },
        ),
      ],
    );
  }
}

class _MemberTile extends StatelessWidget {
  final HouseholdMember member;

  const _MemberTile({required this.member});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.space3),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.actionSecondaryBgColor,
            child: Text(
              member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.actionSecondaryFgColor,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name, style: AppTypography.titleMedium),
                Text(
                  member.email,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.fgSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'remove') {
                _confirmRemove(context, context.read<HouseholdBloc>());
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'remove', child: Text('Remove')),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmRemove(BuildContext context, HouseholdBloc bloc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text('Are you sure you want to remove ${member.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              bloc.add(HouseholdMemberRemoved(memberId: member.id));
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
