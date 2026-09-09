import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/features/household/domain/household_member.dart';
import 'package:shipit_golden_app/features/household/presentation/widgets/member_list.dart';

final _members = [
  HouseholdMember(
    id: '1',
    householdId: 'h1',
    name: 'John Doe',
    email: 'john@example.com',
    role: 'owner',
    joinedAt: DateTime(2026, 1, 1),
  ),
  HouseholdMember(
    id: '2',
    householdId: 'h1',
    name: 'Jane Smith',
    email: 'jane@example.com',
    role: 'member',
    joinedAt: DateTime(2026, 1, 2),
  ),
];

void main() {
  Widget wrap({bool isMutating = false}) {
    return MaterialApp(
      theme: shipitLightTheme(),
      home: Scaffold(
        body: MemberList(members: _members, isMutating: isMutating),
      ),
    );
  }

  testWidgets(
    'renders the table when not mutating and the header keeps the count',
    (tester) async {
      await tester.pumpWidget(wrap());
      await tester.pump();

      expect(find.text('Members (2)'), findsOneWidget);
      expect(find.byType(AppDataTable<HouseholdMember>), findsOneWidget);
      expect(find.byType(AppShimmer), findsNothing);
      expect(find.text('John Doe'), findsOneWidget);
    },
  );

  testWidgets(
    'shimmers the table while a mutation is in flight and hides the data table',
    (tester) async {
      await tester.pumpWidget(wrap(isMutating: true));
      // The shimmer autoplays; pump fixed frames instead of pumpAndSettle.
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Members (2)'), findsOneWidget);
      expect(find.byType(AppDataTable<HouseholdMember>), findsNothing);
      expect(find.byType(AppShimmer), findsOneWidget);
      // The shimmer is announced as a loading live region.
      final loadingSemantics = tester.getSemantics(find.byType(AppShimmer));
      expect(loadingSemantics.label, 'Loading');
    },
  );
}
