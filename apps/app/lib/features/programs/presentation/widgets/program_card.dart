import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';
import 'package:shipit_golden_app/features/programs/presentation/widgets/program_date_range.dart';
import 'package:shipit_golden_app/features/programs/presentation/widgets/program_status_chip.dart';

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
              const Spacer(),
              AppButton.secondary(
                label: 'View Details',
                onPressed: () {
                  context.push('/programs/${program.id}');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
