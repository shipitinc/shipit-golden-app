import 'package:flutter/material.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/features/household/domain/household.dart';

class HouseholdHeader extends StatelessWidget {
  final Household household;

  const HouseholdHeader({super.key, required this.household});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.actionPrimaryBgColor,
                child: Text(
                  household.name.isNotEmpty
                      ? household.name[0].toUpperCase()
                      : 'H',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.actionPrimaryFgColor,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(household.name, style: AppTypography.headlineSmall),
                    SizedBox(height: AppSpacing.space1),
                    Text(
                      'Owner ID: ${household.ownerId}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.fgSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space3),
          Divider(color: AppColors.borderStrongColor),
          SizedBox(height: AppSpacing.space3),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: AppColors.fgSecondaryColor,
              ),
              SizedBox(width: AppSpacing.space2),
              Text(
                'Created: ${_formatDate(household.createdAt)}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.fgSecondaryColor,
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
