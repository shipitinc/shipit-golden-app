import 'package:flutter/material.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/features/household/domain/household.dart';

class HouseholdHeader extends StatelessWidget {
  final Household household;

  const HouseholdHeader({super.key, required this.household});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(context.space.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(name: household.name, size: AppAvatarSize.xl),
              SizedBox(width: context.space.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(household.name, style: context.text.headline.small),
                    SizedBox(height: context.space.s1),
                    Text(
                      'Owner ID: ${household.ownerId}',
                      style: context.text.body.small.copyWith(
                        color: context.color.fg.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.space.s3),
          AppLayout.divider(color: context.color.border.strong),
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
                'Created: ${_formatDate(household.createdAt)}',
                style: context.text.body.small.copyWith(
                  color: context.color.fg.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
