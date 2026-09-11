import 'package:flutter/material.dart';
import 'package:shipit_ui/shipit_ui.dart';

/// Status chip shared by the program list and detail surfaces.
class ProgramStatusChip extends StatelessWidget {
  final String status;

  const ProgramStatusChip({super.key, required this.status});

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
          fontWeight: context.font.weight.semibold,
        ),
      ),
    );
  }
}
