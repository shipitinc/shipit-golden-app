import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/features/household/domain/household.dart';
import 'package:shipit_golden_app/features/household/domain/household_member.dart';
import 'package:shipit_golden_app/features/household/presentation/widgets/household_header.dart';
import 'package:shipit_golden_app/features/household/presentation/widgets/member_list.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';
import 'package:shipit_golden_app/features/programs/presentation/widgets/program_card.dart';

/// Semantics coverage for the core post-login data widgets.
///
/// The login-screen assertions live in `accessibility_semantics_test.dart`;
/// this companion file extends the suite to the household and programs
/// surfaces with the same machine-checkable approach (labels, tap targets).
/// See `product.yaml` -> `qa.accessibility` and docs/qa/strategy.md.
void main() {
  final household = Household(
    id: 'h1',
    name: 'The Golden Household',
    ownerId: 'u1',
    createdAt: DateTime(2026, 1, 1),
  );

  final members = [
    HouseholdMember(
      id: '1',
      householdId: 'h1',
      name: 'Alice Example',
      email: 'alice@example.com',
      role: 'owner',
      joinedAt: DateTime(2026, 1, 2),
    ),
  ];

  final program = Program(
    id: '1',
    name: 'Summer Camp',
    description: 'Annual summer camp',
    startDate: DateTime(2026, 6, 15),
    endDate: DateTime(2026, 8, 15),
    status: 'active',
  );

  Widget wrap(Widget child) {
    return MaterialApp(
      theme: shipitLightTheme(),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }

  testWidgets('household header exposes the household name', (tester) async {
    await tester.pumpWidget(wrap(HouseholdHeader(household: household)));
    await tester.pump();

    expect(find.text('The Golden Household'), findsOneWidget);
    // AppCard merges descendant text into one node; the merged node includes
    // the household name, so assert containment rather than an exact match.
    final merged = tester.getSemantics(find.text('The Golden Household'));
    expect(merged.label, contains('The Golden Household'));
  });

  testWidgets('members table exposes member names as readable rows', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(MemberList(members: members)));
    await tester.pump();

    expect(find.text('Alice Example'), findsOneWidget);
    final nameNode = tester.getSemantics(find.text('Alice Example'));
    expect(nameNode.label, contains('Alice Example'));
  });

  testWidgets('program card exposes the program name and target label', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(ProgramCard(program: program)));
    await tester.pump();

    final merged = tester.getSemantics(find.text('Summer Camp'));
    expect(merged.label, contains('Summer Camp'));

    final detailsButton = find.text('View Details');
    expect(detailsButton, findsOneWidget);
    final buttonSemantics = tester.getSemantics(detailsButton);
    expect(buttonSemantics.label, contains('View Details'));

    // The tappable button meets the 40dp minimum touch target.
    final buttonBox = tester.getSize(find.byType(AppButton));
    expect(
      buttonBox.height,
      greaterThanOrEqualTo(40),
      reason: 'tap target below the 40dp accessibility minimum (Material).',
    );
  });
}
