import 'package:flutter/material.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';

class ProgramCard extends StatelessWidget {
  final Program program;

  const ProgramCard({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(context.space.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(program.name, style: context.text.title.large),
              ),
              _StatusChip(status: program.status),
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
                size: 16,
                color: context.color.fg.secondary,
              ),
              SizedBox(width: context.space.s2),
              Text(
                '${_formatDate(program.startDate)} - ${_formatDate(program.endDate)}',
                style: context.text.body.small.copyWith(
                  color: context.color.fg.secondary,
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
        backgroundColor = context.color.state.info.bg;
        textColor = context.color.state.info.fg;
        break;
      case 'upcoming':
        backgroundColor = context.color.action.primary.bg;
        textColor = context.color.action.primary.fg;
        break;
      case 'completed':
        backgroundColor = context.color.bg.subtle;
        textColor = context.color.fg.secondary;
        break;
      default:
        backgroundColor = context.color.bg.subtle;
        textColor = context.color.fg.secondary;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.space.s2,
        vertical: context.space.s1,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: context.radius.all.sm,
      ),
      child: Text(
        status.toUpperCase(),
        style: context.text.label.small.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
