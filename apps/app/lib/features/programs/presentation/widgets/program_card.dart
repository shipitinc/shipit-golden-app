import 'package:flutter/material.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';

class ProgramCard extends StatelessWidget {
  final Program program;

  const ProgramCard({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(program.name, style: AppTypography.titleLarge),
              ),
              _StatusChip(status: program.status),
            ],
          ),
          SizedBox(height: AppSpacing.space2),
          Text(
            program.description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.fgSecondaryColor,
            ),
          ),
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
                '${_formatDate(program.startDate)} - ${_formatDate(program.endDate)}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.fgSecondaryColor,
                ),
              ),
              const Spacer(),
              AppButton.secondary(
                label: 'View Details',
                onPressed: () {
                  // DESIGN_PENDING: Navigate to program detail
                },
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

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        backgroundColor = AppColors.stateInfoBgColor;
        textColor = AppColors.stateInfoFgColor;
        break;
      case 'upcoming':
        backgroundColor = AppColors.actionPrimaryBgColor;
        textColor = AppColors.actionPrimaryFgColor;
        break;
      case 'completed':
        backgroundColor = AppColors.bgSubtleColor;
        textColor = AppColors.fgSecondaryColor;
        break;
      default:
        backgroundColor = AppColors.bgSubtleColor;
        textColor = AppColors.fgSecondaryColor;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space2,
        vertical: AppSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.radiusSm),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
